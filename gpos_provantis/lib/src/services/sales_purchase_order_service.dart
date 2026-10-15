import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/sales_dao.dart';
import 'package:gpos_provantis/src/core/database/domain/customer_dto.dart';
import 'package:gpos_provantis/src/core/database/domain/sales_purchase_order_dto.dart';
import 'package:gpos_provantis/src/core/database/domain/split_payment_dto.dart';
import 'package:gpos_provantis/src/core/database/providers/sales_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/repository/customer_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/sales_purchase_order_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/sales_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/split_payment_repository.dart';

part 'sales_purchase_order_service.g.dart';

@Riverpod(keepAlive: true)
SalesPurchaseOrderService salesPurchaseOrderService(Ref ref) {
  return SalesPurchaseOrderService(
    repository: ref.watch(salesPurchaseOrderRepositoryProvider),
    salesRepository: ref.watch(salesRepositoryProvider),
    splitPaymentRepository: ref.watch(splitPaymentRepositoryProvider),
    customerRepository: ref.watch(customerRepositoryProvider),
    salesDao: ref.watch(salesDaoProvider),
  );
}

/// Files a sale's purchase order with the server, strictly AFTER the sale and
/// the customer are there.
///
/// The order is always:
///
///  1. the sale (the main transaction) is on the server,
///  2. the customer for that sale is on the server,
///  3. only then the purchase order is sent.
///
/// A purchase order that is not ready simply waits as PENDING (that is not a
/// failure and isn't counted as one) and is looked at again on the next
/// [syncPending].
class SalesPurchaseOrderService {
  SalesPurchaseOrderService({
    required SalesPurchaseOrderRepository repository,
    required SalesRepository salesRepository,
    required SplitPaymentRepository splitPaymentRepository,
    required CustomerRepository customerRepository,
    required SalesDao salesDao,
  }) : _repository = repository,
       _salesRepository = salesRepository,
       _splitPaymentRepository = splitPaymentRepository,
       _customerRepository = customerRepository,
       _salesDao = salesDao;

  final SalesPurchaseOrderRepository _repository;
  final SalesRepository _salesRepository;
  final SplitPaymentRepository _splitPaymentRepository;
  final CustomerRepository _customerRepository;
  final SalesDao _salesDao;

  bool _syncing = false;

  /// Set when [syncPending] is called while a pass is already running, so a
  /// purchase order saved in the meantime still gets its turn.
  bool _rerun = false;

  /// Saves the purchase order typed for the finished sale [salesId].
  ///
  /// Call it after the sale has been saved and the customer has been recorded.
  /// Does nothing (returns null) if no purchase order was entered.
  ///
  /// It only saves on the device. Sending is started in the background and
  /// waits for the sale and the customer, so it never holds up checkout. Throws
  /// only if the local save itself fails.
  Future<SalesPurchaseOrderTableData?> recordForSale({
    required String salesId,
    required String purchaseOrderId,
  }) async {
    final purchaseOrder = purchaseOrderId.trim();
    if (purchaseOrder.isEmpty || purchaseOrder.toUpperCase() == 'N/A') {
      return null;
    }

    final saved = await _repository.saveSalesPurchaseOrder(
      SalesPurchaseOrderDto.create(
        salesId: salesId,
        purchaseOrderId: purchaseOrder,
      ),
    );

    unawaited(_syncQuietly());
    return saved;
  }

  /// Whether the server already has the purchase order for [salesId]. False if
  /// there is none for that sale, or it hasn't been accepted yet.
  Future<bool> isUploaded(String salesId) async {
    final row = await _repository.getSalesPurchaseOrderForSale(salesId);
    return row?.syncStatus == SalesPurchaseOrderSyncStatus.synced;
  }

  /// Sends every purchase order that is ready, and leaves the rest waiting.
  /// Safe to call any time, from anywhere, as often as you like. Returns how
  /// many were sent.
  Future<int> syncPending() async {
    if (_syncing) {
      _rerun = true;
      return 0;
    }
    _syncing = true;

    var sent = 0;
    try {
      do {
        _rerun = false;
        sent += await _runPass();
      } while (_rerun);
    } finally {
      _syncing = false;
    }
    return sent;
  }

  Future<void> _syncQuietly() async {
    try {
      await syncPending();
    } catch (e) {
      // The purchase order is already saved; it will be tried again later.
      debugPrint('SalesPurchaseOrderService: sync failed: $e');
    }
  }

  Future<int> _runPass() async {
    final pending = await _repository.getPendingSalesPurchaseOrders();
    if (pending.isEmpty) {
      await _repository.purgeOldSyncedPurchaseOrders();
      return 0;
    }

    await _pushPrerequisites();

    var sent = 0;
    for (final row in pending) {
      final waitingFor = await _waitingFor(row);
      if (waitingFor != null) {
        debugPrint('PurchaseOrder: ${row.salesId} not sent yet, $waitingFor.');
        continue;
      }

      try {
        await _repository.submitSalesPurchaseOrder(row);
        await _repository.markSynced(row.id);
        sent++;
      } catch (e) {
        debugPrint('PurchaseOrder: could not send ${row.salesId}: $e');
        await _repository.markAttemptFailed(row.id, e);
      }
    }

    await _repository.purgeOldSyncedPurchaseOrders();
    return sent;
  }

  /// Gives the things a purchase order depends on a chance to reach the server
  /// first, in order: the sale, then the customer. Failures are fine here, they
  /// just mean the purchase order keeps waiting.
  Future<void> _pushPrerequisites() async {
    await _quietly('sales', () => _salesRepository.uploadSales());
    await _quietly(
      'split payments',
      () => _splitPaymentRepository.syncPending(),
    );
    await _quietly('customers', () => _customerRepository.syncPending());
  }

  Future<void> _quietly(String what, Future<Object?> Function() action) async {
    try {
      await action();
    } catch (e) {
      debugPrint('PurchaseOrder: could not send $what first: $e');
    }
  }

  /// Why [row] can't be sent yet, or null when it can.
  Future<String?> _waitingFor(SalesPurchaseOrderTableData row) async {
    // 1. The main transaction.
    if (!await _isSaleOnServer(row.salesId)) {
      return 'the sale is not on the server yet';
    }

    // 2. The customer for that sale.
    final customer = await _customerRepository.getCustomerForSale(row.salesId);
    if (customer == null) {
      return 'no customer is recorded for this sale';
    }
    if (customer.syncStatus != CustomerSyncStatus.synced) {
      return 'the customer is not on the server yet';
    }

    return null;
  }

  /// An ordinary sale is on the server once `isSync` is '1'; a sale paid with
  /// two e-payments once its row is SYNCED. A sale found in neither table has
  /// been removed by the retention clean-up, which only ever removes sales the
  /// server already has, so it counts as sent.
  Future<bool> _isSaleOnServer(String salesId) async {
    final sale = await _salesDao.getSaleByDetailId(salesId);
    if (sale != null) return sale.isSync == '1';

    final split = await _splitPaymentRepository.getSplitPaymentForReceipt(
      salesId,
    );
    if (split != null) return split.syncStatus == SplitPaymentSyncStatus.synced;

    return true;
  }
}
