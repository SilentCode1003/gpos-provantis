import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/cash_drawer_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/cash_drawer_dao_provider.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';

import '../domain/cash_drawer_dto.dart';

part 'cash_drawer_repository.g.dart';

/// How long a SYNCED activity is kept in the local outbox, counted from when
/// it was queued. Unsynced rows are never subject to this — only rows the
/// server has already confirmed. Kept as an audit trail for a while, then
/// deleted so the device's storage doesn't grow forever from queuing
/// thousands of transactions over time.
const Duration kCashDrawerSyncedRetention = Duration(days: 7);

@Riverpod(keepAlive: true)
CashDrawerRepository cashDrawerRepository(Ref ref) {
  final dao = ref.watch(cashDrawerDaoProvider);
  return CashDrawerRepository(ref, dao);
}

/// Sends cash-drawer activity to the server, offline-first.
///
/// Every call here follows the same shape: save [payload] to the local
/// outbox FIRST, then try to drain the whole outbox in order. This means the
/// activity is recorded on the device before any network attempt, so it is
/// never lost to a dropped connection or a killed app — it just waits as an
/// unsynced row until the next successful drain.
///
/// The three sends the POS makes map onto this repository as:
///   openDrawer            -> queueAndSend(CashDrawerActivityPayload.openDrawer(...))
///   denomination count    -> queueAndSend(CashDrawerActivityPayload.denominationCount(...))
///   per-sale cash tender  -> queueAndSend(CashDrawerActivityPayload.transaction(...))
class CashDrawerRepository {
  final Ref _ref;
  final CashDrawerDao _dao;

  CashDrawerRepository(this._ref, this._dao);

  /// Queues [payload] locally, then attempts to send everything pending, in
  /// the order it was queued.
  ///
  /// Returns true if the ENTIRE outbox (including [payload]) is now synced.
  /// Returns false if the device is offline or the server rejected a request
  /// — in that case [payload] and anything queued before it are still saved
  /// locally and will be retried on the next call (see [drainPendingActivities]).
  ///
  /// Never throws for connectivity failures: an activity that can't reach the
  /// server right now is not an error the caller needs to handle, since it's
  /// already safely queued. It only throws if writing to the local DB itself
  /// fails, which would mean the activity was never recorded at all.
  Future<bool> queueAndSend(CashDrawerActivityPayload payload) async {
    await _dao.queueActivity(
      shift: payload.shift,
      cashier: payload.cashier,
      shiftDate: payload.shiftDate,
      branchId: payload.branchId,
      posId: payload.posId,
      denomination: payload.denomination,
      activity: payload.activity,
      queuedAt: DateTime.now().millisecondsSinceEpoch,
    );
    return drainPendingActivities();
  }

  /// Sends every unsynced activity to the server, oldest first, stopping at
  /// the first one that fails.
  ///
  /// Stopping (rather than skipping and continuing) is deliberate: these
  /// activities are meaningful in sequence — an open-drawer notice must
  /// arrive before its denomination count, and transactions must land in the
  /// order they happened — so sending #3 while #2 is still stuck would leave
  /// the server's picture out of order. A later call retries from wherever
  /// this one stopped.
  ///
  /// Returns true if the outbox is now fully empty (of unsynced rows).
  Future<bool> drainPendingActivities() async {
    final pending = await _dao.getPendingActivities();

    for (final row in pending) {
      final sent = await _sendOne(row);
      if (!sent) return false;
      await _dao.markSynced(row.id);
    }

    // Only reached when every pending row above was sent successfully, so
    // there is fresh synced data to prune. Pruning after a partial drain
    // would be wasted work: nothing new became eligible for deletion.
    await _pruneSyncedActivities();

    return true;
  }

  /// Deletes synced rows queued more than [kCashDrawerSyncedRetention] ago.
  /// Unsynced rows are never touched, regardless of age — an activity that
  /// hasn't reached the server yet is not garbage, no matter how old.
  ///
  /// A failure here is logged and ignored: the drain itself already
  /// succeeded, and pruning will simply be retried after the next one.
  Future<void> _pruneSyncedActivities() async {
    try {
      final cutoff = DateTime.now().subtract(kCashDrawerSyncedRetention);
      final removed = await _dao.deleteSyncedOlderThan(cutoff);
      if (removed > 0) {
        debugPrint(
          'CashDrawer: pruned $removed synced rows older than '
          '${kCashDrawerSyncedRetention.inDays} days',
        );
      }
    } catch (e, st) {
      debugPrint('CashDrawer: cache pruning failed: $e\n$st');
    }
  }

  /// Sends one queued row. Returns false (never throws) for anything that
  /// should be retried later: no connectivity, timeout, or a 5xx/network-level
  /// failure. Rethrows anything else (e.g. a 4xx the server will never accept
  /// no matter how many times it's retried), since silently leaving such a
  /// row stuck in the queue forever would block every activity queued after
  /// it with no way for the caller to find out why.
  Future<bool> _sendOne(CashDrawerTableData row) async {
    await _ref.read(domainConfigDaoProvider).cacheReady;
    final dio = _ref.read(apiClientProvider);

    try {
      await dio.post(
        '/mobile-api/cashdrawer-activity',
        data: {
          'shift': row.shift,
          'cashier': row.cashier,
          'shiftdate': row.shiftDate,
          'branchid': row.branchId,
          'posid': row.posId,
          // Already a JSON-encoded string — sent as-is, matching exactly
          // what was queued.
          'denomination': row.denomination,
          'activity': row.activity,
        },
      );
      return true;
    } on DioException catch (e) {
      final isConnectivityFailure =
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          (e.response?.statusCode != null && e.response!.statusCode! >= 500);
      if (isConnectivityFailure) {
        debugPrint(
          'CashDrawer: could not send activity ${row.id} '
          '(${e.type}); will retry later.',
        );
        return false;
      }
      rethrow;
    }
  }
}
