import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/payment_summary_report_dao.dart';

part 'payment_summary_report_dao_provider.g.dart';

@Riverpod(keepAlive: true)
PaymentSummaryReportDao paymentSummaryReportDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return PaymentSummaryReportDao(db);
}
