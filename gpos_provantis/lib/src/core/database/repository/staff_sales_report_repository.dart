import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/staff_sales_report_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/staff_sales_report_dao_provider.dart';

import '../domain/staff_sales_report_dto.dart';

part 'staff_sales_report_repository.g.dart';

@Riverpod(keepAlive: true)
StaffSalesReportRepository staffSalesReportRepository(Ref ref) {
  final dao = ref.watch(staffSalesReportDaoProvider);
  return StaffSalesReportRepository(ref, dao);
}

class StaffSalesReportRepository {
  final Ref _ref;
  final StaffSalesReportDao _dao;

  StaffSalesReportRepository(this._ref, this._dao);

  /// Fetches the staff sales for the receipt range, saves it to the local
  /// DB (replacing any earlier copy of that same range) and returns the rows.
  ///
  /// An empty result is valid (a shift with no sales). Network failures
  /// ([DioException]) propagate so the caller can fall back to
  /// [getLocalStaffSales].
  Future<List<StaffSalesReportTableData>> fetchAndSaveStaffSales(
    int receiptBeginning,
    int receiptEnding,
  ) async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post(
      '/salesitems/getshiftstaffsales',
      data: {
        'beginingreceipt': receiptBeginning.toString(),
        'endingreceipt': receiptEnding.toString(),
      },
    );

    final apiResponse =
        ApiResponseModel<List<StaffSalesReportDto>>.fromDioResponse(
          response,
          fromJson: (data) => (data as List)
              .map(
                (x) => StaffSalesReportDto.fromJson(x as Map<String, dynamic>),
              )
              .toList(),
        );

    final records = apiResponse.responseData ?? const <StaffSalesReportDto>[];

    await _dao.replaceForRange(
      receiptBeginning: receiptBeginning,
      receiptEnding: receiptEnding,
      rows: [
        for (final r in records)
          StaffSalesReportTableCompanion.insert(
            salesStaff: Value(r.salesStaff),
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

  /// Locally stored staff sales for this receipt range. No network call.
  Future<List<StaffSalesReportTableData>> getLocalStaffSales(
    int receiptBeginning,
    int receiptEnding,
  ) {
    return _dao.getForRange(
      receiptBeginning: receiptBeginning,
      receiptEnding: receiptEnding,
    );
  }
}
