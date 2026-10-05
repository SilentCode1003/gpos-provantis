import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/cash_drop_table.dart';

part 'cash_drop_dao.g.dart';

@DriftAccessor(tables: [CashDropTable])
class CashDropDao extends DatabaseAccessor<AppDatabase>
    with _$CashDropDaoMixin {
  CashDropDao(super.db);

  Future<void> insertCashDrop(CashDropTableCompanion data) {
    return into(cashDropTable).insert(data);
  }

  Future<CashDropTableData?> getById(String id) {
    return (select(
      cashDropTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Newest first.
  Future<List<CashDropTableData>> getAllCashDrops() {
    return (select(
      cashDropTable,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  Stream<List<CashDropTableData>> watchAllCashDrops() {
    return (select(
      cashDropTable,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
  }

  /// Drops the server hasn't acknowledged yet, oldest first.
  Future<List<CashDropTableData>> getPending() {
    return (select(cashDropTable)
          ..where((t) => t.syncStatus.equals('PENDING'))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// Every drop recorded for one shift, e.g. for the end-of-shift totals.
  Future<List<CashDropTableData>> getForShift({
    required String shiftDate,
    required String posId,
    required String shift,
  }) {
    return (select(cashDropTable)
          ..where(
            (t) =>
                t.shiftDate.equals(shiftDate) &
                t.posId.equals(posId) &
                t.shift.equals(shift),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  Future<void> markSynced(String id, DateTime syncedAt) {
    return (update(cashDropTable)..where((t) => t.id.equals(id))).write(
      CashDropTableCompanion(
        syncStatus: const Value('SYNCED'),
        syncedAt: Value(syncedAt),
      ),
    );
  }
}
