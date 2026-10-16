import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sold_items_report_table.dart';

part 'sold_items_report_dao.g.dart';

@DriftAccessor(tables: [SoldItemsReportTable])
class SoldItemsReportDao extends DatabaseAccessor<AppDatabase>
    with _$SoldItemsReportDaoMixin {
  SoldItemsReportDao(super.db);

  // Saves a sold-items report row to local storage.
  // Keeps the report available for sync or offline review.
  Future<void> saveSoldItemsReport(SoldItemsReportTableData data) {
    return into(soldItemsReportTable).insert(data);
  }

  // Replaces the cached sold-items report list with a fresh snapshot.
  // Useful when the server sends a full report refresh.
  Future<void> replaceSoldItemsReports(
    List<SoldItemsReportTableCompanion> data,
  ) {
    return transaction(() async {
      await delete(soldItemsReportTable).go();
      await batch((batch) {
        batch.insertAll(soldItemsReportTable, data);
      });
    });
  }

  // Replaces the stored rows for one receipt range only.
  // Keeps the report cache isolated to the requested shift window.
  Future<void> replaceForRange({
    required int receiptBeginning,
    required int receiptEnding,
    required List<SoldItemsReportTableCompanion> rows,
  }) {
    return transaction(() async {
      await (delete(soldItemsReportTable)..where(
            (t) =>
                t.receiptBeginning.equals(receiptBeginning) &
                t.receiptEnding.equals(receiptEnding),
          ))
          .go();
      if (rows.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(soldItemsReportTable, rows);
        });
      }
    });
  }

  // Reads sold-items report rows for one receipt range.
  // Returns the requested shift data from the local cache.
  Future<List<SoldItemsReportTableData>> getForRange({
    required int receiptBeginning,
    required int receiptEnding,
  }) {
    return (select(soldItemsReportTable)..where(
          (t) =>
              t.receiptBeginning.equals(receiptBeginning) &
              t.receiptEnding.equals(receiptEnding),
        ))
        .get();
  }

  // Reads all sold-items reports from local storage.
  // Returns the complete cached report set for the device.
  Future<List<SoldItemsReportTableData>> getAllSoldItemsReports() {
    return select(soldItemsReportTable).get();
  }

  // Watches the sold-items report list for live updates.
  // Keeps the UI aligned with the latest local report state.
  Stream<List<SoldItemsReportTableData>> watchAllSoldItemsReports() {
    return select(soldItemsReportTable).watch();
  }
}
