// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/catalog_panel.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'others_sheet.dart';
import 'top_bar.dart';

/// --- Catalog panel (right): top bar + actions row + category rail ---------
///
/// No product grid here anymore — tapping a category opens `CatalogSheet`
/// instead, which is stacked on top of this panel by
/// `CatalogPanelWithSheet`. This panel just needs something to fill the
/// space below the rail so the background doesn't look empty/unfinished
/// when the sheet is closed.
///
/// The actions row (Start/End shift, Cash drop, Reprint, Settings,
/// Others) used to live inside `TopBar` itself. It's a second row here
/// now so the top bar can be status-only (branch, time, shift, OR
/// number) — see `top_bar.dart`'s doc comment. Same buttons, same
/// behavior, same touchscreen-sized pill styling; only the location and
/// the widget names (`_ActionsRail`/`_ActionButton`, not
/// `_TopBarButton`) changed.

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
          _CategoryRail(),
          Expanded(child: _CatalogPlaceholder()),
        ],
      ),
    );
  }
}

/// --- Actions row: shift toggle, cash drop, reprint, settings, others -----
///
/// Relocated from `TopBar` — same five actions, same behavior, same
/// touchscreen pill sizing (`_actionsRailTapTarget`, a step above
/// `primaryTapTarget` for the same reason the old top bar row was: this
/// cluster is tapped constantly mid-shift). Only the surrounding chrome
/// (own row, own background) is new, since it's no longer sharing space
/// with the profile icon.
class _ActionsRail extends ConsumerWidget {
  const _ActionsRail();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final state = ref.watch(dashboardControllerProvider);
    final notifier = ref.read(dashboardControllerProvider.notifier);
    final isShiftOpen = state.shiftStatus == ShiftStatus.open;

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
              icon: isShiftOpen
                  ? Icons.stop_circle_outlined
                  : Icons.play_circle_outline_rounded,
              label: isShiftOpen ? 'End shift' : 'Start shift',
              emphasized: !isShiftOpen,
              onTap: notifier.toggleShift,
            ),
            const SizedBox(width: 10),
            _ActionButton(
              icon: Icons.payments_outlined,
              label: 'Cash drop',
              enabled: isShiftOpen,
              onTap: () {},
            ),
            const SizedBox(width: 10),
            _ActionButton(
              icon: Icons.print_outlined,
              label: 'Reprint',
              enabled: isShiftOpen,
              onTap: () {},
            ),
            const SizedBox(width: 10),
            _ActionButton(
              icon: Icons.settings_outlined,
              label: 'Settings',
              onTap: () {},
            ),
            const SizedBox(width: 10),
            _ActionButton(
              icon: Icons.apps_rounded,
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

/// A step above [primaryTapTarget] — touchscreen POS, and every button in
/// this row (shift toggle, cash drop, reprint, others) is a
/// high-frequency action, so it errs on the side of bigger rather than
/// sitting at the shared cross-app floor. Scoped to this row only, same
/// as the old `_topBarTapTarget` it replaces — deliberately not a change
/// to `primaryTapTarget` itself, which other screens still rely on at
/// its original size.
const double _actionsRailTapTarget = 72;

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.emphasized = false,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool emphasized;
  final bool enabled;

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

/// Shown below the category rail when the sheet is closed — a quiet
/// prompt rather than dead empty space.
class _CatalogPlaceholder extends StatelessWidget {
  const _CatalogPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.touch_app_outlined,
              size: 40,
              color: colors.textDisabled,
            ),
            const SizedBox(height: 12),
            Text(
              'Tap a category to browse products',
              textAlign: TextAlign.center,
              style: AppTypography.ui(color: colors.textDisabled, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

/// --- Category rail ----------------------------------------------------------

class _CategoryRail extends ConsumerWidget {
  const _CategoryRail();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final controller = ref.watch(dashboardControllerProvider.notifier);
    final state = ref.watch(dashboardControllerProvider);
    // Highlight follows whichever category the sheet is showing while
    // it's open (kept in sync with `selectedCategoryId` by
    // `selectCategory`, but reading the sheet field directly is the
    // more honest source of truth for "what's on screen right now").
    final highlightedId =
        state.catalogSheetCategoryId ?? state.selectedCategoryId;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: SizedBox(
        height: 96,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            final isSelected = category.id == highlightedId;
            return _CategoryTile(
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

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  static const _iconMap = {
    'water_drop_rounded': Icons.water_drop_rounded,
    'account_balance_rounded': Icons.account_balance_rounded,
    'landscape_rounded': Icons.landscape_rounded,
    'chair_rounded': Icons.chair_rounded,
    'yard_rounded': Icons.yard_rounded,
    'park_rounded': Icons.park_rounded,
    'format_paint_rounded': Icons.format_paint_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final icon = _iconMap[category.icon] ?? Icons.category_rounded;

    return Material(
      color: isSelected ? AppPalette.teal500 : colors.surfaceVariant,
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
              Icon(
                icon,
                size: 26,
                color: isSelected ? colors.onPrimary : colors.textSecondary,
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.ui(
                  color: isSelected ? colors.onPrimary : colors.textSecondary,
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
