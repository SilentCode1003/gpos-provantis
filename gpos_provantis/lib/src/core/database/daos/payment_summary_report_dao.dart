import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/payment_summary_report_table.dart';

part 'payment_summary_report_dao.g.dart';

@DriftAccessor(tables: [PaymentSummaryReportTable])
class PaymentSummaryReportDao extends DatabaseAccessor<AppDatabase>
    with _$PaymentSummaryReportDaoMixin {
  PaymentSummaryReportDao(super.db);

  /// Replaces the stored rows for ONE receipt range (one shift), leaving other
  /// shifts untouched. An empty [rows] just clears that range.
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

  Future<List<PaymentSummaryReportTableData>> getAllPaymentSummaryReports() {
    return select(paymentSummaryReportTable).get();
  }

  Stream<List<PaymentSummaryReportTableData>> watchAllPaymentSummaryReports() {
    return select(paymentSummaryReportTable).watch();
  }
}
