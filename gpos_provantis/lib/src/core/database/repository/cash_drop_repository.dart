import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/cash_drop_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/cash_drop_dao_provider.dart';

import '../domain/cash_drop_dto.dart';

part 'cash_drop_repository.g.dart';

@Riverpod(keepAlive: true)
CashDropRepository cashDropRepository(Ref ref) {
  return CashDropRepository(ref.watch(cashDropDaoProvider));
}

class CashDropRepository {
  CashDropRepository(this._dao);

  final CashDropDao _dao;

  /// Flip to true once the server has a cash-drop endpoint and
  /// [submitCashDrop] is implemented.
  static const serverApiAvailable = false;

  /// Saves a drop on this device and returns the stored row. This is the part
  /// that matters today: the drop is recorded even with no server.
  Future<CashDropTableData> saveCashDrop(CashDropDto drop) async {
    await _dao.insertCashDrop(drop.toCompanion());
    final saved = await _dao.getById(drop.id);
    if (saved == null) {
      throw StateError('Cash drop was not found after saving.');
    }
    return saved;
  }

  Future<CashDropTableData?> getCashDrop(String id) => _dao.getById(id);

  Future<List<CashDropTableData>> getLocalCashDrops() => _dao.getAllCashDrops();

  Future<List<CashDropTableData>> getPendingCashDrops() => _dao.getPending();

  Future<List<CashDropTableData>> getCashDropsForShift({
    required String shiftDate,
    required String posId,
    required String shift,
  }) {
    return _dao.getForShift(shiftDate: shiftDate, posId: posId, shift: shift);
  }

  /// PLACEHOLDER: there is no server endpoint for cash drops yet.
  ///
  /// When there is, post `drop` (see `CashDropDto.toApiJson`) and return true
  /// only if the server accepted it, e.g.:
  ///
  /// ```dart
  /// final dio = _ref.read(apiClientProvider);
  /// final response = await dio.post('/cashdrop/save', data: payload);
  /// return response.statusCode == 200;
  /// ```
  /// Network failures ([DioException]) should propagate or return false so the
  /// drop simply stays PENDING and is retried later.
  Future<bool> submitCashDrop(CashDropTableData drop) async {
    return false;
  }

  /// Tries to send every PENDING drop and marks the accepted ones SYNCED.
  /// Returns how many were sent. Does nothing until [serverApiAvailable].
  Future<int> syncPending() async {
    if (!serverApiAvailable) return 0;

    var synced = 0;
    for (final drop in await _dao.getPending()) {
      try {
        if (await submitCashDrop(drop)) {
          await _dao.markSynced(drop.id, DateTime.now());
          synced++;
        }
      } catch (e) {
        // One bad drop must not stop the rest; it stays PENDING.
        debugPrint('CashDrop: could not send ${drop.id}: $e');
      }
    }
    return synced;
  }
}
