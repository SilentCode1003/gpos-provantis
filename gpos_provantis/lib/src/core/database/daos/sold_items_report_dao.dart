import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sold_items_report_table.dart';

part 'sold_items_report_dao.g.dart';

@DriftAccessor(tables: [SoldItemsReportTable])
class SoldItemsReportDao extends DatabaseAccessor<AppDatabase>
    with _$SoldItemsReportDaoMixin {
  SoldItemsReportDao(super.db);

  Future<void> saveSoldItemsReport(SoldItemsReportTableData data) {
    return into(soldItemsReportTable).insert(data);
  }

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

  /// Replaces the stored rows for ONE receipt range (one shift), leaving other
  /// shifts untouched. An empty [rows] just clears that range.
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

  Future<List<SoldItemsReportTableData>> getAllSoldItemsReports() {
    return select(soldItemsReportTable).get();
  }

  Stream<List<SoldItemsReportTableData>> watchAllSoldItemsReports() {
    return select(soldItemsReportTable).watch();
  }
}
