import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:gpos_provantis/src/core/database/providers/printer_dao_provider.dart'
    show cashDrawerEnabledProvider;
import 'package:gpos_provantis/src/shared/widgets/confirm_dialog.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/widgets/dashboardWidgets/others_sheet/denomination_count_sheet.dart';
import 'category_visibility.dart';
import 'dashboard_constants.dart';
import 'others_action_runner.dart';
import 'others_sheet.dart';
import 'others_usage_provider.dart';
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

// ─────────────────────────────────────────────────────────────────────────────
// Actions rail
// ─────────────────────────────────────────────────────────────────────────────

class _ActionsRail extends ConsumerWidget {
  const _ActionsRail();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    final state = ref.watch(dashboardControllerProvider);
    final notifier = ref.read(dashboardControllerProvider.notifier);
    final isShiftOpen = notifier.shiftStatus == ShiftStatus.open;
    final isToggling = state.isTogglingShift;
    // Cash drop needs a physical drawer: off when no enabled printer has one.
    final hasCashDrawer = ref.watch(cashDrawerEnabledProvider);

    // The 3 most-used actions from the Others sheet, pinned beside the shift
    // button. Before anything has been tapped they follow the sheet's order.
    final usage = ref.watch(othersUsageProvider);
    final pinnedActions = topOtherActions(notifier.otherActions, usage);

    // The drawer count is collected BEFORE the shift starts or ends, and only
    // when a printer with a cash drawer is enabled. If the sheet is dismissed
    // (or cancelled) the controller does nothing and returns cancelled=true,
    // so the count cannot be skipped by closing the sheet. The controller also
    // records the count itself: no recordShiftDrawerCount call is needed here.
    Future<void> handleShiftTap() async {
      debugPrint(
        '[CashDrawer] handleShiftTap: tapped, isShiftOpen=$isShiftOpen',
      );

      final confirmed = await showConfirmDialog(
        context,
        title: isShiftOpen ? 'End shift?' : 'Start shift?',
        body: isShiftOpen
            ? 'This will close the current shift. The quick action buttons '
                  'and Others will be unavailable until you start a new one.'
            : 'This will open a new shift so you can begin taking sales.',
        confirmLabel: isShiftOpen ? 'END SHIFT' : 'START SHIFT',
      );
      debugPrint('[CashDrawer] confirm dialog resolved: confirmed=$confirmed');

      if (confirmed != true || !context.mounted) {
        debugPrint(
          '[CashDrawer] aborting: confirmed=$confirmed mounted=${context.mounted}',
        );
        return;
      }

      // Called by the controller only when a cash drawer is enabled.
      Future<DenominationCountResult?> requestDrawerCount(
        bool isStartOfShift,
      ) async {
        if (!context.mounted) return null;
        return DenominationCountSheet.show(
          context,
          title: isStartOfShift ? 'Start-of-shift count' : 'End-of-shift count',
          subtitle: isStartOfShift
              ? 'Count the float in the drawer before you begin'
              : 'Count the cash left in the drawer before closing out',
          totalLabel: 'Total counted',
          submitLabel: 'CONFIRM COUNT',
          allowZeroTotal: true,
        );
      }

      final actionWord = isShiftOpen ? 'end' : 'start';
      try {
        debugPrint('[CashDrawer] $actionWord-shift: calling toggleShift()');
        final result = await notifier.toggleShift(
          requestDrawerCount: requestDrawerCount,
        );
        debugPrint(
          '[CashDrawer] $actionWord-shift: toggleShift() returned, '
          'cancelled=${result.cancelled}',
        );
        if (!context.mounted) return;

        if (result.cancelled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Drawer count is required to $actionWord the shift. '
                'The shift was not ${isShiftOpen ? 'ended' : 'started'}.',
              ),
            ),
          );
          return;
        }

        if (result.unrecordedCount != null) {
          // Shift started, but the controller was rebuilt mid-call so the
          // opening count could not be attached to the new shift.
          debugPrint(
            '[CashDrawer] start-shift: controller rebuilt mid-call; '
            'shift opened but the drawer count was not recorded',
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Shift started, but the opening drawer count could not be '
                'saved. Please contact support if this keeps happening.',
              ),
            ),
          );
          return;
        }

        if (result.drawerCountError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Shift ${isShiftOpen ? 'ended' : 'started'}, but the drawer '
                'count could not be saved: ${result.drawerCountError}',
              ),
            ),
          );
        }
      } catch (error, stackTrace) {
        debugPrint(
          '[CashDrawer] $actionWord-shift FAILED: $error\n$stackTrace',
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to $actionWord shift: $error')),
        );
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Start = the call to action (filled teal). End = a calm red tint,
            // so the two states can't be confused at a glance.
            _ActionButton(
              icon: isShiftOpen ? PhosphorIcons.stop : PhosphorIcons.play,
              label: isShiftOpen ? 'End shift' : 'Start shift',
              tone: isShiftOpen ? _ActionTone.danger : _ActionTone.primary,
              enabled: !isToggling,
              loading: isToggling,
              onTap: handleShiftTap,
            ),
            for (final action in pinnedActions) ...[
              const SizedBox(width: 10),
              _ActionButton(
                icon: otherActionIcon(action.icon),
                label: action.label,
                enabled:
                    isShiftOpen &&
                    !(isCashDrawerAction(action.id) && !hasCashDrawer),
                onTap: () => runOtherAction(context, ref, action),
              ),
            ],
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

enum _ActionTone { neutral, primary, danger }

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.tone = _ActionTone.neutral,
    this.enabled = true,
    this.loading = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final _ActionTone tone;
  final bool enabled;

  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final Color fill;
    final Color foreground;
    final Color iconColor;
    switch (tone) {
      case _ActionTone.primary:
        fill = colors.primary;
        foreground = colors.onPrimary;
        iconColor = colors.onPrimary;
      case _ActionTone.danger:
        fill = colors.danger.withValues(alpha: 0.12);
        foreground = colors.danger;
        iconColor = colors.danger;
      case _ActionTone.neutral:
        fill = colors.surfaceVariant;
        foreground = colors.textPrimary;
        iconColor = colors.primary;
    }

    final fg = enabled ? foreground : colors.textDisabled;
    final ic = enabled ? iconColor : colors.textDisabled;

    return Material(
      color: enabled ? fill : colors.disabledFill,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: tone == _ActionTone.neutral && enabled
            ? BorderSide(color: colors.border.withValues(alpha: 0.5))
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: _actionsRailTapTarget,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (loading)
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5, color: ic),
                )
              else
                Icon(icon, size: 24, color: ic),
              const SizedBox(width: 12),
              Text(
                label,
                style: AppTypography.ui(
                  color: fg,
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

// ─────────────────────────────────────────────────────────────────────────────
// Categories
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryGrid extends ConsumerWidget {
  const _CategoryGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      return const _StateMessage(loading: true, message: 'Loading categories…');
    }

    if (status == CatalogLoadStatus.error) {
      return _StateMessage(
        icon: PhosphorIcons.exclamationMark,
        message: 'Couldn\u2019t load categories.',
      );
    }

    if (categories.isEmpty) {
      return allCategories.isEmpty
          ? _StateMessage(
              icon: PhosphorIcons.shapes,
              message: 'No categories yet',
            )
          : const _StateMessage(
              icon: Icons.visibility_off_rounded,
              message:
                  'All categories are hidden.\n'
                  'Turn them on in Settings > Counter Display.',
            );
    }

    final paintCategories = <Category>[];
    final productCategories = <Category>[];
    final serviceCategories = <Category>[];
    for (final category in categories) {
      if (isServiceCategoryId(category.id)) {
        serviceCategories.add(category);
      } else if (category.name.toLowerCase().contains('paint')) {
        paintCategories.add(category);
      } else {
        productCategories.add(category);
      }
    }

    return CustomScrollView(
      slivers: [
        if (paintCategories.isNotEmpty) ...[
          const _GroupHeader(label: 'Paint'),
          _CategorySliverGrid(
            categories: paintCategories,
            onTap: controller.selectCategory,
          ),
        ],
        if (productCategories.isNotEmpty) ...[
          const _GroupHeader(label: 'Products'),
          _CategorySliverGrid(
            categories: productCategories,
            onTap: controller.selectCategory,
          ),
        ],
        if (serviceCategories.isNotEmpty) ...[
          const _GroupHeader(label: 'Services'),
          _CategorySliverGrid(
            categories: serviceCategories,
            onTap: controller.selectCategory,
          ),
        ],

        // Keeps the last row clear of the floating barcode bar.
        const SliverToBoxAdapter(child: SizedBox(height: barcodeBarClearance)),
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
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
        child: Row(
          children: [
            Text(
              label.toUpperCase(),
              style: AppTypography.ui(
                color: colors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
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

/// One loading / error / empty message for the whole panel.
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

/// Signature shape: three soft corners and one sharp one (top-left).
/// To move the point, swap which corner gets `Radius.zero`.
const BorderRadius _categoryTileRadius = BorderRadius.only(
  topLeft: Radius.zero,
  topRight: Radius.circular(24),
  bottomLeft: Radius.circular(24),
  bottomRight: Radius.circular(24),
);

/// The icon badge repeats the same motif at a smaller scale.
const BorderRadius _categoryBadgeRadius = BorderRadius.only(
  topLeft: Radius.zero,
  topRight: Radius.circular(16),
  bottomLeft: Radius.circular(16),
  bottomRight: Radius.circular(16),
);

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
    'services_rounded': PhosphorIcons.wrench,
    'service_package_rounded': PhosphorIcons.package,
    'addon_rounded': PhosphorIcons.plusCircle,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final icon = _iconMap[category.icon] ?? PhosphorIcons.shapes;

    return Material(
      color: colors.surfaceRaised,
      shape: RoundedRectangleBorder(
        borderRadius: _categoryTileRadius,
        side: BorderSide(color: colors.border.withValues(alpha: 0.6)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: _categoryTileRadius,
        splashColor: colors.primary.withValues(alpha: 0.12),
        highlightColor: colors.primary.withValues(alpha: 0.06),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: _categoryBadgeRadius,
                ),
                child: Icon(icon, size: 24, color: colors.onPrimaryContainer),
              ),
              const SizedBox(height: 10),
              Text(
                category.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.ui(
                  color: colors.textPrimary,
                  fontSize: 13.5,
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
