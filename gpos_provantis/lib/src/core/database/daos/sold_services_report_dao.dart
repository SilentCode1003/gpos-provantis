import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sold_services_report_table.dart';

part 'sold_services_report_dao.g.dart';

@DriftAccessor(tables: [SoldServicesReportTable])
class SoldServicesReportDao extends DatabaseAccessor<AppDatabase>
    with _$SoldServicesReportDaoMixin {
  SoldServicesReportDao(super.db);

  // Replaces the stored rows for one receipt range only.
  // Keeps the report cache isolated to the requested shift window.
  Future<void> replaceForRange({
    required int receiptBeginning,
    required int receiptEnding,
    required List<SoldServicesReportTableCompanion> rows,
  }) {
    return transaction(() async {
      await (delete(soldServicesReportTable)..where(
            (t) =>
                t.receiptBeginning.equals(receiptBeginning) &
                t.receiptEnding.equals(receiptEnding),
          ))
          .go();
      if (rows.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(soldServicesReportTable, rows);
        });
      }
    });
  }

  // Reads sold-service rows for one receipt range.
  // Returns the requested shift report from the local cache.
  Future<List<SoldServicesReportTableData>> getForRange({
    required int receiptBeginning,
    required int receiptEnding,
  }) {
    return (select(soldServicesReportTable)..where(
          (t) =>
              t.receiptBeginning.equals(receiptBeginning) &
              t.receiptEnding.equals(receiptEnding),
        ))
        .get();
  }

  // Reads all sold-service reports from local storage.
  // Returns the full cached service-report set for the device.
  Future<List<SoldServicesReportTableData>> getAllSoldServicesReports() {
    return select(soldServicesReportTable).get();
  }

  // Watches the sold-service report list for live updates.
  // Keeps the report UI aligned with the latest local cache.
  Stream<List<SoldServicesReportTableData>> watchAllSoldServicesReports() {
    return select(soldServicesReportTable).watch();
  }
}
