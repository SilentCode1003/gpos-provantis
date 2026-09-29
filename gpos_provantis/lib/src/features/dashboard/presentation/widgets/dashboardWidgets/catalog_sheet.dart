import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'category_visibility.dart';
import 'dashboard_constants.dart';
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
            decoration: BoxDecoration(color: Colors.black.withOpacity(opacity)),
          ),
        ),
      ),
    );
  }
}

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

class _CompactCategoryStrip extends ConsumerWidget {
  const _CompactCategoryStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final controller = ref.watch(dashboardControllerProvider.notifier);
    final categoryId = ref.watch(
      dashboardControllerProvider.select((s) => s.catalogSheetCategoryId),
    );

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
