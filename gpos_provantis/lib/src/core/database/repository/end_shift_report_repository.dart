import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/end_shift_report_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/end_shift_dao_provider.dart';

import '../domain/end_shift_report_dto.dart';

part 'end_shift_report_repository.g.dart';

@Riverpod(keepAlive: true)
EndShiftRepository endShiftRepository(Ref ref) {
  final dao = ref.watch(endShiftDaoProvider);
  return EndShiftRepository(ref, dao);
}

class EndShiftRepository {
  final Ref _ref;
  final EndShiftDao _dao;

  EndShiftRepository(this._ref, this._dao);

  /// Fetches the shift report from the server, saves it to the local DB, and
  /// returns the saved row.
  ///
  /// Throws if the server returns no data. Network failures ([DioException])
  /// propagate to the caller; use [getLocalEndShiftReport] for the offline
  /// fallback.
  Future<EndShiftTableData> fetchAndSaveEndShiftReport(
    String date,
    int posId,
    int shiftId,
  ) async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post(
      '/shiftreports/getshiftreport',
      data: {'date': date, 'posid': posId, 'shift': shiftId},
    );

    final apiResponse =
        ApiResponseModel<List<EndShiftReportDto>>.fromDioResponse(
          response,
          fromJson: (data) => (data as List)
              .map((x) => EndShiftReportDto.fromJson(x as Map<String, dynamic>))
              .toList(),
        );

    debugPrint('EndShift API response: ${response.data}');

    final records = apiResponse.responseData;
    if (records == null || records.isEmpty) {
      throw Exception(
        'No end shift report returned from server: '
        '${apiResponse.responseMessage}',
      );
    }

    // The endpoint returns a list, but we asked for one specific shift.
    final dto = records.first;
    await _dao.upsertEndShift(_toCompanion(dto));

    // Read back so the caller gets the row exactly as stored (incl. its id).
    final saved = await _dao.getEndShift(
      date: dto.date,
      pos: dto.pos,
      shift: dto.shift,
    );
    if (saved == null) {
      throw StateError('End shift report was not found after saving.');
    }
    return saved;
  }

  /// Returns the locally stored report for this shift, or null if none exists.
  /// No network call is made.
  Future<EndShiftTableData?> getLocalEndShiftReport(
    String date,
    int posId,
    int shiftId,
  ) {
    return _dao.getEndShift(date: date, pos: posId, shift: shiftId);
  }

  EndShiftTableCompanion _toCompanion(EndShiftReportDto dto) {
    return EndShiftTableCompanion.insert(
      date: dto.date,
      pos: dto.pos,
      shift: dto.shift,
      cashier: dto.cashier,
      floating: Value(dto.floating),
      cashfloat: Value(dto.cashfloat),
      salesBeginning: dto.salesBeginning,
      salesEnding: dto.salesEnding,
      totalSales: dto.totalSales,
      receiptBeginning: dto.receiptBeginning,
      receiptEnding: dto.receiptEnding,
      status: dto.status,
      approvedBy: Value(dto.approvedBy),
      approvedDate: Value(dto.approvedDate),
    );
  }
}
