import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import '../tables/cash_drawer_table.dart';

part 'cash_drawer_dao.g.dart';

@DriftAccessor(tables: [CashDrawerTable])
class CashDrawerDao extends DatabaseAccessor<AppDatabase>
    with _$CashDrawerDaoMixin {
  CashDrawerDao(super.db);

  /// Queues one activity and returns the saved row (with its id).
  ///
  /// Called BEFORE the API request is attempted, so the row exists locally
  /// even if the request never goes out.
  ///
  /// Takes the row's fields rather than a ready-made companion, because the
  /// id is generated HERE, in Dart, instead of relying on the table's
  /// `clientDefault` + plain `insert()`. [id] is TEXT, not an autoincrementing
  /// integer, so `insert()`'s returned rowid can't be trusted to identify this
  /// row afterwards — generating the id up front means it's already known,
  /// with no dependency on SQLite's RETURNING support or rowid semantics.
  Future<CashDrawerTableData> queueActivity({
    required String shift,
    required String cashier,
    required String shiftDate,
    required String branchId,
    required String posId,
    required String denomination,
    required String activity,
    required int queuedAt,
  }) async {
    final id = const Uuid().v4();
    await into(cashDrawerTable).insert(
      CashDrawerTableCompanion.insert(
        id: Value(id),
        shift: Value(shift),
        cashier: Value(cashier),
        shiftDate: Value(shiftDate),
        branchId: Value(branchId),
        posId: Value(posId),
        denomination: Value(denomination),
        activity: Value(activity),
        queuedAt: queuedAt,
      ),
    );
    return (select(cashDrawerTable)..where((t) => t.id.equals(id))).getSingle();
  }

  /// Unsynced rows, oldest first. This is the send order: activities must
  /// reach the server in the sequence they happened (open drawer before the
  /// denomination count, transactions in the order they were rung up).
  Future<List<CashDrawerTableData>> getPendingActivities() {
    return (select(cashDrawerTable)
          ..where((t) => t.synced.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.queuedAt)]))
        .get();
  }

  Stream<List<CashDrawerTableData>> watchPendingActivities() {
    return (select(cashDrawerTable)
          ..where((t) => t.synced.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.queuedAt)]))
        .watch();
  }

  Future<void> markSynced(String id) {
    return (update(cashDrawerTable)..where((t) => t.id.equals(id))).write(
      const CashDrawerTableCompanion(synced: Value(true)),
    );
  }

  /// Drops synced rows older than [olderThan] so the audit trail doesn't grow
  /// forever. Unsynced rows are never touched by this, regardless of age.
  Future<int> deleteSyncedOlderThan(DateTime olderThan) {
    return (delete(cashDrawerTable)..where(
          (t) =>
              t.synced.equals(true) &
              t.queuedAt.isSmallerThanValue(olderThan.millisecondsSinceEpoch),
        ))
        .go();
  }
}
