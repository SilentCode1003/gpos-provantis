import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:gpos_provantis/src/shared/widgets/confirm_dialog.dart';
import 'category_visibility.dart';
import 'others_sheet.dart';
import 'top_bar.dart';

class CatalogPanel extends ConsumerWidget {
  const CatalogPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    return Container(
      color: colors.background,
      child: const Column(
        children: [
          TopBar(),
          _ActionsRail(),
          Expanded(child: _CategoryGrid()),
        ],
      ),
    );
  }
}

class _ActionsRail extends ConsumerWidget {
  const _ActionsRail();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    final state = ref.watch(dashboardControllerProvider);
    final notifier = ref.read(dashboardControllerProvider.notifier);
    final isShiftOpen = notifier.shiftStatus == ShiftStatus.open;
    final isToggling = state.isTogglingShift;

    Future<void> handleShiftTap() async {
      final confirmed = await showConfirmDialog(
        context,
        title: isShiftOpen ? 'End shift?' : 'Start shift?',
        body: isShiftOpen
            ? 'This will close the current shift. Cash drop, Reprint and '
                  'Others will be unavailable until you start a new one.'
            : 'This will open a new shift so you can begin taking sales.',
        confirmLabel: isShiftOpen ? 'END SHIFT' : 'START SHIFT',
      );

      if (confirmed != true || !context.mounted) return;

      try {
        await notifier.toggleShift();
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isShiftOpen
                  ? 'Failed to end shift: $error'
                  : 'Failed to start shift: $error',
            ),
          ),
        );
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _ActionButton(
              icon: isShiftOpen ? PhosphorIcons.stop : PhosphorIcons.play,
              label: isShiftOpen ? 'End shift' : 'Start shift',
              emphasized: !isShiftOpen,
              enabled: !isToggling,
              loading: isToggling,
              onTap: handleShiftTap,
            ),
            const SizedBox(width: 10),
            _ActionButton(
              icon: PhosphorIcons.cashRegister,
              label: 'Cash drop',
              enabled: isShiftOpen,
              onTap: () {},
            ),
            const SizedBox(width: 10),
            _ActionButton(
              icon: PhosphorIcons.printer,
              label: 'Reprint',
              enabled: isShiftOpen,
              onTap: () {},
            ),
            const SizedBox(width: 10),
            _ActionButton(
              icon: PhosphorIcons.gear,
              label: 'Settings',
              onTap: () {},
            ),
            const SizedBox(width: 10),
            _ActionButton(
              icon: PhosphorIcons.gridNine,
              label: 'Others',
              enabled: isShiftOpen,
              onTap: () => OthersSheet.show(context),
            ),
          ],
        ),
      ),
    );
  }
}

const double _actionsRailTapTarget = 72;

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.emphasized = false,
    this.enabled = true,
    this.loading = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool emphasized;
  final bool enabled;

  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fill = emphasized ? AppPalette.teal500 : colors.surfaceVariant;
    final foreground = emphasized ? colors.onPrimary : colors.textPrimary;

    return Material(
      color: enabled ? fill : colors.disabledFill,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: _actionsRailTapTarget,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (loading)
                SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: enabled ? foreground : colors.textDisabled,
                  ),
                )
              else
                Icon(
                  icon,
                  size: 26,
                  color: enabled ? foreground : colors.textDisabled,
                ),
              const SizedBox(width: 10),
              Text(
                label,
                style: AppTypography.ui(
                  color: enabled ? foreground : colors.textDisabled,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryGrid extends ConsumerWidget {
  const _CategoryGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    ref.watch(dashboardControllerProvider);
    final controller = ref.watch(dashboardControllerProvider.notifier);
    final status = controller.categoriesStatus;
    final hidden = ref.watch(hiddenCategoryCodesProvider);

    final settingsLoading = ref.watch(
      appSettingsProvider.select((s) => s.isLoading && !s.hasValue),
    );
    final allCategories = controller.categories;
    final categories = filterVisibleCategories(allCategories, hidden);

    if (status == CatalogLoadStatus.loading || settingsLoading) {
      return _CatalogLoadingState(colors: colors);
    }

    if (status == CatalogLoadStatus.error) {
      return _CatalogErrorState(colors: colors);
    }

    if (categories.isEmpty) {
      return allCategories.isEmpty
          ? _CatalogEmptyState(colors: colors)
          : _CatalogAllHiddenState(colors: colors);
    }

    final paintCategories = <Category>[];
    final productCategories = <Category>[];
    for (final category in categories) {
      if (category.name.toLowerCase().contains('paint')) {
        paintCategories.add(category);
      } else {
        productCategories.add(category);
      }
    }

    return CustomScrollView(
      slivers: [
        if (paintCategories.isNotEmpty) ...[
          _GroupHeader(label: 'Paint'),
          _CategorySliverGrid(
            categories: paintCategories,
            onTap: controller.selectCategory,
          ),
        ],
        if (productCategories.isNotEmpty) ...[
          _GroupHeader(label: 'Products'),
          _CategorySliverGrid(
            categories: productCategories,
            onTap: controller.selectCategory,
          ),
        ],

        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Text(
          label,
          style: AppTypography.ui(
            color: colors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}

class _CategorySliverGrid extends StatelessWidget {
  const _CategorySliverGrid({required this.categories, required this.onTap});

  final List<Category> categories;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 160,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final category = categories[index];
          return _CategoryTile(
            category: category,
            onTap: () => onTap(category.id),
          );
        }, childCount: categories.length),
      ),
    );
  }
}

class _CatalogLoadingState extends StatelessWidget {
  const _CatalogLoadingState({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading categories…',
              textAlign: TextAlign.center,
              style: AppTypography.ui(color: colors.textDisabled, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _CatalogErrorState extends StatelessWidget {
  const _CatalogErrorState({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIcons.exclamationMark,
              size: 40,
              color: colors.textDisabled,
            ),
            const SizedBox(height: 12),
            Text(
              'Couldn\'t load categories.',
              textAlign: TextAlign.center,
              style: AppTypography.ui(color: colors.textDisabled, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _CatalogEmptyState extends StatelessWidget {
  const _CatalogEmptyState({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(PhosphorIcons.shapes, size: 40, color: colors.textDisabled),
            const SizedBox(height: 12),
            Text(
              'No categories yet',
              textAlign: TextAlign.center,
              style: AppTypography.ui(color: colors.textDisabled, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _CatalogAllHiddenState extends StatelessWidget {
  const _CatalogAllHiddenState({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.visibility_off_rounded,
              size: 40,
              color: colors.textDisabled,
            ),
            const SizedBox(height: 12),
            Text(
              'All categories are hidden.\n'
              'Turn them on in Settings > Counter Display.',
              textAlign: TextAlign.center,
              style: AppTypography.ui(color: colors.textDisabled, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});

  final Category category;
  final VoidCallback onTap;

  static const _iconMap = {
    'water_drop_rounded': PhosphorIcons.chatTeardrop,
    'account_balance_rounded': PhosphorIcons.money,
    'landscape_rounded': PhosphorIcons.island,
    'chair_rounded': PhosphorIcons.chair,
    'yard_rounded': PhosphorIcons.park,
    'park_rounded': PhosphorIcons.park,
    'format_paint_rounded': PhosphorIcons.paintBrush,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final icon = _iconMap[category.icon] ?? PhosphorIcons.shapes;

    return Material(
      color: colors.surfaceVariant,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 116,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 26, color: colors.textSecondary),
              const SizedBox(height: 8),
              Text(
                category.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.ui(
                  color: colors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
