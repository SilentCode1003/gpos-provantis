import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/payments_dao.dart';

part 'payments_dao_provider.g.dart';

@Riverpod(keepAlive: true)
PaymentsDao paymentsDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return PaymentsDao(db);
}

final paymentsProvider =
    StreamNotifierProvider<PaymentsNotifier, List<PaymentsTableData>>(
      PaymentsNotifier.new,
    );

class PaymentsNotifier extends StreamNotifier<List<PaymentsTableData>> {
  @override
  Stream<List<PaymentsTableData>> build() {
    final dao = ref.watch(paymentsDaoProvider);
    return dao.watchAllPayments();
  }
}
