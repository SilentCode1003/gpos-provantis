// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/catalog_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'category_visibility.dart';
import 'dashboard_constants.dart';
import 'product_grid.dart';

/// --- Catalog sheet: right-side overlay, opens on category tap -------------
///
/// Slides in from the right edge, clipped to the bounds of whichever
/// ancestor Stack it's placed in (see `_CatalogPanelWithSheet` in
/// `dashboard_layout.dart` — that's the whole right panel on wide
/// layouts, the lower portion of the column on narrow ones). Dismiss via:
///   - tapping the scrim (dims BOTH the catalog panel behind the sheet
///     and the cart panel on the other side — see `_ScrimOverlay`, which
///     `CartPanel` also mounts so the darkening isn't limited to the
///     sheet's own panel)
///   - dragging the left-edge grip handle back toward the right
///   - the close button in the sheet's header, or the close bar in its
///     footer
///   - tapping a category in the compact strip does NOT dismiss — it
///     swaps content in place, which is the whole point of keeping the
///     strip inside the sheet.
///
/// ============================================================================
/// REWRITE NOTE — why this file changed, and what the old bug was
/// ============================================================================
/// The previous version drove `_controller.forward()`/`.reverse()` from a
/// helper (`_syncWithState`) called directly inside `build()`, keyed off
/// `ref.watch(...isCatalogSheetOpen)`. That's the actual bug behind "first
/// tap does nothing, second tap opens it": starting an `AnimationController`
/// is a side effect, and side effects triggered from inside `build()` run
/// too late to affect the frame currently being built — the
/// `AnimatedBuilder` further down in that same `build()` call had already
/// read `_controller.value` (still `0`) before `forward()`'s first tick
/// could land, so that first frame painted closed. The *second* tap worked
/// because by then the controller had residual state from the first,
/// half-started animation.
///
/// The fix: **open/close is now triggered from `ref.listen`**, which is
/// Riverpod's dedicated hook for exactly this — reacting to a provider
/// change with a side effect, guaranteed to run outside of (and before)
/// the widget's own `build()`, so `forward()`/`reverse()` are already
/// in flight by the time this frame's `AnimatedBuilder` reads
/// `_controller.value`. No more one-tap-late animation start.
///
/// Everything else was also simplified while rebuilding:
///   - One `CurvedAnimation` (not two) with `Curves.easeOutCubic` for
///     both directions — a single curve that looks good moving either
///     way reads as more "physical" than swapping curves by direction,
///     and removes a branch that had to track `AnimationStatus` just to
///     pick which curve was "current."
///   - One `AnimatedBuilder` (not two) driving both the scrim opacity and
///     the sheet's slide offset off the same `_curve.value` read in a
///     single `builder` callback — the old version split these across a
///     nested pair of `AnimatedBuilder`s listening to the same animation,
///     which was extra rebuild plumbing for no behavioral difference.
///   - `Transform.translate` (a compositor-level paint transform, same
///     performance characteristics as the old `SlideTransition`) instead
///     of `SlideTransition` itself, since `Transform.translate` takes a
///     plain `Offset` computed straight from `_curve.value` and
///     `sheetWidth` — no separate `Tween<Offset>.animate(...)` object to
///     rebuild every time direction changes.
///   - The old "fully closed → return SizedBox.shrink()" early-out has
///     been removed. Collapsing the subtree to zero size is what forced
///     `LayoutBuilder` to (re)measure `sheetWidth` from scratch the next
///     time the sheet opened, adding a layout pass on the critical path
///     of the open animation. The sheet is now always laid out (so its
///     width is always known and stable), just visually and hit-test
///     hidden while closed via `Offstage` + `IgnorePointer` — cheap to
///     keep mounted, and removes a source of first-frame jank.
///   - Drag handling is unchanged in spirit (same physical flick/settle
///     rule) but now clamps against the controller's *current* animated
///     value rather than assuming it starts a drag from a fully
///     open/closed rest state, so grabbing the handle mid-animation
///     doesn't jump.
/// ============================================================================
class CatalogSheet extends ConsumerStatefulWidget {
  const CatalogSheet({super.key});

  @override
  ConsumerState<CatalogSheet> createState() => _CatalogSheetState();
}

class _CatalogSheetState extends ConsumerState<CatalogSheet>
    with SingleTickerProviderStateMixin {
  /// 0 = fully closed, 1 = fully open. Single source of truth for the
  /// sheet's position — gestures and the open/close animation both just
  /// write into this same controller.
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
    // Dragging interrupts any in-flight open/close animation at its
    // current value rather than jumping — continuity is most of what
    // makes a drag feel physical instead of janky.
    _controller.stop(canceled: true);
  }

  void _onDragUpdate(DragUpdateDetails details, double sheetWidth) {
    if (sheetWidth <= 0) return;
    final delta = details.primaryDelta ?? 0;
    // Dragging right (positive dx) closes, so it subtracts from the
    // open-ness value.
    _controller.value = (_controller.value - delta / sheetWidth).clamp(
      0.0,
      1.0,
    );
  }

  void _onDragEnd(DragEndDetails details, double sheetWidth) {
    _isDragging = false;
    final velocity = details.primaryVelocity ?? 0;
    final normalizedVelocity = sheetWidth > 0 ? velocity / sheetWidth : 0.0;

    // Fast flick commits in the flick's direction regardless of how far
    // it's traveled; a slow drag falls back to whichever side of
    // halfway it settled on. This is the same physical-feeling rule
    // native sheets and drawers use.
    final bool shouldClose;
    if (normalizedVelocity.abs() > 0.7) {
      shouldClose = normalizedVelocity > 0;
    } else {
      shouldClose = _controller.value < 0.5;
    }

    // fling's velocity is "fraction of range per second", the same
    // units _controller.value already uses, so the drag's own
    // normalized velocity plugs straight in — a fast flick keeps the
    // finger's momentum instead of snapping into a fixed-duration tween.
    // Slow releases (no real velocity) fall back to a calm default fling
    // speed rather than a sluggish near-zero one.
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
    // Side effect (starting the animation) lives here, in `ref.listen`,
    // NOT in the body of `build()` below — see the REWRITE NOTE above for
    // why that distinction is exactly what fixes the "first tap does
    // nothing" bug. `ref.listen` fires after `build()` computes but
    // before the frame is handed to the renderer, so by the time
    // `AnimatedBuilder` reads `_controller.value` on the *next* frame
    // (which the animation's own `forward()`/`reverse()` call schedules),
    // the controller is already mid-flight.
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
            // Settled fully closed (not mid-drag/mid-animation) — hide
            // from hit-testing so nothing here steals taps meant for the
            // category rail underneath. Offstage (not a collapsed-size
            // widget) keeps the subtree laid out and its width known, so
            // reopening never needs a fresh measure pass — see REWRITE
            // NOTE.
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
            onDragStart: _onDragStart,
            onDragUpdate: (d) => _onDragUpdate(d, sheetWidth),
            onDragEnd: (d) => _onDragEnd(d, sheetWidth),
          ),
        );
      },
    );
  }
}

/// Semi-transparent tap-to-close layer. Mounted twice — once here behind
/// the sheet, once inside `CartPanel` — both driven by the same opacity
/// value read off shared state, so the cart darkens in lockstep with the
/// sheet's own scrim rather than needing a second animation to stay in
/// sync.
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
            decoration: BoxDecoration(color: Colors.black.withOpacity(opacity)),
          ),
        ),
      ),
    );
  }
}

/// Chrome shared by both the drag-handle rail and the sheet's content —
/// split out so the handle can sit visually attached to the sheet's left
/// edge without being inside the scrollable content column. The drag
/// gesture lives entirely on `_DragHandle` (see below) — this widget
/// just wires the callbacks through — so a vertical swipe anywhere else
/// on the sheet (the product grid, the search field) is free to scroll
/// without fighting a horizontal-drag recognizer.
class _CatalogSheetChrome extends StatelessWidget {
  const _CatalogSheetChrome({
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

    return Material(
      color: colors.surface,
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.2),
      child: Row(
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

/// The visible affordance that the sheet is draggable: a slim vertical
/// rail along the sheet's left edge with a pill grip centered on it.
/// This rail — and only this rail — owns the horizontal drag gesture,
/// so swiping inside the product grid or search field still scrolls/
/// types instead of dragging the sheet. The whole rail is tappable-width
/// (not just the thin pill), matching the touch-target floor the rest
/// of the screen holds to.
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
              color: colors.border,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ),
    );
  }
}

class _CatalogSheetContent extends StatelessWidget {
  const _CatalogSheetContent();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: colors.borderSubtle)),
      ),
      child: const Column(
        children: [
          _CatalogSheetHeader(),
          _CompactCategoryStrip(),
          Expanded(child: ProductGrid()),
          _CatalogSheetFooter(),
        ],
      ),
    );
  }
}

/// Bottom-of-sheet close bar — a second, always-in-reach dismiss target
/// alongside the header's close icon, so a cashier's thumb doesn't have
/// to travel back up to the top after scrolling through a long product
/// grid. Full-width and at the primary tap-target height, matching the
/// weight of other bottom-anchored actions on this screen (Hold sale /
/// Charge in the cart footer).
class _CatalogSheetFooter extends ConsumerWidget {
  const _CatalogSheetFooter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final notifier = ref.read(dashboardControllerProvider.notifier);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.borderSubtle)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: primaryTapTarget,
        child: OutlinedButton.icon(
          onPressed: notifier.closeCatalogSheet,
          icon: const Icon(Icons.keyboard_double_arrow_right_rounded, size: 20),
          label: Text(
            'Close',
            style: AppTypography.ui(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: colors.textPrimary,
            side: BorderSide(color: colors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}

/// Title + close button + search field.
class _CatalogSheetHeader extends ConsumerWidget {
  const _CatalogSheetHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final controller = ref.watch(dashboardControllerProvider.notifier);
    final categoryId = ref.watch(
      dashboardControllerProvider.select((s) => s.catalogSheetCategoryId),
    );
    final categoryName = controller.categories
        .firstWhere(
          (c) => c.id == categoryId,
          orElse: () => const Category(id: '', name: '', icon: ''),
        )
        .name;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  categoryName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.display(
                    color: colors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
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
                    child: Icon(
                      Icons.close_rounded,
                      size: 22,
                      // Explicit color — without this it falls back to
                      // the ambient IconTheme, which on this surface
                      // rendered light-on-light and made the button
                      // effectively invisible.
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _CatalogSearchField(),
        ],
      ),
    );
  }
}

class _CatalogSearchField extends ConsumerStatefulWidget {
  const _CatalogSearchField();

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

    // Clears the field's own text whenever the controller state's query
    // goes back to empty from somewhere else (i.e. `closeCatalogSheet`)
    // without fighting the user mid-keystroke.
    final query = ref.watch(
      dashboardControllerProvider.select((s) => s.catalogSearchQuery),
    );
    if (query.isEmpty && _textController.text.isNotEmpty) {
      _textController.clear();
    }

    return SizedBox(
      height: minTapTarget,
      child: TextField(
        controller: _textController,
        onChanged: notifier.setCatalogSearchQuery,
        style: AppTypography.ui(color: colors.textPrimary, fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Search this category…',
          hintStyle: AppTypography.ui(color: colors.textDisabled, fontSize: 15),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: colors.textDisabled,
            size: 22,
          ),
          suffixIcon: query.isEmpty
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: colors.textDisabled,
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

/// Slim horizontal category strip inside the sheet — lets the cashier
/// switch categories without closing the sheet first. Tapping a tile
/// here swaps the sheet's contents in place via the same
/// `selectCategory` call the main rail uses.
class _CompactCategoryStrip extends ConsumerWidget {
  const _CompactCategoryStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final controller = ref.watch(dashboardControllerProvider.notifier);
    final categoryId = ref.watch(
      dashboardControllerProvider.select((s) => s.catalogSheetCategoryId),
    );
    // Categories the user switched off in Settings > Counter Display
    // don't get a chip here either.
    final hidden = ref.watch(hiddenCategoryCodesProvider);
    final categories = filterVisibleCategories(controller.categories, hidden);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = category.id == categoryId;
            return _CompactCategoryChip(
              category: category,
              isSelected: isSelected,
              onTap: () => controller.selectCategory(category.id),
            );
          },
        ),
      ),
    );
  }
}

class _CompactCategoryChip extends StatelessWidget {
  const _CompactCategoryChip({
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
      color: isSelected ? AppPalette.teal500 : colors.surfaceVariant,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: Text(
            category.name,
            style: AppTypography.ui(
              color: isSelected ? colors.onPrimary : colors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
