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
