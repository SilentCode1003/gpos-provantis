import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/send_cash_report_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/send_cash_report_dao_provider.dart';

import '../domain/send_cash_report_dto.dart';

part 'send_cash_report_repository.g.dart';

@Riverpod(keepAlive: true)
SendCashReportRepository sendCashReportRepository(Ref ref) {
  final dao = ref.watch(sendCashReportDaoProvider);
  return SendCashReportRepository(ref, dao);
}

class SendCashReportRepository {
  SendCashReportRepository(this._ref, this._dao);

  final Ref _ref;
  final SendCashReportDao _dao;

  /// True while [syncPending] is running, so overlapping calls (it is triggered
  /// from several places) can't send the same report twice.
  bool _syncing = false;

  /// Saves the report on this device and returns the stored row. A report that
  /// already exists for the same shift is replaced by this new count.
  ///
  /// This is the part that must never fail to land: the report is stored even
  /// with no connection, then [syncPending] sends it.
  Future<SendCashReportTableData> saveSendCashReport(
    SendCashReportDto report,
  ) async {
    await _dao.upsertForShift(report.toCompanion());
    final saved = await _dao.getForShift(
      branchId: report.branchId,
      posId: report.posId,
      shiftDate: report.shiftDate,
      shift: report.shift,
    );
    if (saved == null) {
      throw StateError('Cash report was not found after saving.');
    }
    return saved;
  }

  Future<SendCashReportTableData?> getSendCashReport(String id) =>
      _dao.getById(id);

  Future<List<SendCashReportTableData>> getLocalSendCashReports() =>
      _dao.getAllSendCashReports();

  Future<List<SendCashReportTableData>> getPendingSendCashReports() =>
      _dao.getPending();

  /// Posts one report to `/mobile-api/cash-report`. Returns normally only if the
  /// server answered `msg: success`; anything else throws, so the caller keeps
  /// it PENDING. Network failures ([DioException]) propagate as well.
  Future<void> submitSendCashReport(SendCashReportTableData row) async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post(
      '/mobile-api/cash-report',
      data: SendCashReportDto.fromTableData(row).toApiJson(),
    );

    final body = response.data;
    final msg = body is Map ? body['msg']?.toString() : null;
    if (msg != 'success') {
      throw Exception(
        'Server did not accept the send cash report'
        '${msg == null ? '.' : ': $msg'}',
      );
    }
  }

  /// Sends every PENDING report and marks the accepted ones SYNCED. A report
  /// that fails stays PENDING with its error recorded, and the rest still go
  /// out. Returns how many were sent.
  Future<int> syncPending() async {
    if (_syncing) return 0;
    _syncing = true;

    try {
      var synced = 0;
      for (final row in await _dao.getPending()) {
        try {
          await submitSendCashReport(row);
          await _dao.markSynced(row.id, DateTime.now());
          synced++;
        } catch (e) {
          debugPrint('SendCashReport: could not send ${row.id}: $e');
          await _dao.markAttemptFailed(row.id, _describe(e));
        }
      }
      return synced;
    } finally {
      _syncing = false;
    }
  }

  String _describe(Object e) {
    if (e is DioException) return 'Network error: ${e.type.name}';
    return e.toString().replaceFirst('Exception: ', '');
  }
}
