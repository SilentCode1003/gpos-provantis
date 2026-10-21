import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod/riverpod.dart';

import 'package:gpos_provantis/src/core/database/domain/settings_dto.dart';
import 'package:gpos_provantis/src/core/database/providers/settings_dao_provider.dart';
import 'package:gpos_provantis/src/services/check_health_service.dart';
import 'package:gpos_provantis/src/services/customer_service.dart';
import 'package:gpos_provantis/src/services/sales_purchase_order_service.dart';
import 'package:gpos_provantis/src/services/split_payment_service.dart';
import 'package:gpos_provantis/src/services/sync/controller/sales_sync_controller.dart';

final postTransactionSyncProvider = Provider<PostTransactionSync>(
  (ref) => PostTransactionSync(ref),
);

/// Sends what is waiting to the server right after a sale, when Settings >
/// Sync > "Sync after each sale" is on. Called (not awaited) by the dashboard
/// once a sale is saved.
///
/// It only PUSHES (no catalog download), so it is light enough to run after
/// every sale. The regular sales go through the same controller that already
/// retries them every 30 seconds, so this just sends them right away instead
/// of waiting for the next tick. It never throws and never blocks the cashier: with no
/// connection it simply does nothing, and everything stays saved on the device
/// for a later sync.
class PostTransactionSync {
  PostTransactionSync(this._ref);

  final Ref _ref;

  bool _running = false;
  bool _again = false;

  Future<void> run() async {
    // Sales rung up back to back: run once more after this pass instead of
    // stacking passes on top of each other.
    if (_running) {
      _again = true;
      return;
    }
    _running = true;
    try {
      do {
        _again = false;
        await _once();
      } while (_again);
    } catch (e) {
      debugPrint('PostTransactionSync: $e');
    } finally {
      _running = false;
    }
  }

  Future<void> _once() async {
    final sales = _ref.read(salesSyncControllerProvider.notifier);
    final customers = _ref.read(customerServiceProvider);
    final splits = _ref.read(splitPaymentServiceProvider);
    final purchaseOrders = _ref.read(salesPurchaseOrderServiceProvider);

    final rows = await _ref.read(settingsDaoProvider).getSettings();
    final settings = rows.isEmpty
        ? const SyncSettings()
        : SyncSettings.fromTableData(rows.first);
    if (!settings.autoSyncAfterTransaction) return;

    if (_ref.read(serverHealthControllerProvider) ==
        ServerHealthStatus.offline) {
      return;
    }

    // Order matters: the sale goes first, customers and purchase orders wait
    // for it on the server.
    await _guard('sales', sales.syncNow);
    await _guard('customers', customers.syncPending);
    await _guard('split payments', splits.syncPending);
    await _guard('purchase orders', purchaseOrders.syncPending);
  }

  Future<void> _guard(String what, Future<Object?> Function() task) async {
    try {
      await task();
    } catch (e) {
      debugPrint('PostTransactionSync: $what not sent: $e');
    }
  }
}
