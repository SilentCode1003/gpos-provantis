import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/sales_purchase_order_dao.dart';
import 'package:gpos_provantis/src/core/database/services/local_data_retention.dart';
import 'package:gpos_provantis/src/core/database/providers/sales_purchase_order_dao_provider.dart';

import '../domain/sales_purchase_order_dto.dart';

part 'sales_purchase_order_repository.g.dart';

@Riverpod(keepAlive: true)
SalesPurchaseOrderRepository salesPurchaseOrderRepository(Ref ref) {
  final dao = ref.watch(salesPurchaseOrderDaoProvider);
  return SalesPurchaseOrderRepository(ref, dao);
}

class SalesPurchaseOrderRepository {
  SalesPurchaseOrderRepository(this._ref, this._dao);

  final Ref _ref;
  final SalesPurchaseOrderDao _dao;

  /// Saves the purchase order on this device and returns the stored row. The
  /// same purchase order saved again returns the row already stored.
  Future<SalesPurchaseOrderTableData> saveSalesPurchaseOrder(
    SalesPurchaseOrderDto purchaseOrder,
  ) {
    return _dao.saveOnce(purchaseOrder.toCompanion());
  }

  Future<SalesPurchaseOrderTableData?> getSalesPurchaseOrder(String id) =>
      _dao.getById(id);

  Future<SalesPurchaseOrderTableData?> getSalesPurchaseOrderForSale(
    String salesId,
  ) => _dao.getBySalesId(salesId);

  Future<List<SalesPurchaseOrderTableData>> getLocalSalesPurchaseOrders() =>
      _dao.getAllSalesPurchaseOrders();

  Future<List<SalesPurchaseOrderTableData>> getPendingSalesPurchaseOrders() =>
      _dao.getPending();

  /// Posts one purchase order to `/mobile-api/add-sales-purchase-order`.
  ///
  /// This only does the sending. Whether it is the right moment (the sale and
  /// the customer already on the server) is the service's decision, made before
  /// this is called.
  ///
  /// Returns normally if the server accepted it, or already has it. Anything
  /// else throws, so the caller keeps it PENDING.
  Future<void> submitSalesPurchaseOrder(SalesPurchaseOrderTableData row) async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);

    Response<dynamic> response;
    try {
      response = await dio.post(
        '/mobile-api/add-sales-purchase-order',
        data: SalesPurchaseOrderDto.fromTableData(row).toApiJson(),
      );
    } on DioException catch (e) {
      if (_isAlreadyOnServer(e.response?.data)) return;
      rethrow;
    }

    if (_isAlreadyOnServer(response.data)) return;

    final body = response.data;
    final msg = body is Map ? body['msg']?.toString() : null;
    if (msg != 'success') {
      throw Exception(
        'Server did not accept the purchase order'
        '${msg == null ? '.' : ': $msg'}',
      );
    }
  }

  Future<void> markSynced(String id) => _dao.markSynced(id, DateTime.now());

  Future<void> markAttemptFailed(String id, Object error) =>
      _dao.markAttemptFailed(id, describe(error));

  DateTime? _lastPurgeAt;

  /// Removes purchase orders the server already has once they are older than
  /// [LocalDataRetention.syncedSalesRetention], the same window as the sales
  /// they belong to. PENDING ones are never removed. Runs at most once per
  /// [LocalDataRetention.purgeInterval] unless [force] is set. Never throws;
  /// returns how many rows were removed.
  Future<int> purgeOldSyncedPurchaseOrders({bool force = false}) async {
    final now = DateTime.now();
    final last = _lastPurgeAt;
    if (!force &&
        last != null &&
        now.difference(last) < LocalDataRetention.purgeInterval) {
      return 0;
    }
    _lastPurgeAt = now;

    try {
      final removed = await _dao.deleteSyncedOlderThan(
        LocalDataRetention.syncedSalesCutoff(now),
      );
      if (removed > 0) {
        debugPrint('PurchaseOrder: removed $removed old synced row(s)');
      }
      return removed;
    } catch (e) {
      debugPrint('PurchaseOrder: could not remove old rows: $e');
      return 0;
    }
  }

  /// The server's reply when it already has this purchase order, e.g.
  /// `{msg: "exist"}`.
  bool _isAlreadyOnServer(Object? body) {
    if (body is! Map) return false;
    return body['msg']?.toString().toLowerCase().contains('exist') ?? false;
  }

  /// A short reason to store on the row.
  String describe(Object e) {
    if (e is DioException) {
      final msg = e.response?.data is Map
          ? (e.response!.data as Map)['msg']?.toString()
          : null;
      return msg ?? 'Network error: ${e.type.name}';
    }
    return e.toString().replaceFirst('Exception: ', '');
  }
}
