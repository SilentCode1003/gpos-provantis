import 'dart:async';
import 'dart:io' show File;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:gpos_provantis/src/core/database/providers/product_image_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/settings_dao_provider.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'category_visibility.dart';
import 'dashboard_constants.dart';
import 'money_format.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shared state between the grid and the category strip
// ─────────────────────────────────────────────────────────────────────────────

/// Which category section is currently at the top of the grid. The category
/// strip and the sheet title read this so they follow the scrolling.
/// `null` until the grid has worked it out.
class CatalogActiveSection extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? categoryId) {
    if (state != categoryId) state = categoryId;
  }
}

final catalogActiveSectionProvider =
    NotifierProvider<CatalogActiveSection, String?>(CatalogActiveSection.new);

/// "Please scroll to this category." The [nonce] makes every request unique,
/// so tapping the same category twice (after scrolling away) still works.
class CatalogScrollRequest {
  const CatalogScrollRequest(this.categoryId, this.nonce);

  final String categoryId;
  final int nonce;
}

class CatalogScrollRequestNotifier extends Notifier<CatalogScrollRequest?> {
  int _counter = 0;

  @override
  CatalogScrollRequest? build() => null;

  void request(String categoryId) {
    state = CatalogScrollRequest(categoryId, ++_counter);
  }
}

final catalogScrollRequestProvider =
    NotifierProvider<CatalogScrollRequestNotifier, CatalogScrollRequest?>(
      CatalogScrollRequestNotifier.new,
    );

// ─────────────────────────────────────────────────────────────────────────────
// Layout numbers
//
// The grid is lazy (only what's near the screen gets built), so to scroll to a
// category that is far away we can't ask a widget where it is. Instead the
// height of every section is calculated from these numbers. Anything that
// changes the grid's spacing or sizes MUST change here too.
// ─────────────────────────────────────────────────────────────────────────────

const double _gridHorizontalPadding = 20;
const double _gridGap = 16;
const double _maxTileExtent = 220;
const double _tileAspectRatio = 1.05;

const double _headerExtent = 56;
const double _gridTopPadding = 4;
const double _sectionBottomPadding = 20;

/// Product cards with a picture are taller than plain ones: the picture sits
/// at the top, full width, and the name / price block below it keeps a fixed
/// height. So the picture grows with the tile: wide tiles get a big one.
/// Tiles narrower than [_minTileWidthForImage] have no room for a useful
/// picture and keep the plain card. Services / packages / add-ons have no
/// pictures and always use the plain card.
///
/// These feed the scroll maths below, so the grid and [_GridLayout] always
/// agree on every tile's size.
const double _imageTileAspectRatio = 0.75;
const double _minTileWidthForImage = 170;
const double _imageInset = 8;
const double _cardTextAreaHeight = 120;
const double _maxImageHeight = 160;

bool _sectionHasImages(CatalogSection s, double imageHeight) =>
    imageHeight > 0 && s.products.isNotEmpty && !s.products.first.isService;

double _sectionTileHeight(bool images, double tileWidth, double imageHeight) =>
    images
    ? imageHeight + _imageInset * 2 + _cardTextAreaHeight
    : tileWidth / _tileAspectRatio;

/// A section counts as "current" once its header is within this many pixels
/// of the top edge.
const double _spyLead = 48;

/// How long the lightweight placeholder cards stay up after the sheet starts
/// opening: the slide-in animation plus a small margin, so the real cards are
/// built once the sheet has stopped moving (a heavy frame during the slide is
/// what shows up as a stutter on a weak device).
final Duration _skeletonHold =
    catalogSheetOpenDuration + const Duration(milliseconds: 60);

/// Off-screen build buffer once everything has settled.
const double _warmCacheExtent = 400;

/// Height of the category "notch" that floats over the top of the grid
/// (see catalog_sheet.dart). The grid leaves this much empty room at its top
/// so nothing starts hidden under the notch, then scrolls beneath it.
/// Must equal the notch's real height: 7 (top padding) + 40 (chips) +
/// 12 (bottom padding) = 59.
const double catalogNotchHeight = 59;

// Text styles are built ONCE here. AppTypography goes through google_fonts,
// which does real work on every call, and doing that several times per card on
// every build adds up on a weak device. Cards just recolor these with
// copyWith.
//
// Weights: the name is medium and the price semibold. With hundreds of
// products on screen, two heavy weights side by side are tiring to read, and
// the price is the one thing the cashier must catch at a glance.
final TextStyle _productNameStyle = AppTypography.ui(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  height: 1.3,
);
final TextStyle _skuStyle = AppTypography.ui(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  height: 1.2,
);
final TextStyle _priceStyle = AppTypography.ui(
  fontSize: 18,
  fontWeight: FontWeight.w600,
).copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
final TextStyle _badgeCountStyle = AppTypography.ui(
  fontSize: 14,
  fontWeight: FontWeight.w600,
).copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
final TextStyle _outOfStockStyle = AppTypography.ui(
  fontSize: 12,
  fontWeight: FontWeight.w600,
);

class ProductGrid extends ConsumerWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(dashboardControllerProvider.notifier);

    // Rebuild ONLY when the catalog's data or the search text changes. It
    // used to watch the whole dashboard state, so every cart tap, and the
    // moment the sheet opened, re-grouped every product. That was the lag.
    ref.watch(catalogSourcesProvider);
    final query = ref
        .watch(dashboardControllerProvider.select((s) => s.catalogSearchQuery))
        .trim();
    final hidden = ref.watch(hiddenCategoryCodesProvider);

    final status = controller.catalogProductsStatus;
    if (status == CatalogLoadStatus.loading) {
      return const _StateMessage(loading: true, message: 'Loading products…');
    }

    if (status == CatalogLoadStatus.error) {
      return _StateMessage(
        icon: Icons.error_outline_rounded,
        message: 'Couldn\u2019t load products.',
      );
    }

    final visibleCategories = filterVisibleCategories(
      controller.categories,
      hidden,
    );
    final sections = controller.catalogSections(visibleCategories);

    if (sections.isEmpty) {
      final hasQuery = query.isNotEmpty;
      return _StateMessage(
        icon: hasQuery ? Icons.search_off_rounded : PhosphorIcons.shapes,
        message: hasQuery
            ? 'No products match your search.'
            : 'No products yet.',
      );
    }

    return _SectionedGrid(sections: sections, query: query);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// The sectioned grid
// ─────────────────────────────────────────────────────────────────────────────

class _SectionedGrid extends ConsumerStatefulWidget {
  const _SectionedGrid({required this.sections, required this.query});

  final List<CatalogSection> sections;
  final String query;

  @override
  ConsumerState<_SectionedGrid> createState() => _SectionedGridState();
}

class _SectionedGridState extends ConsumerState<_SectionedGrid> {
  final _scrollController = ScrollController();

  _GridLayout _layout = _GridLayout.empty;

  /// True while a tap-to-scroll animation is running, so the scroll-spy
  /// doesn't flicker the highlighted chip through every section in between.
  bool _isAnimating = false;
  int _scrollToken = 0;

  // Staged reveal ("buffering") after the sheet is opened:
  //  1. light placeholder cards while the sheet slides in,
  //  2. real cards, ONLY the ones on screen,
  //  3. a frame later, the extra off-screen cards too.
  bool _showSkeleton = false;
  bool _warm = true;
  Timer? _revealTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncActiveFromOffset();
    });
  }

  @override
  void didUpdateWidget(covariant _SectionedGrid oldWidget) {
    super.didUpdateWidget(oldWidget);

    // A new search shows a different list, so start again from the top.
    if (oldWidget.query != widget.query) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_scrollController.hasClients) return;
        // Closing the sheet clears the query too; don't yank the grid to the
        // top while it's still sliding away.
        final isSheetOpen =
            ref.read(dashboardControllerProvider).catalogSheetCategoryId !=
            null;
        if (!isSheetOpen) return;
        _scrollToken++;
        _isAnimating = false;
        _scrollController.jumpTo(0);
        _syncActiveFromOffset();
      });
    }
  }

  @override
  void dispose() {
    _revealTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _beginStagedReveal() {
    _revealTimer?.cancel();
    setState(() {
      _showSkeleton = true;
      _warm = false;
    });

    _revealTimer = Timer(_skeletonHold, () {
      if (!mounted) return;
      // Real cards, but only those on screen (cache extent is 0 for now).
      setState(() => _showSkeleton = false);
      // Next frame: build the extra off-screen cards, spreading the work out
      // instead of doing it all in one frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _warm = true);
      });
    });
  }

  void _onScroll() {
    if (_isAnimating) return;
    _syncActiveFromOffset();
  }

  /// Marks the section under the top edge as the active one.
  void _syncActiveFromOffset() {
    if (!_scrollController.hasClients || _layout.sectionIds.isEmpty) return;
    final index = _layout.sectionIndexAt(_scrollController.offset + _spyLead);
    ref
        .read(catalogActiveSectionProvider.notifier)
        .set(_layout.sectionIds[index]);
  }

  void _scrollToSection(String categoryId, {required bool animate}) {
    final index = _layout.sectionIds.indexOf(categoryId);
    if (index < 0 || !_scrollController.hasClients) return;

    final position = _scrollController.position;
    final target = _layout.starts[index].clamp(0.0, position.maxScrollExtent);
    final distance = (target - position.pixels).abs();

    ref.read(catalogActiveSectionProvider.notifier).set(categoryId);

    final token = ++_scrollToken;
    if (!animate || distance < 1) {
      _isAnimating = false;
      _scrollController.jumpTo(target);
      return;
    }

    // Longer trips take a little longer, but never feel slow or instant.
    final milliseconds = (320 + distance * 0.18).clamp(380.0, 900.0).round();

    _isAnimating = true;
    _scrollController
        .animateTo(
          target,
          duration: Duration(milliseconds: milliseconds),
          // Eases in AND out: starts gently, glides, and settles softly.
          curve: Curves.easeInOutCubic,
        )
        .whenComplete(() {
          // Also runs if the user grabs the list mid-animation.
          if (!mounted || token != _scrollToken) return;
          _isAnimating = false;
          _syncActiveFromOffset();
        });
  }

  @override
  Widget build(BuildContext context) {
    // Read once here and handed to every card as a plain callback, so cards
    // don't each need their own provider connection.
    final notifier = ref.read(dashboardControllerProvider.notifier);

    // A category chip was tapped: glide to its section.
    ref.listen<CatalogScrollRequest?>(catalogScrollRequestProvider, (
      previous,
      next,
    ) {
      if (next != null) _scrollToSection(next.categoryId, animate: true);
    });

    // The sheet was just opened from a category tile: jump straight to that
    // category (no animation, the sheet itself is sliding in).
    ref.listen<String?>(
      dashboardControllerProvider.select((s) => s.catalogSheetCategoryId),
      (previous, next) {
        if (previous == null && next != null) {
          _beginStagedReveal();
          _scrollToSection(next, animate: false);
        }
      },
    );

    // Settings > Product Images > Show product images. Off = plain cards, the
    // same layout as before pictures existed.
    final showImages = ref.watch(showProductImagesProvider);

    return _CartQuantitiesScope(
      child: _ProductImagesScope(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final layout = _GridLayout.compute(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              sections: widget.sections,
              showImages: showImages,
            );
            _layout = layout;

            // Decode pictures at their real on-screen pixel size, never bigger.
            final imageCachePx =
                (layout.tileWidth * MediaQuery.devicePixelRatioOf(context))
                    .round();

            return CustomScrollView(
              controller: _scrollController,
              // Momentum scrolling that glides to a stop and gives a soft bounce
              // at the very top / bottom, instead of halting dead.
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              // Builds a bit beyond the screen so cards are already there when a
              // fast fling arrives.
              cacheExtent: _warm ? _warmCacheExtent : 0,
              slivers: [
                // Room for the notch that floats over the top of the grid.
                const SliverToBoxAdapter(
                  child: SizedBox(height: catalogNotchHeight),
                ),
                for (final section in widget.sections) ...[
                  SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: section.category.name,
                      count: section.products.length,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      _gridHorizontalPadding,
                      _gridTopPadding,
                      _gridHorizontalPadding,
                      _sectionBottomPadding,
                    ),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: layout.columns,
                        mainAxisSpacing: _gridGap,
                        crossAxisSpacing: _gridGap,
                        childAspectRatio: layout.aspectFor(section),
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = section.products[index];
                          // 0 = plain card (no picture area).
                          final imageHeight = layout.hasImages(section)
                              ? layout.imageHeight
                              : 0.0;
                          if (_showSkeleton) {
                            return _SkeletonCard(imageHeight: imageHeight);
                          }
                          return _ProductCard(
                            key: ValueKey(product.id),
                            product: product,
                            imageHeight: imageHeight,
                            imageCachePx: imageCachePx,
                            onTap: () => notifier.addToCart(product),
                          );
                        },
                        childCount: section.products.length,
                        // Cards don't need to stay alive off-screen; skipping the
                        // keep-alive wrappers is less work per card.
                        addAutomaticKeepAlives: false,
                      ),
                    ),
                  ),
                ],
                // Lets even the last (short) section scroll all the way up to the
                // top, so tapping its chip lands exactly on it.
                SliverToBoxAdapter(child: SizedBox(height: layout.tail)),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Works out where every section starts, using the same maths the grid uses
/// to lay out its tiles. See the note above [_gridHorizontalPadding].
class _GridLayout {
  const _GridLayout({
    required this.columns,
    required this.sectionIds,
    required this.starts,
    required this.tail,
    required this.tileWidth,
    required this.imageHeight,
  });

  static const empty = _GridLayout(
    columns: 1,
    sectionIds: [],
    starts: [],
    tail: 0,
    tileWidth: 0,
    imageHeight: 0,
  );

  final int columns;
  final List<String> sectionIds;

  /// Scroll offset at which each section's header sits at the top edge.
  final List<double> starts;

  /// Extra space after the last section (see the filler in the grid).
  final double tail;

  final double tileWidth;

  /// Height of the picture area on product cards at this screen width, or 0
  /// when the tiles are too narrow for one.
  final double imageHeight;

  bool hasImages(CatalogSection s) => _sectionHasImages(s, imageHeight);

  double tileHeightFor(CatalogSection s) =>
      _sectionTileHeight(hasImages(s), tileWidth, imageHeight);

  double aspectFor(CatalogSection s) {
    final h = tileHeightFor(s);
    return h <= 0 ? _tileAspectRatio : tileWidth / h;
  }

  factory _GridLayout.compute({
    required double width,
    required double height,
    required List<CatalogSection> sections,
    bool showImages = true,
  }) {
    final crossExtent = math.max(0.0, width - _gridHorizontalPadding * 2);
    final columns = math.max(
      1,
      (crossExtent / (_maxTileExtent + _gridGap)).ceil(),
    );
    final tileWidth =
        math.max(0.0, crossExtent - _gridGap * (columns - 1)) / columns;

    final imageHeight = showImages && tileWidth >= _minTileWidthForImage
        ? math.min(
            _maxImageHeight,
            tileWidth / _imageTileAspectRatio -
                _imageInset * 2 -
                _cardTextAreaHeight,
          )
        : 0.0;

    final ids = <String>[];
    final starts = <double>[];
    var cursor = 0.0;
    var lastExtent = 0.0;

    for (final section in sections) {
      final tileHeight = _sectionTileHeight(
        _sectionHasImages(section, imageHeight),
        tileWidth,
        imageHeight,
      );
      final rows = (section.products.length / columns).ceil();
      final gridHeight = rows == 0
          ? 0.0
          : rows * tileHeight + (rows - 1) * _gridGap;
      final extent =
          _headerExtent + _gridTopPadding + gridHeight + _sectionBottomPadding;

      ids.add(section.category.id);
      starts.add(cursor);
      cursor += extent;
      lastExtent = extent;
    }

    return _GridLayout(
      columns: columns,
      tileWidth: tileWidth,
      imageHeight: imageHeight,
      sectionIds: ids,
      starts: starts,
      tail: math.max(
        _sectionBottomPadding,
        height - lastExtent - catalogNotchHeight,
      ),
    );
  }

  /// Index of the last section that starts at or above [position].
  int sectionIndexAt(double position) {
    for (var i = starts.length - 1; i > 0; i--) {
      if (starts[i] <= position) return i;
    }
    return 0;
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: _headerExtent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          _gridHorizontalPadding,
          0,
          _gridHorizontalPadding,
          8,
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.display(
                    color: colors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$count',
                  style:
                      AppTypography.ui(
                        color: colors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ).copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Divider(
                  height: 1,
                  color: colors.border.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One loading / error / empty message for the whole grid.
class _StateMessage extends StatelessWidget {
  const _StateMessage({this.icon, required this.message, this.loading = false});

  final IconData? icon;
  final String message;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.surfaceVariant,
              ),
              child: loading
                  ? SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: colors.primary,
                      ),
                    )
                  : Icon(icon, size: 32, color: colors.textSecondary),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.ui(
                color: colors.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Cheap stand-in for a product card, shown while the sheet slides in. Just a
/// few plain boxes: no ripple, no text layout, no provider watching.
class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({this.imageHeight = 0});

  /// Same picture area the real card will have (0 = plain card).
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    Widget bar(double widthFactor, double height) => FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );

    final bars = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        bar(0.8, 14),
        const SizedBox(height: 8),
        bar(0.5, 14),
        const Spacer(),
        bar(0.4, 18),
      ],
    );

    final decoration = BoxDecoration(
      color: colors.surfaceRaised,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: colors.border.withValues(alpha: 0.4)),
    );

    if (imageHeight > 0) {
      return Container(
        decoration: decoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(_imageInset),
              child: Container(
                height: imageHeight,
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  _imageInset + 4,
                  0,
                  _imageInset + 2,
                  10,
                ),
                child: bars,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: decoration,
      child: bars,
    );
  }
}

/// How many of each product are in the cart, shared with every card through
/// ONE inherited widget. A card asks for just its own product, so when the
/// cart changes only the cards whose count changed rebuild, and no card needs
/// its own Riverpod subscription (that was a real cost per card on a weak
/// device, paid every time a card scrolled into view).
class _CartQuantities extends InheritedModel<String> {
  const _CartQuantities({required this.quantities, required super.child});

  final Map<String, int> quantities;

  static int of(BuildContext context, String productId) {
    final model = InheritedModel.inheritFrom<_CartQuantities>(
      context,
      aspect: productId,
    );
    return model?.quantities[productId] ?? 0;
  }

  @override
  bool updateShouldNotify(_CartQuantities oldWidget) =>
      !identical(quantities, oldWidget.quantities);

  @override
  bool updateShouldNotifyDependent(
    _CartQuantities oldWidget,
    Set<String> dependencies,
  ) {
    for (final id in dependencies) {
      if (quantities[id] != oldWidget.quantities[id]) return true;
    }
    return false;
  }
}

class _CartQuantitiesScope extends ConsumerWidget {
  const _CartQuantitiesScope({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lines = ref.watch(
      dashboardControllerProvider.select((s) => s.cartLines),
    );
    return _CartQuantities(
      quantities: {for (final line in lines) line.product.id: line.quantity},
      child: child,
    );
  }
}

/// A product card, kept deliberately light: no Material / ink-ripple layer, no
/// provider subscription, no animation controller. Pressing tints the card
/// instantly instead of rippling, which also feels snappier on slow hardware.
class _ProductCard extends StatefulWidget {
  const _ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.imageHeight = 0,
    this.imageCachePx = 0,
  });

  final Product product;
  final VoidCallback onTap;

  /// Height of the picture area at the top of the card, or 0 for a plain card.
  final double imageHeight;
  final int imageCachePx;

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final product = widget.product;

    final inCart = _CartQuantities.of(context, product.id);
    final isOutOfStock = !product.isAvailable;
    final isInCart = inCart > 0 && !isOutOfStock;

    var fill = isOutOfStock
        ? colors.disabledFill
        : isInCart
        ? Color.alphaBlend(
            colors.primaryContainer.withValues(alpha: 0.35),
            colors.surfaceRaised,
          )
        : colors.surfaceRaised;
    if (_pressed && !isOutOfStock) {
      fill = Color.alphaBlend(colors.primary.withValues(alpha: 0.12), fill);
    }

    final textColor = isOutOfStock ? colors.textDisabled : colors.textPrimary;

    // Name, SKU and price: the same in both card styles.
    final details = <Widget>[
      // The name yields space first: it's clipped (never the price) if the
      // card is too short for everything. The SKU is laid out first and
      // always shows; the name takes whatever height is left.
      Expanded(
        child: ClipRect(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  product.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: _productNameStyle.copyWith(color: textColor),
                ),
              ),
              if (product.sku.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  product.sku,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _skuStyle.copyWith(
                    color: isOutOfStock
                        ? colors.textDisabled
                        : colors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      const SizedBox(height: 8),
      // Out of stock sits ABOVE the price, so the price always gets the
      // card's full width.
      if (isOutOfStock) ...[
        _OutOfStockTag(colors: colors),
        const SizedBox(height: 6),
      ],
      Row(
        children: [
          Expanded(
            child: _PriceText(price: product.price, color: textColor),
          ),
          if (!isOutOfStock) ...[
            const SizedBox(width: 8),
            _AddBadge(quantity: inCart, colors: colors),
          ],
        ],
      ),
    ];

    final showImage = widget.imageHeight > 0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isOutOfStock ? null : widget.onTap,
      onTapDown: isOutOfStock ? null : (_) => _setPressed(true),
      onTapUp: isOutOfStock ? null : (_) => _setPressed(false),
      onTapCancel: isOutOfStock ? null : () => _setPressed(false),
      child: Container(
        constraints: const BoxConstraints(minHeight: primaryTapTarget),
        padding: showImage
            ? EdgeInsets.zero
            : const EdgeInsets.fromLTRB(16, 16, 12, 12),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(18),
          border: isOutOfStock
              ? null
              : Border.all(
                  color: isInCart
                      ? colors.primary
                      : colors.border.withValues(alpha: 0.6),
                  width: isInCart ? 1.5 : 1,
                ),
        ),
        child: showImage
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Picture area. Selecting the product never waits on it: the
                  // card is tappable from its first frame and the picture
                  // fills in later.
                  Padding(
                    padding: const EdgeInsets.all(_imageInset),
                    child: _ProductThumb(
                      productId: int.tryParse(product.id),
                      height: widget.imageHeight,
                      cachePx: widget.imageCachePx,
                      dimmed: isOutOfStock,
                      placeholder: colors.surfaceVariant,
                      iconColor: colors.textDisabled,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        _imageInset + 4,
                        0,
                        _imageInset + 2,
                        10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: details,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: details,
              ),
      ),
    );
  }
}

/// The full price, always. If it's too wide for the space it shrinks to fit
/// rather than ending in "…", since a cut-off price is a pricing mistake
/// waiting to happen at the till.
class _PriceText extends StatelessWidget {
  const _PriceText({required this.price, required this.color});

  final double price;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        formatPeso(price),
        maxLines: 1,
        softWrap: false,
        style: _priceStyle.copyWith(color: color),
      ),
    );
  }
}

/// Decorative "+" that turns into a count once the product is in the cart.
/// The whole card is the tap target, so this isn't tappable on its own.
class _AddBadge extends StatelessWidget {
  const _AddBadge({required this.quantity, required this.colors});

  final int quantity;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final inCart = quantity > 0;

    return Container(
      constraints: const BoxConstraints(minWidth: 36),
      height: 36,
      padding: EdgeInsets.symmetric(horizontal: inCart ? 10 : 0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: inCart ? colors.primary : colors.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: inCart
          ? Text(
              '\u00d7$quantity',
              style: _badgeCountStyle.copyWith(color: colors.onPrimary),
            )
          : Icon(
              PhosphorIcons.plus,
              size: 18,
              color: colors.onPrimaryContainer,
            ),
    );
  }
}

class _OutOfStockTag extends StatelessWidget {
  const _OutOfStockTag({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.border.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'Out of stock',
        style: _outOfStockStyle.copyWith(color: colors.textDisabled),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Product pictures
// ─────────────────────────────────────────────────────────────────────────────

/// productId -> picture file, shared with every card through ONE inherited
/// widget (same idea as [_CartQuantities]). When the background sync saves
/// more pictures, only the thumbnails whose own file changed rebuild; no card
/// has a Riverpod subscription of its own.
class _ProductImages extends InheritedModel<int> {
  const _ProductImages({required this.paths, required super.child});

  final Map<int, String> paths;

  static String? of(BuildContext context, int productId) {
    final model = InheritedModel.inheritFrom<_ProductImages>(
      context,
      aspect: productId,
    );
    return model?.paths[productId];
  }

  @override
  bool updateShouldNotify(_ProductImages oldWidget) =>
      !identical(paths, oldWidget.paths);

  @override
  bool updateShouldNotifyDependent(
    _ProductImages oldWidget,
    Set<int> dependencies,
  ) {
    for (final id in dependencies) {
      if (paths[id] != oldWidget.paths[id]) return true;
    }
    return false;
  }
}

class _ProductImagesScope extends ConsumerWidget {
  const _ProductImagesScope({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Throttled upstream (see productImagePathsProvider), so a sync saving
    // hundreds of pictures updates the grid in a few batches, not hundreds of
    // times.
    final paths =
        ref.watch(productImagePathsProvider).value ?? const <int, String>{};
    return _ProductImages(paths: paths, child: child);
  }
}

/// The picture of one product, full width of the card. A plain grey box until
/// the file is known and decoded; then the picture draws over it. Deliberately
/// static: no shimmer or fade animation, because dozens of animating
/// placeholders repaint every frame, which is exactly what a weak device can't
/// afford.
///
/// The whole picture is always visible (BoxFit.contain): nothing is cropped, so
/// the cashier sees the product itself. Change to BoxFit.cover to fill the box
/// edge to edge at the cost of trimming the picture's top and bottom.
///
/// Image.file is used (not a raw decoder) on purpose: it decodes off the UI
/// thread, and it holds back loading while the list is being flung, loading
/// the pictures once scrolling slows down.
class _ProductThumb extends StatelessWidget {
  const _ProductThumb({
    required this.productId,
    required this.height,
    required this.cachePx,
    required this.dimmed,
    required this.placeholder,
    required this.iconColor,
  });

  final int? productId;
  final double height;
  final int cachePx;
  final bool dimmed;
  final Color placeholder;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final id = productId;
    final path = id == null ? null : _ProductImages.of(context, id);
    final radius = BorderRadius.circular(12);

    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(color: placeholder, borderRadius: radius),
        child: path == null
            ? Icon(
                Icons.image_outlined,
                size: math.min(40.0, height * 0.4),
                color: iconColor.withValues(alpha: 0.5),
              )
            : ClipRRect(
                borderRadius: radius,
                child: Image.file(
                  File(path),
                  width: double.infinity,
                  height: height,
                  fit: BoxFit.contain,
                  cacheWidth: cachePx > 0 ? cachePx : null,
                  // Pictures are shown larger than their source, so smooth
                  // the scaling instead of leaving hard pixels.
                  filterQuality: FilterQuality.medium,
                  gaplessPlayback: true,
                  // Out-of-stock: faded without an Opacity layer.
                  color: dimmed ? const Color(0x73FFFFFF) : null,
                  colorBlendMode: dimmed ? BlendMode.modulate : null,
                  // A missing / corrupt file just leaves the grey box.
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
      ),
    );
  }
}
