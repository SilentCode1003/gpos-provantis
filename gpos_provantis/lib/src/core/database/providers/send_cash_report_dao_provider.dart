import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/send_cash_report_dao.dart';

part 'send_cash_report_dao_provider.g.dart';

@Riverpod(keepAlive: true)
SendCashReportDao sendCashReportDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return SendCashReportDao(db);
}

final sendCashReportsProvider =
    StreamNotifierProvider<SendCashReportsNotifier, List<SendCashReportTableData>>(
      SendCashReportsNotifier.new,
    );

class SendCashReportsNotifier extends StreamNotifier<List<SendCashReportTableData>> {
  @override
  Stream<List<SendCashReportTableData>> build() {
    final dao = ref.watch(sendCashReportDaoProvider);
    return dao.watchAllSendCashReports();
  }
}