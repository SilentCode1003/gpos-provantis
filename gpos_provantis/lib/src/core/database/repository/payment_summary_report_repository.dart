import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/payment_summary_report_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/payment_summary_report_dao_provider.dart';

import '../domain/payment_summary_report_dto.dart';

part 'payment_summary_report_repository.g.dart';

@Riverpod(keepAlive: true)
PaymentSummaryReportRepository paymentSummaryReportRepository(Ref ref) {
  final dao = ref.watch(paymentSummaryReportDaoProvider);
  return PaymentSummaryReportRepository(ref, dao);
}

class PaymentSummaryReportRepository {
  final Ref _ref;
  final PaymentSummaryReportDao _dao;

  PaymentSummaryReportRepository(this._ref, this._dao);

  /// Fetches the payment summary for the receipt range, saves it to the local
  /// DB (replacing any earlier copy of that same range) and returns the rows.
  ///
  /// An empty result is valid (a shift with no sales). Network failures
  /// ([DioException]) propagate so the caller can fall back to
  /// [getLocalPaymentSummary].
  Future<List<PaymentSummaryReportTableData>> fetchAndSavePaymentSummary(
    int receiptBeginning,
    int receiptEnding,
  ) async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post(
      '/salesitems/getshiftsummarypayment',
      data: {
        'beginingreceipt': receiptBeginning.toString(),
        'endingreceipt': receiptEnding.toString(),
      },
    );

    final apiResponse =
        ApiResponseModel<List<PaymentSummaryReportDto>>.fromDioResponse(
          response,
          fromJson: (data) => (data as List)
              .map(
                (x) =>
                    PaymentSummaryReportDto.fromJson(x as Map<String, dynamic>),
              )
              .toList(),
        );

    final records =
        apiResponse.responseData ?? const <PaymentSummaryReportDto>[];

    await _dao.replaceForRange(
      receiptBeginning: receiptBeginning,
      receiptEnding: receiptEnding,
      rows: [
        for (final r in records)
          PaymentSummaryReportTableCompanion.insert(
            paymentType: Value(r.paymentType),
            total: Value(r.total),
            receiptBeginning: Value(receiptBeginning),
            receiptEnding: Value(receiptEnding),
          ),
      ],
    );

    return _dao.getForRange(
      receiptBeginning: receiptBeginning,
      receiptEnding: receiptEnding,
    );
  }

  /// Locally stored payment summary for this receipt range. No network call.
  Future<List<PaymentSummaryReportTableData>> getLocalPaymentSummary(
    int receiptBeginning,
    int receiptEnding,
  ) {
    return _dao.getForRange(
      receiptBeginning: receiptBeginning,
      receiptEnding: receiptEnding,
    );
  }
}
