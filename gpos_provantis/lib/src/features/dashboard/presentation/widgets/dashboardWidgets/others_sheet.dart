import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:gpos_provantis/src/core/database/providers/printer_dao_provider.dart'
    show cashDrawerEnabledProvider;
import 'others_action_runner.dart';

class OthersSheet extends ConsumerWidget {
  const OthersSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const OthersSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final controller = ref.watch(dashboardControllerProvider.notifier);
    final actions = controller.otherActions;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Text(
            'Other actions',
            style: AppTypography.display(
              color: colors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 18),
          // Flexible + default scroll physics: if the list ever grows past the
          // screen it scrolls instead of overflowing.
          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 160,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: actions.length,
              itemBuilder: (context, index) {
                return _OtherActionTile(action: actions[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OtherActionTile extends ConsumerWidget {
  const _OtherActionTile({required this.action});

  final OtherAction action;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final icon = otherActionIcon(action.icon);
    final hasCashDrawer = ref.watch(cashDrawerEnabledProvider);
    final disabled = isCashDrawerAction(action.id) && !hasCashDrawer;

    final labelColor = disabled ? colors.textDisabled : colors.textPrimary;

    return Material(
      color: disabled ? colors.disabledFill : colors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: disabled
            ? BorderSide.none
            : BorderSide(color: colors.border.withValues(alpha: 0.6)),
      ),
      child: InkWell(
        onTap: disabled
            ? null
            : () {
                // The sheet closes first, so grab a context that outlives it.
                final rootContext = Navigator.of(
                  context,
                  rootNavigator: true,
                ).context;
                Navigator.of(context).pop();
                runOtherAction(rootContext, ref, action);
              },
        borderRadius: BorderRadius.circular(18),
        splashColor: colors.primary.withValues(alpha: 0.12),
        highlightColor: colors.primary.withValues(alpha: 0.06),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: disabled
                      ? colors.border.withValues(alpha: 0.35)
                      : colors.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  size: 26,
                  color: disabled
                      ? colors.textDisabled
                      : colors.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                action.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.ui(
                  color: labelColor,
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
