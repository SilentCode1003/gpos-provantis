import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/cash_drop_table.dart';

part 'cash_drop_dao.g.dart';

@DriftAccessor(tables: [CashDropTable])
class CashDropDao extends DatabaseAccessor<AppDatabase>
    with _$CashDropDaoMixin {
  CashDropDao(super.db);

  // Inserts a cash drop record into local storage.
  // Keeps the transaction ready for processing and later sync.
  Future<void> insertCashDrop(CashDropTableCompanion data) {
    return into(cashDropTable).insert(data);
  }

  // Reads a cash drop by its local database ID.
  // Returns null when no matching drop exists.
  Future<CashDropTableData?> getById(String id) {
    return (select(
      cashDropTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Newest first.
  // Reads all cash drops ordered by newest item first.
  // Helps the UI show the freshest drop records upfront.
  Future<List<CashDropTableData>> getAllCashDrops() {
    return (select(
      cashDropTable,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  // Watches all cash drops for live updates.
  // Useful for dashboards that show changing drop totals in real time.
  Stream<List<CashDropTableData>> watchAllCashDrops() {
    return (select(
      cashDropTable,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
  }

  /// Drops the server hasn't acknowledged yet, oldest first.
  // Reads pending cash drops in oldest-first order.
  // Keeps the sync queue stable and easier to retry in sequence.
  Future<List<CashDropTableData>> getPending() {
    return (select(cashDropTable)
          ..where((t) => t.syncStatus.equals('PENDING'))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// Every drop recorded for one shift, e.g. for the end-of-shift totals.
  // Reads cash drops for one shift and POS in chronological order.
  // Keeps end-of-shift calculations scoped to the correct period.
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

  // Marks a cash drop as synced with the server timestamp.
  // Prevents the same drop from being queued again.
  Future<void> markSynced(String id, DateTime syncedAt) {
    return (update(cashDropTable)..where((t) => t.id.equals(id))).write(
      CashDropTableCompanion(
        syncStatus: const Value('SYNCED'),
        syncedAt: Value(syncedAt),
      ),
    );
  }
}
