import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/staff_sales_report_table.dart';

part 'staff_sales_report_dao.g.dart';

@DriftAccessor(tables: [StaffSalesReportTable])
class StaffSalesReportDao extends DatabaseAccessor<AppDatabase>
    with _$StaffSalesReportDaoMixin {
  StaffSalesReportDao(super.db);

  /// Replaces the stored rows for ONE receipt range (one shift), leaving other
  /// shifts untouched. An empty [rows] just clears that range.
  // Replaces staff sales rows for one receipt range only.
  // Keeps reporting data isolated to the requested shift range.
  Future<void> replaceForRange({
    required int receiptBeginning,
    required int receiptEnding,
    required List<StaffSalesReportTableCompanion> rows,
  }) {
    return transaction(() async {
      await (delete(staffSalesReportTable)..where(
            (t) =>
                t.receiptBeginning.equals(receiptBeginning) &
                t.receiptEnding.equals(receiptEnding),
          ))
          .go();
      if (rows.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(staffSalesReportTable, rows);
        });
      }
    });
  }

  // Reads staff sales rows for one receipt range.
  // Returns the report data for the requested shift window.
  Future<List<StaffSalesReportTableData>> getForRange({
    required int receiptBeginning,
    required int receiptEnding,
  }) {
    return (select(staffSalesReportTable)..where(
          (t) =>
              t.receiptBeginning.equals(receiptBeginning) &
              t.receiptEnding.equals(receiptEnding),
        ))
        .get();
  }

  // Reads all staff sales report rows from local storage.
  // Returns the full cached reporting set for the device.
  Future<List<StaffSalesReportTableData>> getAllStaffSalesReports() {
    return select(staffSalesReportTable).get();
  }

  // Watches the staff sales report list for live updates.
  // Useful for dashboards that need the latest staffing performance data.
  Stream<List<StaffSalesReportTableData>> watchAllStaffSalesReports() {
    return select(staffSalesReportTable).watch();
  }
}
