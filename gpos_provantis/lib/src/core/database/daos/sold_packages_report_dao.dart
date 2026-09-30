import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sold_packages_report_table.dart';

part 'sold_packages_report_dao.g.dart';

@DriftAccessor(tables: [SoldPackagesReportTable])
class SoldPackagesReportDao extends DatabaseAccessor<AppDatabase>
    with _$SoldPackagesReportDaoMixin {
  SoldPackagesReportDao(super.db);

  /// Replaces the stored rows for ONE receipt range (one shift), leaving other
  /// shifts untouched. An empty [rows] just clears that range.
  Future<void> replaceForRange({
    required int receiptBeginning,
    required int receiptEnding,
    required List<SoldPackagesReportTableCompanion> rows,
  }) {
    return transaction(() async {
      await (delete(soldPackagesReportTable)..where(
            (t) =>
                t.receiptBeginning.equals(receiptBeginning) &
                t.receiptEnding.equals(receiptEnding),
          ))
          .go();
      if (rows.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(soldPackagesReportTable, rows);
        });
      }
    });
  }

  Future<List<SoldPackagesReportTableData>> getForRange({
    required int receiptBeginning,
    required int receiptEnding,
  }) {
    return (select(soldPackagesReportTable)..where(
          (t) =>
              t.receiptBeginning.equals(receiptBeginning) &
              t.receiptEnding.equals(receiptEnding),
        ))
        .get();
  }

  Future<List<SoldPackagesReportTableData>> getAllSoldPackagesReports() {
    return select(soldPackagesReportTable).get();
  }

  Stream<List<SoldPackagesReportTableData>> watchAllSoldPackagesReports() {
    return select(soldPackagesReportTable).watch();
  }
}
