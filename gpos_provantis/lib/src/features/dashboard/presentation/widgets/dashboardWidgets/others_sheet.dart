// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/others_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:gpos_provantis/src/services/sync/catalog_sync.dart';
import 'package:gpos_provantis/src/services/sync/controller/catalog_sync_controller.dart';
import 'package:gpos_provantis/src/services/pos_restart_service.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/widgets/dashboardWidgets/others_sheet/refund_sheet.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/widgets/dashboardWidgets/others_sheet/reprint_sheet.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/widgets/dashboardWidgets/others_sheet/send_ereceipt_sheet.dart';

/// --- Others sheet: 11-item grid of secondary actions -----------------------
///
/// A bottom sheet is the right call here specifically because these are
/// one-off, low-frequency actions (discounts, void, returns, etc) rather
/// than the rapid tap-tap-tap loop that ruled out a sheet for categories.
/// Opens full-width (not right-panel-only) since it's launched from the
/// top bar, not from inside the category/product flow, and there's no
/// "covers the buttons I need to tap again immediately" problem here.
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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
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
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
        ],
      ),
    );
  }
}

class _OtherActionTile extends ConsumerWidget {
  const _OtherActionTile({required this.action});

  final OtherAction action;

  /// Ids handled as a direct in-place effect rather than a route push —
  /// triggering a catalog re-sync, or running the restart-POS flow.
  /// Kept separate from [_routeMap] since these are a different kind
  /// of dispatch (fire an action / open a flow vs push a screen), not
  /// another entry in the "no screen yet" bucket.
  static const _syncActionId = 'sync_data';

  /// TODO: verify this against whatever id `controller.otherActions`
  /// actually assigns to the restart-POS tile. This file's class doc
  /// comment lists "restart POS" among ids with no screen yet (it
  /// currently just closes the sheet), and `_iconMap` already has a
  /// `restart_alt_rounded` entry for it, but the real `OtherAction.id`
  /// string wasn't visible from this file alone — `restart_pos` is a
  /// guess following the snake_case pattern of the other ids above
  /// (`sync_data`, `cash_report`, etc). If `otherActions` uses a
  /// different id, update this constant to match — everything else
  /// below (the `else if` branch, the flow call) stays the same.
  static const _restartPosActionId = 'restart_pos';

  static const _iconMap = {
    'receipt_long_rounded': Icons.receipt_long_rounded,
    'summarize_rounded': Icons.summarize_rounded,
    'account_balance_wallet_rounded': Icons.account_balance_wallet_rounded,
    'shopping_bag_rounded': Icons.shopping_bag_rounded,
    'print_rounded': Icons.print_rounded,
    'assignment_return_rounded': Icons.assignment_return_rounded,
    'forward_to_inbox_rounded': Icons.forward_to_inbox_rounded,
    'payments_rounded': Icons.payments_rounded,
    'inbox_rounded': Icons.inbox_rounded,
    'sync_rounded': Icons.sync_rounded,
    'restart_alt_rounded': Icons.restart_alt_rounded,
  };

  /// Ids that open a form bottom sheet (OR number / email entry) instead of
  /// pushing a route. Each launcher receives the *root* navigator's context
  /// (see `onTap` below) so it stays valid after this tile's own sheet has
  /// popped.
  static final Map<String, Future<void> Function(BuildContext)> _sheetMap = {
    're_print': ReprintSheet.show,
    'refund': RefundSheet.show,
    'send_e-receipt': SendEReceiptSheet.show,
  };

  /// Maps an [OtherAction.id] to the route path it should push. Ids with
  /// no screen yet (cash drop, open cashdrawer) are omitted — those
  /// tiles just close the sheet for now. `sync_data`, [_restartPosActionId]
  /// and the [_sheetMap] ids are also absent here, but for a different
  /// reason: each is dispatched as its own in-place action (sync, restart
  /// flow, form sheet) rather than a route push — see the `onTap` handler
  /// below.
  static const _routeMap = {
    'receipt': '/receipts',
    'reports': '/reports',
    'cash_report': '/cash-reports',
    'sold_items': '/sold-items',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final icon = _iconMap[action.icon] ?? Icons.touch_app_rounded;
    final route = _routeMap[action.id];

    return Material(
      color: colors.surfaceVariant,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () {
          // Grab the root navigator's context BEFORE popping this sheet.
          // `context` (this tile) is torn down by the pop below, so opening
          // the next sheet against it can silently fail — same failure mode
          // documented on the restart-POS branch.
          final rootContext = Navigator.of(
            context,
            rootNavigator: true,
          ).context;
          final openSheet = _sheetMap[action.id];
          Navigator.of(context).pop();
          if (openSheet != null) {
            openSheet(rootContext);
          } else if (action.id == _syncActionId) {
            // Fire-and-forget: CatalogSyncController's state drives the
            // global CatalogSyncOverlay (mounted near the app root), so
            // there's nothing more for this tile to await or display —
            // the barrier/toast/failure banner will surface on top of
            // whatever screen the user lands on after the sheet closes.
            ref
                .read(catalogSyncControllerProvider.notifier)
                .runSync(ref.read(catalogSyncServiceProvider));
          } else if (action.id == _restartPosActionId) {
            // No longer needs this tile's `context` at all — the flow
            // opens its dialogs against the app's root navigator
            // context instead (see root_navigator_key.dart), which
            // stays valid regardless of this sheet closing. That fixes
            // the earlier bug where the countdown dialog silently
            // failed to appear: it was being opened against this
            // tile's context right as the sheet's `Navigator.pop()`
            // above started tearing that context down.
            showRestartPosFlow(ref);
          } else if (route != null) {
            context.push(route);
          }
        },
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 26, color: colors.textPrimary),
              const SizedBox(height: 8),
              Text(
                action.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.ui(
                  color: colors.textPrimary,
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
