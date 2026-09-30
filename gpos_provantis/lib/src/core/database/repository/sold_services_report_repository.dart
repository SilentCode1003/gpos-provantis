import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/sold_services_report_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/sold_services_report_dao_provider.dart';

import '../domain/sold_services_report_dto.dart';

part 'sold_services_report_repository.g.dart';

@Riverpod(keepAlive: true)
SoldServicesReportRepository soldServicesReportRepository(Ref ref) {
  final dao = ref.watch(soldServicesReportDaoProvider);
  return SoldServicesReportRepository(ref, dao);
}

class SoldServicesReportRepository {
  final Ref _ref;
  final SoldServicesReportDao _dao;

  SoldServicesReportRepository(this._ref, this._dao);

  /// Fetches every sold item for the receipt range, saves them to the local
  /// DB (replacing any earlier copy of that same range) and returns the rows.
  ///
  /// A shift with no sales is valid: the result is simply an empty list.
  /// Network failures ([DioException]) propagate so the caller can fall back
  /// to [getLocalSoldServices].
  Future<List<SoldServicesReportTableData>> fetchAndSaveSoldServices(
    int receiptBeginning,
    int receiptEnding,
  ) async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    // GET: the receipt range travels in the URL path, not a body.
    final response = await dio.get(
      '/mobile-api/get-shift-service-sold/$receiptBeginning/$receiptEnding',
    );

    final apiResponse =
        ApiResponseModel<List<SoldServicesReportDto>>.fromDioResponse(
          response,
          fromJson: (data) => (data as List)
              .map(
                (x) =>
                    SoldServicesReportDto.fromJson(x as Map<String, dynamic>),
              )
              .toList(),
        );

    final records = apiResponse.responseData ?? const <SoldServicesReportDto>[];

    await _dao.replaceForRange(
      receiptBeginning: receiptBeginning,
      receiptEnding: receiptEnding,
      rows: [
        for (final r in records)
          SoldServicesReportTableCompanion.insert(
            item: Value(r.item),
            quantity: Value(r.quantity),
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

  /// Locally stored sold services for this receipt range. No network call.
  Future<List<SoldServicesReportTableData>> getLocalSoldServices(
    int receiptBeginning,
    int receiptEnding,
  ) {
    return _dao.getForRange(
      receiptBeginning: receiptBeginning,
      receiptEnding: receiptEnding,
    );
  }
}
