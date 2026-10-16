import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/payments_table.dart';

part 'payments_dao.g.dart';

@DriftAccessor(tables: [PaymentsTable])
class PaymentsDao extends DatabaseAccessor<AppDatabase>
    with _$PaymentsDaoMixin {
  PaymentsDao(super.db);

  // Saves a payment row to local storage.
  // Keeps the payment history available for later sync or review.
  Future<void> savePayment(PaymentsTableData payment) {
    return into(paymentsTable).insert(payment);
  }

  // Replaces the cached payment list with a fresh snapshot.
  // Useful when a full remote sync is loaded in one pass.
  Future<void> replacePayments(List<PaymentsTableCompanion> payments) {
    return transaction(() async {
      await delete(paymentsTable).go();
      await batch((batch) {
        batch.insertAll(paymentsTable, payments);
      });
    });
  }

  // Reads all payment rows from local storage.
  // Returns the full cached payment list for the device.
  Future<List<PaymentsTableData>> getAllPayments() {
    return select(paymentsTable).get();
  }

  // Watches the payment table for live updates.
  // Keeps any listener in sync with the latest payment state.
  Stream<List<PaymentsTableData>> watchAllPayments() {
    return select(paymentsTable).watch();
  }
}
