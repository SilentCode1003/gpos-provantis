import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/split_payment_dao.dart';
import 'package:gpos_provantis/src/core/database/services/local_data_retention.dart';
import 'package:gpos_provantis/src/core/database/providers/split_payment_dao_provider.dart';

import '../domain/split_payment_dto.dart';

part 'split_payment_repository.g.dart';

@Riverpod(keepAlive: true)
SplitPaymentRepository splitPaymentRepository(Ref ref) {
  final dao = ref.watch(splitPaymentDaoProvider);
  return SplitPaymentRepository(ref, dao);
}

class SplitPaymentRepository {
  SplitPaymentRepository(this._ref, this._dao);

  final Ref _ref;
  final SplitPaymentDao _dao;

  /// True while [syncPending] is running, so overlapping calls can't send the
  /// same sale twice.
  bool _syncing = false;

  /// Saves the split sale on this device and returns the stored row. Saving
  /// the same sale again returns the row already stored instead of resetting it
  /// to PENDING; a different sale reusing the receipt id throws
  /// a DuplicateDetailIdException.
  Future<SplitPaymentTableData> saveSplitPayment(SplitPaymentDto sale) {
    return _dao.saveOnce(sale.toCompanion());
  }

  Future<SplitPaymentTableData?> getSplitPayment(String id) => _dao.getById(id);

  Future<SplitPaymentTableData?> getSplitPaymentForReceipt(String detailId) =>
      _dao.getByDetailId(detailId);

  Future<List<SplitPaymentTableData>> getLocalSplitPayments() =>
      _dao.getAllSplitPayments();

  Future<List<SplitPaymentTableData>> getPendingSplitPayments() =>
      _dao.getPending();

  /// Posts one split sale to `/salesdetails/splitpayment`. Returns normally if
  /// the server accepted it, or already has it (it answers a repeat of the same
  /// receipt id with a 400 saying "already exist", which means the earlier send
  /// did land). Anything else throws, so the caller keeps it PENDING.
  Future<void> submitSplitPayment(SplitPaymentTableData row) async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);

    Response<dynamic> response;
    try {
      response = await dio.post(
        '/salesdetails/splitpayment',
        data: SplitPaymentDto.fromTableData(row).toApiJson(),
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
        'Server did not accept the split payment'
        '${msg == null ? '.' : ': $msg'}',
      );
    }
  }

  /// Sends every PENDING split sale and marks the accepted ones SYNCED. One
  /// that fails stays PENDING with its error recorded, and the rest still go
  /// out. Returns how many were sent.
  Future<int> syncPending() async {
    if (_syncing) return 0;
    _syncing = true;

    try {
      var synced = 0;
      for (final row in await _dao.getPending()) {
        try {
          await submitSplitPayment(row);
          await _dao.markSynced(row.id, DateTime.now());
          synced++;
        } catch (e) {
          debugPrint('SplitPayment: could not send ${row.detailId}: $e');
          await _dao.markAttemptFailed(row.id, _describe(e));
        }
      }
      // Housekeeping after each sync; never affects the send result.
      await purgeOldSyncedSplitPayments();
      return synced;
    } finally {
      _syncing = false;
    }
  }

  DateTime? _lastPurgeAt;

  /// Removes split sales the server already has once they are older than
  /// [LocalDataRetention.syncedSalesRetention]. PENDING sales are never
  /// removed. Runs at most once per [LocalDataRetention.purgeInterval] unless
  /// [force] is set. Never throws; returns how many rows were removed.
  Future<int> purgeOldSyncedSplitPayments({bool force = false}) async {
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
        debugPrint('SplitPayment: removed $removed old synced sale(s)');
      }
      return removed;
    } catch (e) {
      debugPrint('SplitPayment: could not remove old sales: $e');
      return 0;
    }
  }

  /// The server's reply when the receipt id is already stored:
  /// `{msg: "order id 100000070 already exist"}`.
  bool _isAlreadyOnServer(Object? body) {
    if (body is! Map) return false;
    return body['msg']?.toString().contains('already exist') ?? false;
  }

  String _describe(Object e) {
    if (e is DioException) {
      final msg = e.response?.data is Map
          ? (e.response!.data as Map)['msg']?.toString()
          : null;
      return msg ?? 'Network error: ${e.type.name}';
    }
    return e.toString().replaceFirst('Exception: ', '');
  }
}
