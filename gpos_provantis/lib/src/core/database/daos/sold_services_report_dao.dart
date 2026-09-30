import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sold_services_report_table.dart';

part 'sold_services_report_dao.g.dart';

@DriftAccessor(tables: [SoldServicesReportTable])
class SoldServicesReportDao extends DatabaseAccessor<AppDatabase>
    with _$SoldServicesReportDaoMixin {
  SoldServicesReportDao(super.db);

  /// Replaces the stored rows for ONE receipt range (one shift), leaving other
  /// shifts untouched. An empty [rows] just clears that range.
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

  Future<List<SoldServicesReportTableData>> getAllSoldServicesReports() {
    return select(soldServicesReportTable).get();
  }

  Stream<List<SoldServicesReportTableData>> watchAllSoldServicesReports() {
    return select(soldServicesReportTable).watch();
  }
}
