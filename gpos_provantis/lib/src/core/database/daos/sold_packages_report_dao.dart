import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sold_packages_report_table.dart';

part 'sold_packages_report_dao.g.dart';

@DriftAccessor(tables: [SoldPackagesReportTable])
class SoldPackagesReportDao extends DatabaseAccessor<AppDatabase>
    with _$SoldPackagesReportDaoMixin {
  SoldPackagesReportDao(super.db);

  // Replaces the stored rows for one receipt range only.
  // Keeps the report cache isolated to the requested shift window.
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

  // Reads sold-package rows for one receipt range.
  // Returns the requested shift report from the local cache.
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

  // Reads all sold-package reports from local storage.
  // Returns the full cached package-report set for the device.
  Future<List<SoldPackagesReportTableData>> getAllSoldPackagesReports() {
    return select(soldPackagesReportTable).get();
  }

  // Watches the sold-package report list for live updates.
  // Keeps the report UI aligned with the latest local cache.
  Stream<List<SoldPackagesReportTableData>> watchAllSoldPackagesReports() {
    return select(soldPackagesReportTable).watch();
  }
}
