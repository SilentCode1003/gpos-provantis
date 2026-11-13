import 'package:dio/dio.dart' show DioException, DioExceptionType;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/sales_dao.dart';
import 'package:gpos_provantis/src/core/database/services/local_data_retention.dart';
import 'package:gpos_provantis/src/core/database/providers/sales_dao_provider.dart';
import 'package:gpos_provantis/src/services/app_logger.dart';

part 'sales_repository.g.dart';

@Riverpod(keepAlive: true)
SalesRepository salesRepository(Ref ref) {
  final dao = ref.watch(salesDaoProvider);
  return SalesRepository(ref, dao);
}

enum SaleUploadOutcome { success, exists, failure }

class SalesRepository {
  final Ref _ref;
  final SalesDao _dao;

  SalesRepository(this._ref, this._dao);

  static const _logSource = 'sales.upload';

  /// Writes to Settings > Developer. Never throws.
  AppLogger get _log => _ref.read(appLoggerProvider);

  /// True while [uploadSales] is running, so overlapping calls (a timed sync
  /// and a manual one) can't send the same sale twice.
  bool _uploading = false;

  /// The local duplicate clean-up runs once per app session, before the first
  /// upload.
  bool _integrityChecked = false;

  Future<int> uploadSales() async {
    if (_uploading) return 0;
    _uploading = true;
    try {
      await _checkLocalIntegrity();
      final confirmed = await _uploadPending();
      // Housekeeping after each sync; never affects the upload result.
      await purgeOldSyncedSales();
      return confirmed;
    } finally {
      _uploading = false;
    }
  }

  /// Removes leftover duplicate rows (same receipt saved twice by the old
  /// code) and makes sure a receipt id can only be stored once from now on.
  /// Never throws: a problem here must not stop sales from uploading.
  Future<void> _checkLocalIntegrity() async {
    if (_integrityChecked) return;
    _integrityChecked = true;

    try {
      final removed = await _dao.removeDuplicateDetailIds();
      if (removed > 0) {
        await _log.warn(
          _logSource,
          'Removed $removed duplicate local sale row(s) with the same '
          'receipt id',
        );
      }
    } catch (error, stack) {
      await _log.error(
        _logSource,
        'Duplicate clean-up failed',
        error: error,
        stackTrace: stack,
      );
    }

    try {
      await _dao.ensureUniqueDetailIdIndex();
    } catch (error, stack) {
      await _log.error(
        _logSource,
        'Could not add the unique receipt-id index. Some receipt ids are '
        'stored more than once with DIFFERENT content and need a manual '
        'check.',
        error: error,
        stackTrace: stack,
      );
    }
  }

  /// How many sales are still waiting to be sent. Used by the catalog sync to
  /// make sure nothing is left behind before it downloads anything.
  Future<int> pendingCount() async => (await _dao.getUnsyncedSales()).length;

  DateTime? _lastPurgeAt;

  /// Removes sales the server already has once they are older than
  /// [LocalDataRetention.syncedSalesRetention]. Unsynced sales are never
  /// removed. Runs at most once per [LocalDataRetention.purgeInterval] unless
  /// [force] is set. Never throws; returns how many rows were removed.
  Future<int> purgeOldSyncedSales({bool force = false}) async {
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
        debugPrint('SalesRepository: removed $removed old synced sale(s)');
      }
      return removed;
    } catch (error) {
      debugPrint('SalesRepository: could not remove old sales: $error');
      return 0;
    }
  }

  Future<int> _uploadPending() async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final pending = await _dao.getUnsyncedSales();
    debugPrint('SalesRepository: ${pending.length} sale(s) pending upload');
    var confirmedCount = 0;

    for (final sale in pending) {
      final result = await _uploadOne(sale);
      final outcome = result.outcome;

      if (outcome == SaleUploadOutcome.failure) {
        // The reason was already written to the developer log by _uploadOne.
        if (result.stopQueue) {
          // No connection, server down or not signed in: every sale after this
          // one would fail the same way, so wait for the next sync cycle.
          debugPrint(
            'SalesRepository: upload stopped at detailId=${sale.detailId} '
            '(local id=${sale.id}) — leaving it and everything after it '
            'unsynced for the next sync cycle.',
          );
          break;
        }
        // The server refused THIS sale. Leave it unsynced (it is retried next
        // cycle) but do not let it block the sales behind it.
        debugPrint(
          'SalesRepository: skipping detailId=${sale.detailId} '
          '(local id=${sale.id}) — the server refused it; continuing with '
          'the next sale.',
        );
        continue;
      }

      if (outcome == SaleUploadOutcome.exists) {
        if (await _dao.hasDifferentSyncedSale(sale)) {
          // The server has this receipt id, but this device already synced a
          // DIFFERENT sale under it, so this sale is NOT on the server.
          await _log.error(
            _logSource,
            'CONFLICT: the receipt id belongs to a different sale. This sale '
            'was NOT marked synced and is not on the server.',
            detailId: sale.detailId,
            context: _saleContext(sale),
          );
          continue;
        }
        await _log.warn(
          _logSource,
          'Server already had this sale (400 exist), so it was marked as '
          'synced.',
          detailId: sale.detailId,
          context: _saleContext(sale),
        );
      }

      debugPrint(
        'SalesRepository: confirmed detailId=${sale.detailId} '
        '(outcome=$outcome)',
      );
      await _dao.markSynced(sale.id);
      confirmedCount++;
    }

    return confirmedCount;
  }

  Map<String, Object?> _saleContext(SalesTableData sale) => {
    'localId': sale.id,
    'detailId': sale.detailId,
    'total': sale.total,
    'paymentType': sale.paymentType,
    'cashier': sale.cashier,
    'branch': sale.branch,
    'createdAt': sale.createdAt.toIso8601String(),
  };

  /// [stopQueue] only matters when the outcome is [SaleUploadOutcome.failure].
  Future<({SaleUploadOutcome outcome, bool stopQueue})> _uploadOne(
    SalesTableData sale,
  ) async {
    final dio = _ref.read(apiClientProvider);

    try {
      final response = await dio.post(
        '/salesdetails/save',
        data: _toRequestBody(sale),
      );

      if (_isAlreadyOnServer(response.data)) {
        return (outcome: SaleUploadOutcome.exists, stopQueue: false);
      }

      final apiResponse = ApiResponseModel<dynamic>.fromDioResponse(response);
      final msg = apiResponse.responseMessage;

      switch (msg) {
        case 'success':
          return (outcome: SaleUploadOutcome.success, stopQueue: false);
        case 'exist':
          return (outcome: SaleUploadOutcome.exists, stopQueue: false);
        default:
          await _log.error(
            _logSource,
            'The server answered but did not confirm the sale.',
            detailId: sale.detailId,
            context: {
              ..._saleContext(sale),
              'statusCode': response.statusCode,
              'serverMessage': msg,
              'response': response.data,
            },
          );
          return (outcome: SaleUploadOutcome.failure, stopQueue: false);
      }
    } on DioException catch (error, stack) {
      // The server answers a repeat of the same receipt id with
      // `400 {msg: 'exist'}`, which Dio throws as an exception. It means the
      // earlier send DID land (its reply was lost), so it counts as done.
      if (_isAlreadyOnServer(error.response?.data)) {
        return (outcome: SaleUploadOutcome.exists, stopQueue: false);
      }

      final status = error.response?.statusCode;
      final reachedServer = error.response != null;
      final stop = _shouldStopQueue(error);
      final text = reachedServer
          ? 'The server refused the sale (HTTP $status).'
          : 'Could not reach the server (${error.type.name}).';

      if (reachedServer) {
        await _log.error(
          _logSource,
          text,
          detailId: sale.detailId,
          stackTrace: stack,
          context: {
            ..._saleContext(sale),
            'statusCode': status,
            'errorType': error.type.name,
            'response': error.response?.data,
            'queueStopped': stop,
          },
        );
      } else {
        // Offline / timeout: expected now and then, so only a warning (and the
        // logger stores a repeat of it once per 10 minutes).
        await _log.warn(
          _logSource,
          text,
          detailId: sale.detailId,
          context: {
            ..._saleContext(sale),
            'errorType': error.type.name,
            'message': error.message,
          },
        );
      }
      return (outcome: SaleUploadOutcome.failure, stopQueue: stop);
    } catch (error, stack) {
      await _log.error(
        _logSource,
        'Unexpected error while uploading the sale.',
        detailId: sale.detailId,
        error: error,
        stackTrace: stack,
        context: _saleContext(sale),
      );
      return (outcome: SaleUploadOutcome.failure, stopQueue: false);
    }
  }

  /// The reply when the receipt id is already stored:
  /// `{msg: 'exist'}` (or "... already exist").
  bool _isAlreadyOnServer(Object? body) {
    if (body is! Map) return false;
    final msg = body['msg']?.toString().toLowerCase() ?? '';
    return msg == 'exist' || msg.contains('already exist');
  }

  /// True when retrying the NEXT sale right now would fail the same way:
  /// timeouts, no connection, server errors (5xx) and 401/403. A 4xx about
  /// this one sale does not stop the queue.
  bool _shouldStopQueue(DioException error) {
    if (error.type != DioExceptionType.badResponse) return true;
    final status = error.response?.statusCode ?? 0;
    return status >= 500 || status == 401 || status == 403;
  }

  Map<String, dynamic> _toRequestBody(SalesTableData sale) {
    return {
      'detailid': sale.detailId,
      'date': sale.date,
      'posid': sale.posid,
      'shift': sale.shift,
      'paymenttype': sale.paymentType,
      'referenceid': sale.referenceId,
      'paymentname': sale.paymentName,
      'description': sale.items,
      'total': sale.total,
      'cashier': sale.cashier,
      'cash': sale.cash,
      'ecash': sale.ecash,
      'branch': sale.branch,
      'discountdetail': sale.discountDetail,
    };
  }
}
