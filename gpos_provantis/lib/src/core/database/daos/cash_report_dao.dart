import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/cash_report_table.dart';

part 'cash_report_dao.g.dart';

@DriftAccessor(tables: [CashReportTable])
class CashReportDao extends DatabaseAccessor<AppDatabase>
    with _$CashReportDaoMixin {
  CashReportDao(super.db);

  /// Replaces the stored reports for ONE day, branch and POS, leaving other
  /// days untouched. An empty [rows] just clears that day.
  // Replaces the cash report rows for one branch/date/POS scope.
  // Keeps reporting data isolated to the requested period.
  Future<void> replaceForDate({
    required String branchId,
    required String posId,
    required String shiftDate,
    required List<CashReportTableCompanion> rows,
  }) {
    return transaction(() async {
      await (delete(cashReportTable)..where(
            (t) =>
                t.branchId.equals(branchId) &
                t.posId.equals(posId) &
                t.shiftDate.equals(shiftDate),
          ))
          .go();
      if (rows.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(cashReportTable, rows);
        });
      }
    });
  }

  /// Ordered by shift number.
  // Reads cash reports for one date and POS in shift order.
  // Keeps the report rows grouped in chronological sequence.
  Future<List<CashReportTableData>> getForDate({
    required String branchId,
    required String posId,
    required String shiftDate,
  }) {
    return (select(cashReportTable)
          ..where(
            (t) =>
                t.branchId.equals(branchId) &
                t.posId.equals(posId) &
                t.shiftDate.equals(shiftDate),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.shift)]))
        .get();
  }

  // Watches the cash report rows for one date and POS.
  // Useful for live reporting screens that need the current shift data.
  Stream<List<CashReportTableData>> watchForDate({
    required String branchId,
    required String posId,
    required String shiftDate,
  }) {
    return (select(cashReportTable)
          ..where(
            (t) =>
                t.branchId.equals(branchId) &
                t.posId.equals(posId) &
                t.shiftDate.equals(shiftDate),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.shift)]))
        .watch();
  }
}
