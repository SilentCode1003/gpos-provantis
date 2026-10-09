import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:gpos_provantis/src/services/sync/catalog_sync.dart';
import 'package:gpos_provantis/src/services/sync/controller/catalog_sync_controller.dart';
import 'package:gpos_provantis/src/services/pos_restart_service.dart';
import 'package:gpos_provantis/src/core/printutil/cash_drawer_opener.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/widgets/dashboardWidgets/others_sheet/refund_sheet.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/widgets/dashboardWidgets/others_sheet/reprint_sheet.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/widgets/dashboardWidgets/others_sheet/send_ereceipt_sheet.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/widgets/dashboardWidgets/others_sheet/cash_drop_sheet.dart';
import 'others_usage_provider.dart';

const _syncActionId = 'sync_data';
const _restartPosActionId = 'restart_pos';
const _openCashDrawerActionId = 'open_cashdrawer';

/// Actions that only make sense with a physical cash drawer. Greyed out and
/// non-tappable when no enabled printer has one.
const _cashDrawerActionIds = {'cash_drop', 'open_cashdrawer'};

bool isCashDrawerAction(String actionId) =>
    _cashDrawerActionIds.contains(actionId);

const _iconMap = {
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
  'point_of_sale_rounded': Icons.point_of_sale_rounded,
};

IconData otherActionIcon(String iconKey) =>
    _iconMap[iconKey] ?? Icons.touch_app_rounded;

final Map<String, Future<void> Function(BuildContext)> _sheetMap = {
  're_print': ReprintSheet.show,
  'refund': RefundSheet.show,
  'send_e-receipt': SendEReceiptSheet.show,
  'cash_drop': (context) => CashDropSheet.show(context),
};

const _routeMap = {
  'receipt': '/receipts',
  'reports': '/reports',
  'cash_report': '/cash-reports',
  'sold_items': '/sold-items',
};

/// Runs an Others action and counts it towards the "most used" ranking.
///
/// [rootContext] must stay valid after the Others sheet closes, so pass the
/// root navigator's context when calling from inside the sheet.
void runOtherAction(
  BuildContext rootContext,
  WidgetRef ref,
  OtherAction action,
) {
  ref.read(othersUsageProvider.notifier).record(action.id);

  final openSheet = _sheetMap[action.id];
  final route = _routeMap[action.id];

  if (openSheet != null) {
    openSheet(rootContext);
  } else if (action.id == _openCashDrawerActionId) {
    _openCashDrawer(rootContext, ref.read(cashDrawerOpenerProvider));
  } else if (action.id == _syncActionId) {
    ref
        .read(catalogSyncControllerProvider.notifier)
        .runSync(ref.read(catalogSyncServiceProvider));
  } else if (action.id == _restartPosActionId) {
    showRestartPosFlow(ref);
  } else if (route != null) {
    rootContext.push(route);
  }
}

/// Opens the drawer and reports a failure to the cashier.
Future<void> _openCashDrawer(
  BuildContext rootContext,
  CashDrawerOpener opener,
) async {
  try {
    await opener.open();
  } catch (e) {
    debugPrint('[CashDrawer] open FAILED: $e');
    if (!rootContext.mounted) return;
    ScaffoldMessenger.of(rootContext).showSnackBar(
      SnackBar(content: Text('Could not open the cash drawer: $e')),
    );
  }
}
