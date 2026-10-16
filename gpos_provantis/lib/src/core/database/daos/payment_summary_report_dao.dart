import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/payment_summary_report_table.dart';

part 'payment_summary_report_dao.g.dart';

@DriftAccessor(tables: [PaymentSummaryReportTable])
class PaymentSummaryReportDao extends DatabaseAccessor<AppDatabase>
    with _$PaymentSummaryReportDaoMixin {
  PaymentSummaryReportDao(super.db);

  // Replaces the stored rows for one receipt range only.
  // Keeps the report cache isolated to the requested shift window.
  Future<void> replaceForRange({
    required int receiptBeginning,
    required int receiptEnding,
    required List<PaymentSummaryReportTableCompanion> rows,
  }) {
    return transaction(() async {
      await (delete(paymentSummaryReportTable)..where(
            (t) =>
                t.receiptBeginning.equals(receiptBeginning) &
                t.receiptEnding.equals(receiptEnding),
          ))
          .go();
      if (rows.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(paymentSummaryReportTable, rows);
        });
      }
    });
  }

  // Reads payment summary rows for one receipt range.
  // Returns the requested report portion from the local cache.
  Future<List<PaymentSummaryReportTableData>> getForRange({
    required int receiptBeginning,
    required int receiptEnding,
  }) {
    return (select(paymentSummaryReportTable)..where(
          (t) =>
              t.receiptBeginning.equals(receiptBeginning) &
              t.receiptEnding.equals(receiptEnding),
        ))
        .get();
  }

  // Reads all payment summary reports from local storage.
  // Returns the full cached report set for the device.
  Future<List<PaymentSummaryReportTableData>> getAllPaymentSummaryReports() {
    return select(paymentSummaryReportTable).get();
  }

  // Watches the payment summary report list for live updates.
  // Keeps the UI aligned with the latest report state.
  Stream<List<PaymentSummaryReportTableData>> watchAllPaymentSummaryReports() {
    return select(paymentSummaryReportTable).watch();
  }
}
