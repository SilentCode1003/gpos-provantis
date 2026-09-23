// Location: src/features/settings/panels/counter_display_panel.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/database/providers/categories_dao_provider.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import '../controllers/app_settings_controller.dart';
import '../screens/settings_shared.dart';

/// Counter Display section — one toggle per category, deciding whether
/// that category (and its products) shows on the main screen.
///
/// The category list is dynamic: it comes straight from
/// `categoriesProvider`, so whatever the sync saves to the database
/// shows up here automatically.
///
/// Every tap is saved right away to the `counterDisplay` column (see
/// `CounterDisplayCodec` for the format). There is no Save button.
/// The main screen can read the result with `hiddenCategoryCodesProvider`.
class CounterDisplayPanel extends ConsumerWidget {
  const CounterDisplayPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final categoriesAsync = ref.watch(categoriesProvider);
    final hidden = ref.watch(hiddenCategoryCodesProvider);
    final controller = ref.read(appSettingsProvider.notifier);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Space.xxxl,
        Space.xxl,
        Space.xxxl,
        Space.xxxl,
      ),
      children: [
        const PanelHeader(
          title: 'Counter Display',
          subtitle: 'Choose which categories show on the main screen',
        ),
        const SizedBox(height: Space.lg),
        categoriesAsync.when(
          loading: () => const _StateMessage(
            icon: Icons.hourglass_top_rounded,
            message: 'Loading categories...',
          ),
          error: (error, _) => const _StateMessage(
            icon: Icons.error_outline_rounded,
            message: 'Could not load categories.',
            isError: true,
          ),
          data: (categories) {
            if (categories.isEmpty) {
              return const _StateMessage(
                icon: Icons.category_outlined,
                message: 'No categories yet. Sync to load them.',
              );
            }

            final codes = categories.map((c) => c.categoryCode).toList();
            final shownCount = codes.where((c) => !hidden.contains(c)).length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BulkActionsRow(
                  shownCount: shownCount,
                  totalCount: categories.length,
                  onShowAll: () =>
                      controller.setManyCategoriesVisible(codes, true),
                  onHideAll: () =>
                      controller.setManyCategoriesVisible(codes, false),
                ),
                const SizedBox(height: Space.md),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: colors.borderSubtle),
                    color: colors.surface,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (var i = 0; i < categories.length; i++) ...[
                        if (i > 0)
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: colors.borderSubtle,
                          ),
                        _CategoryToggleTile(
                          name: categories[i].categoryName,
                          value: !hidden.contains(categories[i].categoryCode),
                          onChanged: (value) => controller.setCategoryVisible(
                            categories[i].categoryCode,
                            value,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: Space.md),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Space.xs),
                  child: Text(
                    'Hidden categories and their products will not appear '
                    'on the main screen. New categories show by default.',
                    style: AppTypography.ui(
                      fontSize: 13,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// "3 of 8 shown" summary plus Show all / Hide all shortcuts.
class _BulkActionsRow extends StatelessWidget {
  const _BulkActionsRow({
    required this.shownCount,
    required this.totalCount,
    required this.onShowAll,
    required this.onHideAll,
  });

  final int shownCount;
  final int totalCount;
  final VoidCallback onShowAll;
  final VoidCallback onHideAll;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.xs),
            child: Text(
              '$shownCount of $totalCount shown',
              style: AppTypography.ui(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
          ),
        ),
        _BulkButton(label: 'Show all', onTap: onShowAll),
        const SizedBox(width: Space.sm),
        _BulkButton(label: 'Hide all', onTap: onHideAll),
      ],
    );
  }
}

class _BulkButton extends StatelessWidget {
  const _BulkButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.surfaceVariant,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: Space.lg),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTypography.ui(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

/// One row: category name on the left, switch on the right. The whole
/// row is tappable, not just the switch, since this is a touchscreen.
class _CategoryToggleTile extends StatelessWidget {
  const _CategoryToggleTile({
    required this.name,
    required this.value,
    required this.onChanged,
  });

  final String name;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        constraints: const BoxConstraints(minHeight: 68),
        padding: const EdgeInsets.symmetric(
          horizontal: Space.lg,
          vertical: Space.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.ui(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: value ? colors.textPrimary : colors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: Space.md),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: colors.onPrimary,
              activeTrackColor: colors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

/// Loading / empty / error message shown in place of the list.
class _StateMessage extends StatelessWidget {
  const _StateMessage({
    required this.icon,
    required this.message,
    this.isError = false,
  });

  final IconData icon;
  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = isError ? colors.danger : colors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(Space.xxl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.borderSubtle),
        color: colors.surface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(width: Space.md),
          Flexible(
            child: Text(
              message,
              style: AppTypography.ui(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
