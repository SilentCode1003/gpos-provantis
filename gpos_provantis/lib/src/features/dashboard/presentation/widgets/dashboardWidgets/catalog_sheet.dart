import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'category_visibility.dart';
import 'dashboard_constants.dart';
import 'money_format.dart';
import 'product_grid.dart';

class CatalogSheet extends ConsumerStatefulWidget {
  const CatalogSheet({super.key});

  @override
  ConsumerState<CatalogSheet> createState() => _CatalogSheetState();
}

class _CatalogSheetState extends ConsumerState<CatalogSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curve;

  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: catalogSheetOpenDuration,
      reverseDuration: catalogSheetCloseDuration,
      value: ref.read(dashboardControllerProvider).isCatalogSheetOpen
          ? 1.0
          : 0.0,
    );
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _curve.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _openSheet() {
    if (_isDragging) return;
    _controller.forward();
  }

  void _closeSheet() {
    if (_isDragging) return;
    _controller.reverse();
  }

  void _onDragStart(DragStartDetails details) {
    _isDragging = true;

    _controller.stop(canceled: true);
  }

  void _onDragUpdate(DragUpdateDetails details, double sheetWidth) {
    if (sheetWidth <= 0) return;
    final delta = details.primaryDelta ?? 0;

    _controller.value = (_controller.value - delta / sheetWidth).clamp(
      0.0,
      1.0,
    );
  }

  void _onDragEnd(DragEndDetails details, double sheetWidth) {
    _isDragging = false;
    final velocity = details.primaryVelocity ?? 0;
    final normalizedVelocity = sheetWidth > 0 ? velocity / sheetWidth : 0.0;

    final bool shouldClose;
    if (normalizedVelocity.abs() > 0.7) {
      shouldClose = normalizedVelocity > 0;
    } else {
      shouldClose = _controller.value < 0.5;
    }

    final flingSpeed = normalizedVelocity.abs() > 0.1
        ? normalizedVelocity.abs().clamp(1.0, 8.0)
        : 4.0;

    if (shouldClose) {
      ref.read(dashboardControllerProvider.notifier).closeCatalogSheet();
      _controller.fling(velocity: -flingSpeed);
    } else {
      _controller.fling(velocity: flingSpeed);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      dashboardControllerProvider.select((s) => s.isCatalogSheetOpen),
      (previous, isOpen) {
        if (isOpen) {
          _openSheet();
        } else {
          _closeSheet();
        }
      },
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final sheetWidth = constraints.maxWidth;

        return AnimatedBuilder(
          animation: _curve,
          builder: (context, child) {
            final isSettledClosed =
                _curve.value <= 0 && !_controller.isAnimating && !_isDragging;

            return Offstage(
              offstage: isSettledClosed,
              child: IgnorePointer(
                ignoring: isSettledClosed,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _ScrimOverlay(
                      opacity: _curve.value * 0.32,
                      onTap: () => ref
                          .read(dashboardControllerProvider.notifier)
                          .closeCatalogSheet(),
                    ),
                    Transform.translate(
                      offset: Offset(sheetWidth * (1 - _curve.value), 0),
                      child: child,
                    ),
                  ],
                ),
              ),
            );
          },
          child: _CatalogSheetChrome(
            // Phones: no side drag handle and no bottom Close button (the X in
            // the header closes the sheet), so the grid gets the room.
            compact: sheetWidth < catalogCompactMaxWidth,
            onDragStart: _onDragStart,
            onDragUpdate: (d) => _onDragUpdate(d, sheetWidth),
            onDragEnd: (d) => _onDragEnd(d, sheetWidth),
          ),
        );
      },
    );
  }
}

class _ScrimOverlay extends StatelessWidget {
  const _ScrimOverlay({required this.opacity, required this.onTap});

  final double opacity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (opacity <= 0.005) return const SizedBox.shrink();

    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: IgnorePointer(
          ignoring: false,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: opacity),
            ),
          ),
        ),
      ),
    );
  }
}

class _CatalogSheetChrome extends StatelessWidget {
  const _CatalogSheetChrome({
    required this.compact,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  /// True on phones (see [catalogCompactMaxWidth]).
  final bool compact;
  final GestureDragStartCallback onDragStart;
  final GestureDragUpdateCallback onDragUpdate;
  final GestureDragEndCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.surface,
      // Dark surfaces swallow shadows, so there the edge is drawn by the
      // border in _CatalogSheetContent instead.
      elevation: colors.isDark ? 0 : 8,
      shadowColor: colors.shadow,
      child: compact
          // Phones: just the content, edge to edge. No swipe-to-close strip.
          ? const _CatalogSheetContent(compact: true)
          : Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _DragHandle(
                  onDragStart: onDragStart,
                  onDragUpdate: onDragUpdate,
                  onDragEnd: onDragEnd,
                ),
                const Expanded(child: _CatalogSheetContent()),
              ],
            ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle({
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  final GestureDragStartCallback onDragStart;
  final GestureDragUpdateCallback onDragUpdate;
  final GestureDragEndCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragStart: onDragStart,
        onHorizontalDragUpdate: onDragUpdate,
        onHorizontalDragEnd: onDragEnd,
        child: Container(
          width: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.surfaceVariant,
            border: Border(right: BorderSide(color: colors.borderSubtle)),
          ),
          child: Container(
            width: 5,
            height: 56,
            decoration: BoxDecoration(
              color: colors.textDisabled.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ),
    );
  }
}

class _CatalogSheetContent extends StatelessWidget {
  const _CatalogSheetContent({this.compact = false});

  /// Phones: no left edge line (the sheet is full width, there is no handle
  /// strip next to it) and no bottom Close button; the header's X closes it.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        border: compact
            ? null
            : Border(left: BorderSide(color: colors.borderSubtle)),
      ),
      child: Column(
        children: [
          // Phones: a one-row header (category dropdown, search button, X).
          compact ? const _CompactCatalogHeader() : const _CatalogSheetHeader(),
          Expanded(
            // The grid fills the whole area under the header and the category
            // notch floats on top of it, so products scroll behind the notch
            // (clipBehavior.none lets the notch overlap the header's border).
            // Phones have no notch: the categories are the header's dropdown.
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ProductGrid(compact: compact),
                if (!compact)
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: _CompactCategoryStrip(),
                  ),
              ],
            ),
          ),
          if (!compact) const _CatalogSheetFooter(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Footer
// ─────────────────────────────────────────────────────────────────────────────

class _CatalogSheetFooter extends ConsumerWidget {
  const _CatalogSheetFooter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final notifier = ref.read(dashboardControllerProvider.notifier);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.borderSubtle)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: primaryTapTarget,
        child: ElevatedButton.icon(
          onPressed: notifier.closeCatalogSheet,
          icon: const Icon(Icons.keyboard_double_arrow_right_rounded, size: 22),
          label: Text(
            'Close',
            style: AppTypography.ui(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.surfaceVariant,
            foregroundColor: colors.textPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: colors.border.withValues(alpha: 0.6)),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header + search
// ─────────────────────────────────────────────────────────────────────────────

// Built once; AppTypography goes through google_fonts on every call.
final TextStyle _summaryStyle = AppTypography.ui(
  fontSize: 13,
  fontWeight: FontWeight.w500,
).copyWith(fontFeatures: const [FontFeature.tabularFigures()]);

/// "123 items · 8 categories" (or results while searching), shown under the
/// category name. Null when there is nothing to say.
String? _catalogSummary({
  required int totalItems,
  required int categoryCount,
  required String query,
}) {
  if (totalItems > 0) {
    final noun = query.isEmpty
        ? (totalItems == 1 ? 'item' : 'items')
        : (totalItems == 1 ? 'result' : 'results');
    return '${formatCount(totalItems)} $noun · '
        '$categoryCount ${categoryCount == 1 ? 'category' : 'categories'}';
  }
  return query.isNotEmpty ? 'No results' : null;
}

class _CatalogSheetHeader extends ConsumerWidget {
  const _CatalogSheetHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final controller = ref.watch(dashboardControllerProvider.notifier);
    // Refresh if categories / products change (e.g. after a sync).
    ref.watch(catalogSourcesProvider);
    final openedCategoryId = ref.watch(
      dashboardControllerProvider.select((s) => s.catalogSheetCategoryId),
    );
    // Follows the section currently at the top of the grid.
    final categoryId =
        ref.watch(catalogActiveSectionProvider) ?? openedCategoryId;
    final categoryName = controller.categories
        .firstWhere(
          (c) => c.id == categoryId,
          orElse: () => const Category(id: '', name: '', icon: ''),
        )
        .name;

    // Totals for the indicator under the title. catalogSections is cached, so
    // this is the list the grid already built, not a second pass over every
    // product.
    final hidden = ref.watch(hiddenCategoryCodesProvider);
    final query = ref
        .watch(dashboardControllerProvider.select((s) => s.catalogSearchQuery))
        .trim();
    final sections = controller.catalogSections(
      filterVisibleCategories(controller.categories, hidden),
    );
    final totalItems = sections.fold<int>(
      0,
      (sum, section) => sum + section.products.length,
    );

    final summary = _catalogSummary(
      totalItems: totalItems,
      categoryCount: sections.length,
      query: query,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 8, 14),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      categoryName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.display(
                        color: colors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                    ),
                    // Total items in the whole grid (or matches, while
                    // searching), across every category.
                    if (summary != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          summary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _summaryStyle.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: controller.closeCatalogSheet,
                  customBorder: const CircleBorder(),
                  child: SizedBox(
                    width: minTapTarget,
                    height: minTapTarget,
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.surfaceVariant,
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 22,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: _CatalogSearchField(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Phone header: category dropdown + search button + close (X), one row
// ─────────────────────────────────────────────────────────────────────────────

/// The phone version of [_CatalogSheetHeader], built to give the product list
/// as much height as possible:
///
///  * one row instead of title + always-visible search field (~55px shorter);
///  * the category name doubles as a dropdown: it follows the grid as it
///    scrolls and, tapped, lists every category with its product count so one
///    tap jumps to it (this replaces the chip strip that floated over the grid);
///  * a search button opens the search field below the row (and closes it
///    again); closing it also clears the search so no hidden filter is left
///    narrowing the list;
///  * the X stays where it was, at the right.
class _CompactCatalogHeader extends ConsumerStatefulWidget {
  const _CompactCatalogHeader();

  @override
  ConsumerState<_CompactCatalogHeader> createState() =>
      _CompactCatalogHeaderState();
}

class _CompactCatalogHeaderState extends ConsumerState<_CompactCatalogHeader> {
  bool _searchOpen = false;

  void _toggleSearch() {
    if (_searchOpen) {
      final notifier = ref.read(dashboardControllerProvider.notifier);
      if (ref.read(dashboardControllerProvider).catalogSearchQuery.isNotEmpty) {
        notifier.setCatalogSearchQuery('');
      }
      FocusManager.instance.primaryFocus?.unfocus();
    }
    setState(() => _searchOpen = !_searchOpen);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final controller = ref.watch(dashboardControllerProvider.notifier);
    // Refresh if categories / products change (e.g. after a sync).
    ref.watch(catalogSourcesProvider);

    // Closing the sheet clears the search (see the grid), so fold the bar away
    // too; it opens fresh next time.
    ref.listen(
      dashboardControllerProvider.select((s) => s.isCatalogSheetOpen),
      (previous, isOpen) {
        if (!isOpen && _searchOpen) setState(() => _searchOpen = false);
      },
    );

    final openedCategoryId = ref.watch(
      dashboardControllerProvider.select((s) => s.catalogSheetCategoryId),
    );
    // Follows the section currently at the top of the grid.
    final categoryId =
        ref.watch(catalogActiveSectionProvider) ?? openedCategoryId;
    final categoryName = controller.categories
        .firstWhere(
          (c) => c.id == categoryId,
          orElse: () => const Category(id: '', name: '', icon: ''),
        )
        .name;

    final hidden = ref.watch(hiddenCategoryCodesProvider);
    final query = ref
        .watch(dashboardControllerProvider.select((s) => s.catalogSearchQuery))
        .trim();
    // Same cached list the grid built. The dropdown lists exactly these, so
    // every entry has a section to jump to (while searching, only categories
    // with matches).
    final sections = controller.catalogSections(
      filterVisibleCategories(controller.categories, hidden),
    );
    final totalItems = sections.fold<int>(
      0,
      (sum, section) => sum + section.products.length,
    );
    final summary = _catalogSummary(
      totalItems: totalItems,
      categoryCount: sections.length,
      query: query,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 6, 8, 8),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: _CategoryDropdown(
                  activeId: categoryId,
                  name: categoryName,
                  summary: summary,
                  sections: sections,
                ),
              ),
              _HeaderCircleButton(
                icon: Icons.search_rounded,
                tooltip: _searchOpen ? 'Close search' : 'Search products',
                // Lit while the bar is open or a search is active.
                selected: _searchOpen || query.isNotEmpty,
                onTap: _toggleSearch,
              ),
              _HeaderCircleButton(
                icon: Icons.close_rounded,
                tooltip: 'Close',
                onTap: controller.closeCatalogSheet,
              ),
            ],
          ),
          // Slides open / shut under the row; the field takes focus as soon as
          // it appears so the keyboard comes up ready to type.
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: _searchOpen
                ? const Padding(
                    padding: EdgeInsets.fromLTRB(0, 4, 8, 0),
                    child: _CatalogSearchField(autofocus: true),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

/// A round header button (search, close): 40px circle in a [minTapTarget] hit
/// area, the same look as the X in the wide header.
class _HeaderCircleButton extends StatelessWidget {
  const _HeaderCircleButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  /// Highlighted (e.g. the search button while the bar is open).
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: minTapTarget,
            height: minTapTarget,
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? colors.primaryContainer
                      : colors.surfaceVariant,
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: selected
                      ? colors.onPrimaryContainer
                      : colors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The category name with a chevron; tapping it opens a menu of every
/// category (with its product count) and jumps the grid to the one picked.
/// With only one category there is nothing to pick, so it's just the title.
class _CategoryDropdown extends ConsumerWidget {
  const _CategoryDropdown({
    required this.activeId,
    required this.name,
    required this.summary,
    required this.sections,
  });

  final String? activeId;
  final String name;
  final String? summary;
  final List<CatalogSection> sections;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final canPick = sections.length > 1;

    // Name + chevron over the summary line: about 45px, so it fits the 48px
    // row the buttons set and costs no extra height.
    final label = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                name,
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
            if (canPick) ...[
              const SizedBox(width: 2),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 24,
                color: colors.textSecondary,
              ),
            ],
          ],
        ),
        if (summary != null)
          Text(
            summary!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _summaryStyle.copyWith(color: colors.textSecondary),
          ),
      ],
    );

    final content = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: minTapTarget),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: label,
        ),
      ),
    );

    if (!canPick) return content;

    // The Material clips the tap ripple to rounded corners.
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: PopupMenuButton<String>(
        tooltip: 'Jump to category',
        position: PopupMenuPosition.under,
        offset: const Offset(0, 4),
        color: colors.surfaceRaised,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colors.borderSubtle),
        ),
        constraints: const BoxConstraints(minWidth: 220, maxWidth: 320),
        onSelected: (id) =>
            ref.read(catalogScrollRequestProvider.notifier).request(id),
        itemBuilder: (context) => [
          for (final section in sections)
            PopupMenuItem<String>(
              value: section.category.id,
              child: _CategoryMenuRow(
                name: section.category.name,
                count: section.products.length,
                selected: section.category.id == activeId,
              ),
            ),
        ],
        child: content,
      ),
    );
  }
}

class _CategoryMenuRow extends StatelessWidget {
  const _CategoryMenuRow({
    required this.name,
    required this.count,
    required this.selected,
  });

  final String name;
  final int count;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.ui(
              color: selected ? colors.primary : colors.textPrimary,
              fontSize: 15,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          formatCount(count),
          style: _summaryStyle.copyWith(color: colors.textSecondary),
        ),
        if (selected) ...[
          const SizedBox(width: 8),
          Icon(Icons.check_rounded, size: 18, color: colors.primary),
        ],
      ],
    );
  }
}

class _CatalogSearchField extends ConsumerStatefulWidget {
  const _CatalogSearchField({this.autofocus = false});

  /// Take focus (and raise the keyboard) as soon as the field appears.
  final bool autofocus;

  @override
  ConsumerState<_CatalogSearchField> createState() =>
      _CatalogSearchFieldState();
}

class _CatalogSearchFieldState extends ConsumerState<_CatalogSearchField> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: ref.read(dashboardControllerProvider).catalogSearchQuery,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final notifier = ref.read(dashboardControllerProvider.notifier);

    final query = ref.watch(
      dashboardControllerProvider.select((s) => s.catalogSearchQuery),
    );
    if (query.isEmpty && _textController.text.isNotEmpty) {
      _textController.clear();
    }

    const noBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide.none,
    );

    return SizedBox(
      height: minTapTarget,
      child: TextField(
        controller: _textController,
        autofocus: widget.autofocus,
        onChanged: notifier.setCatalogSearchQuery,
        style: AppTypography.ui(color: colors.textPrimary, fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Search all products…',
          hintStyle: AppTypography.ui(color: colors.textDisabled, fontSize: 15),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: colors.textSecondary,
            size: 22,
          ),
          suffixIcon: query.isEmpty
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: colors.textSecondary,
                    size: 20,
                  ),
                  onPressed: () {
                    _textController.clear();
                    notifier.setCatalogSearchQuery('');
                  },
                ),
          filled: true,
          fillColor: colors.surfaceVariant,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: noBorder,
          enabledBorder: noBorder,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: colors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Category chips
// ─────────────────────────────────────────────────────────────────────────────

class _CompactCategoryStrip extends ConsumerStatefulWidget {
  const _CompactCategoryStrip();

  @override
  ConsumerState<_CompactCategoryStrip> createState() =>
      _CompactCategoryStripState();
}

class _CompactCategoryStripState extends ConsumerState<_CompactCategoryStrip> {
  final _chipKeys = <String, GlobalKey>{};

  GlobalKey _keyFor(String categoryId) =>
      _chipKeys.putIfAbsent(categoryId, () => GlobalKey());

  /// Slides the strip so the active chip stays in view (and centered when it
  /// can be) while the grid is scrolled.
  void _revealChip(String? categoryId) {
    if (categoryId == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chipContext = _chipKeys[categoryId]?.currentContext;
      if (chipContext == null || !chipContext.mounted) return;
      Scrollable.ensureVisible(
        chipContext,
        alignment: 0.5,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final controller = ref.watch(dashboardControllerProvider.notifier);
    // Refresh if categories / products change (e.g. after a sync).
    ref.watch(catalogSourcesProvider);
    final openedCategoryId = ref.watch(
      dashboardControllerProvider.select((s) => s.catalogSheetCategoryId),
    );
    // The chip that's highlighted follows the grid as it scrolls.
    final activeCategoryId =
        ref.watch(catalogActiveSectionProvider) ?? openedCategoryId;

    ref.listen<String?>(catalogActiveSectionProvider, (previous, next) {
      _revealChip(next);
    });

    final hidden = ref.watch(hiddenCategoryCodesProvider);
    final categories = filterVisibleCategories(controller.categories, hidden);

    // A "notch" hanging from the header: same color as the header, rounded
    // bottom corners, and little flares where it meets the header's edge.
    // heightFactor: 1 so it is only as tall as the notch (a plain Center
    // would stretch to fill the Stack).
    return Align(
      alignment: Alignment.topCenter,
      heightFactor: 1,
      child: Transform.translate(
        // Overlaps the header's 1px bottom border so the two read as one piece.
        offset: const Offset(0, -1),
        // Its own paint layer: the blurred shadow isn't re-drawn while the grid
        // scrolls underneath.
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _NotchPainter(
              fill: colors.surface,
              stroke: colors.borderSubtle,
              // Lifts the notch above the products scrolling behind it. A touch
              // stronger in dark mode, where shadows are harder to see.
              shadow: Colors.black.withValues(
                alpha: colors.isDark ? 0.32 : 0.14,
              ),
              flareRadius: _notchFlareRadius,
              cornerRadius: _notchCornerRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                _notchFlareRadius + 12,
                7,
                _notchFlareRadius + 12,
                12,
              ),
              // Rounds off the scrolling area too, so chips slide under curved
              // ends instead of being cut by a straight edge.
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 40,
                  // A plain scroll view (not a lazy list) so every chip exists
                  // and can be scrolled into view. There are only a handful.
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        for (var i = 0; i < categories.length; i++) ...[
                          if (i > 0) const SizedBox(width: 8),
                          _CompactCategoryChip(
                            key: _keyFor(categories[i].id),
                            category: categories[i],
                            isSelected: categories[i].id == activeCategoryId,
                            // Asks the grid to glide to this category's section.
                            onTap: () => ref
                                .read(catalogScrollRequestProvider.notifier)
                                .request(categories[i].id),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// How far the notch flares out where it meets the header, and how round its
/// bottom corners are. Tweak these two to taste.
const double _notchFlareRadius = 18;
const double _notchCornerRadius = 26;

/// Draws the notch: flat on top (where it joins the header), curved flares
/// out to each side, straight sides, and rounded bottom corners.
class _NotchPainter extends CustomPainter {
  const _NotchPainter({
    required this.fill,
    required this.stroke,
    required this.shadow,
    required this.flareRadius,
    required this.cornerRadius,
  });

  final Color fill;
  final Color stroke;
  final Color shadow;
  final double flareRadius;
  final double cornerRadius;

  /// Outline of the notch, running right flare -> down -> across -> up ->
  /// left flare. [closed] adds the flat top edge (for the fill only; the
  /// border is drawn without it so it doesn't cut across the header).
  Path _outline(Size size, {required bool closed}) {
    final w = size.width;
    final h = size.height;
    final f = flareRadius;
    final c = cornerRadius;

    final path = Path()
      ..moveTo(w, 0)
      // Right flare (concave).
      ..arcToPoint(
        Offset(w - f, f),
        radius: Radius.circular(f),
        clockwise: false,
      )
      ..lineTo(w - f, h - c)
      // Bottom-right corner (convex).
      ..arcToPoint(Offset(w - f - c, h), radius: Radius.circular(c))
      ..lineTo(f + c, h)
      // Bottom-left corner (convex).
      ..arcToPoint(Offset(f, h - c), radius: Radius.circular(c))
      ..lineTo(f, f)
      // Left flare (concave).
      ..arcToPoint(Offset.zero, radius: Radius.circular(f), clockwise: false);

    if (closed) path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final shape = _outline(size, closed: true);

    // Soft shadow, cast downward only. The clip starts just under the top
    // edge so the shadow never smudges the header the notch hangs from.
    canvas.save();
    canvas.clipRect(
      Rect.fromLTRB(-size.width, 1, size.width * 2, size.height + 80),
    );
    canvas.drawPath(
      shape.shift(const Offset(0, 5)),
      Paint()
        ..color = shadow
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
    );
    canvas.restore();

    canvas.drawPath(
      shape,
      Paint()
        ..color = fill
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      _outline(size, closed: false),
      Paint()
        ..color = stroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _NotchPainter old) =>
      old.fill != fill ||
      old.stroke != stroke ||
      old.shadow != shadow ||
      old.flareRadius != flareRadius ||
      old.cornerRadius != cornerRadius;
}

class _CompactCategoryChip extends StatelessWidget {
  const _CompactCategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: isSelected ? colors.primary : colors.surfaceVariant,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.center,
          child: Text(
            category.name,
            style: AppTypography.ui(
              color: isSelected ? colors.onPrimary : colors.textSecondary,
              fontSize: 13.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
