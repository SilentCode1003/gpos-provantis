import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/cash_report_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/branch_config_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/cash_report_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_config_dao_provider.dart';

import '../domain/cash_report_dto.dart';

part 'cash_report_repository.g.dart';

@Riverpod(keepAlive: true)
CashReportRepository cashReportRepository(Ref ref) {
  final dao = ref.watch(cashReportDaoProvider);
  return CashReportRepository(ref, dao);
}

class CashReportRepository {
  CashReportRepository(this._ref, this._dao);

  final Ref _ref;
  final CashReportDao _dao;

  /// Pulls the cash reports for [shiftDate] (`yyyy-MM-dd`) from the server,
  /// replaces the local copy of that day and returns the saved rows, ordered
  /// by shift.
  ///
  /// A day with no reports is valid: the result is an empty list and the local
  /// copy of that day is cleared. Network failures ([DioException]) propagate
  /// so the caller can fall back to [getLocalCashReports].
  Future<List<CashReportTableData>> fetchAndSaveCashReports(
    String shiftDate,
  ) async {
    final identity = await _identity();

    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post(
      '/mobile-api/getcashreport',
      data: {
        'branchid': identity.branchId,
        'posid': identity.posId,
        'shiftdate': shiftDate,
      },
    );

    final apiResponse = ApiResponseModel<List<CashReportDto>>.fromDioResponse(
      response,
      fromJson: (data) => (data as List)
          .map((x) => CashReportDto.fromJson(x as Map<String, dynamic>))
          .toList(),
    );

    final records = apiResponse.responseData ?? const <CashReportDto>[];

    await _dao.replaceForDate(
      branchId: identity.branchId,
      posId: identity.posId,
      shiftDate: shiftDate,
      rows: [
        for (final r in records)
          CashReportTableCompanion.insert(
            // Stored under the identity and date that were asked for, so
            // lookups always match.
            branchId: identity.branchId,
            posId: identity.posId,
            shift: r.shift,
            shiftDate: shiftDate,
            cashFloat: Value(r.cashFloat),
            totalCash: Value(r.totalCash),
            denominationJson: Value(r.denomination),
            fetchedAt: Value(DateTime.now()),
          ),
      ],
    );

    return _dao.getForDate(
      branchId: identity.branchId,
      posId: identity.posId,
      shiftDate: shiftDate,
    );
  }

  /// Locally stored cash reports for [shiftDate]. No network call.
  Future<List<CashReportTableData>> getLocalCashReports(
    String shiftDate,
  ) async {
    final identity = await _identity();
    return _dao.getForDate(
      branchId: identity.branchId,
      posId: identity.posId,
      shiftDate: shiftDate,
    );
  }

  /// The branch and POS this device belongs to.
  Future<({String branchId, String posId})> _identity() async {
    final branch = await _ref.read(branchConfigDaoProvider).getBranch();
    final branchId = branch?.branchId;
    if (branchId == null || branchId.isEmpty || branchId == 'UNREGISTERED') {
      throw StateError('No branch is configured on this device.');
    }

    final pos = await _ref.read(posConfigDaoProvider).getPos();
    final posId = pos?.posId;
    if (posId == null || posId == 0) {
      throw StateError('No POS config saved on this device.');
    }

    return (branchId: branchId, posId: posId.toString());
  }
}
