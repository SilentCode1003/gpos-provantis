import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/payments_table.dart';

part 'payments_dao.g.dart';

@DriftAccessor(tables: [PaymentsTable])
class PaymentsDao extends DatabaseAccessor<AppDatabase>
    with _$PaymentsDaoMixin {
  PaymentsDao(super.db);

  Future<void> savePayment(PaymentsTableData payment) {
    return into(paymentsTable).insert(payment);
  }

  Future<List<PaymentsTableData>> getAllPayments() {
    return select(paymentsTable).get();
  }

  Stream<List<PaymentsTableData>> watchAllPayments() {
    return select(paymentsTable).watch();
  }
}
