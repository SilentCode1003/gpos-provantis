import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/pos_config_dao.dart';
import 'package:gpos_provantis/src/core/database/daos/shift_report_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_config_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/shift_report_dao_provider.dart';

import '../domain/shift_report_dto.dart';

part 'shift_report_repository.g.dart';

@Riverpod(keepAlive: true)
ShiftReportRepository shiftReportRepository(Ref ref) {
  return ShiftReportRepository(
    ref,
    ref.watch(posConfigDaoProvider),
    ref.watch(shiftReportDaoProvider),
  );
}

class ShiftReportRepository {
  final Ref _ref;
  final PosConfigDao _posConfigDao;
  final ShiftReportDao _dao;

  ShiftReportRepository(this._ref, this._posConfigDao, this._dao);

  /// Fetches every shift for [date] (`yyyy-MM-dd`) from the server, replaces
  /// the local copy of that day and returns the saved rows, ordered by shift.
  ///
  /// A day with no shifts is valid: the result is an empty list and the local
  /// copy of that day is cleared. Network failures ([DioException]) propagate
  /// so the caller can fall back to [getLocalShiftReports].
  Future<List<ShiftReportTableData>> fetchAndSaveShiftReports(
    String date,
  ) async {
    final posId = await _posId();

    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post(
      '/shiftreports/getreport',
      data: {'date': date, 'posid': posId},
    );

    final apiResponse = ApiResponseModel<List<ShiftReportDto>>.fromDioResponse(
      response,
      fromJson: (data) => (data as List)
          .map((x) => ShiftReportDto.fromJson(x as Map<String, dynamic>))
          .toList(),
    );

    final records = apiResponse.responseData ?? const <ShiftReportDto>[];

    await _dao.replaceForDate(
      date: date,
      pos: posId,
      rows: [
        for (final r in records)
          ShiftReportTableCompanion.insert(
            // Stored under the requested date so lookups always match.
            date: date,
            pos: r.pos,
            shift: r.shift,
            cashier: Value(r.cashier),
            floating: Value(r.floating),
            cashFloat: Value(r.cashFloat),
            salesBeginning: Value(r.salesBeginning),
            salesEnding: Value(r.salesEnding),
            totalSales: Value(r.totalSales),
            receiptBeginning: Value(r.receiptBeginning),
            receiptEnding: Value(r.receiptEnding),
            status: Value(r.status),
            approvedBy: Value(r.approvedBy),
            approvedDate: Value(r.approvedDate),
          ),
      ],
    );

    return _dao.getForDate(date: date, pos: posId);
  }

  /// Locally stored shifts for [date]. No network call.
  Future<List<ShiftReportTableData>> getLocalShiftReports(String date) async {
    final posId = await _posId();
    return _dao.getForDate(date: date, pos: posId);
  }

  /// The POS id comes from the saved POS config.
  Future<int> _posId() async {
    final pos = await _posConfigDao.getPos();
    if (pos == null) {
      throw StateError('No POS config saved on this device.');
    }
    return pos.posId;
  }
}
