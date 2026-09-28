import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';

import 'package:gpos_provantis/src/core/printutil/shift_report_generator.dart';

import 'package:gpos_provantis/src/core/database/repository/end_shift_report_repository.dart';

part 'end_shift_service.g.dart';

/// Where a report came from. Useful if the UI wants to show
/// "Printed from saved copy" when offline.
enum ShiftReportSource { server, localCache }

class EndShiftResult {
  const EndShiftResult({required this.report, required this.source});

  final EndShiftTableData report;
  final ShiftReportSource source;
}

class EndShiftReportUnavailableException implements Exception {
  const EndShiftReportUnavailableException(this.message);
  final String message;

  @override
  String toString() => 'EndShiftReportUnavailableException: $message';
}

@Riverpod(keepAlive: true)
EndShiftService endShiftService(Ref ref) {
  return EndShiftService(
    repository: ref.watch(endShiftRepositoryProvider),
    printer: ref.watch(shiftReportPrinterServiceProvider),
  );
}

class EndShiftService {
  EndShiftService({
    required EndShiftRepository repository,
    required ShiftReportPrinterService printer,
  }) : _repository = repository,
       _printer = printer;

  final EndShiftRepository _repository;
  final ShiftReportPrinterService _printer;

  /// Gets the shift report and prints it.
  ///
  /// 1. Tries the server; on success the report is saved to the local DB.
  /// 2. If the server is unreachable, falls back to the locally saved copy.
  /// 3. Prints whichever report it ended up with.
  ///
  /// Throws [EndShiftReportUnavailableException] if the server can't be
  /// reached *and* there is no saved copy. Printer errors propagate so the
  /// caller can offer a retry (the report is already saved by then, so a
  /// retry can use [reprintShiftReport] without hitting the network).
  Future<EndShiftResult> printEndShiftReport({
    required String date,
    required int posId,
    required int shiftId,
  }) async {
    final result = await _loadReport(date, posId, shiftId);
    await _printer.printShiftReport(
      ShiftReportPrintData.fromTable(result.report),
    );
    return result;
  }

  /// Reprints strictly from the local DB. Never touches the network.
  Future<EndShiftTableData> reprintShiftReport({
    required String date,
    required int posId,
    required int shiftId,
  }) async {
    final local = await _repository.getLocalEndShiftReport(
      date,
      posId,
      shiftId,
    );
    if (local == null) {
      throw const EndShiftReportUnavailableException(
        'No saved shift report on this device for that shift.',
      );
    }
    await _printer.printShiftReport(
      ShiftReportPrintData.fromTable(local, isReprint: true),
    );
    return local;
  }

  Future<EndShiftResult> _loadReport(
    String date,
    int posId,
    int shiftId,
  ) async {
    try {
      final fresh = await _repository.fetchAndSaveEndShiftReport(
        date,
        posId,
        shiftId,
      );
      return EndShiftResult(report: fresh, source: ShiftReportSource.server);
    } on DioException catch (e) {
      // Only network-level failures fall back. A server that answers with
      // "no data" throws a plain Exception and is deliberately NOT caught.
      debugPrint(
        'EndShiftService: server unreachable (${e.type}), '
        'trying local copy.',
      );

      final local = await _repository.getLocalEndShiftReport(
        date,
        posId,
        shiftId,
      );
      if (local == null) {
        throw EndShiftReportUnavailableException(
          'Could not reach the server and no saved shift report exists on '
          'this device (date=$date, pos=$posId, shift=$shiftId).',
        );
      }
      return EndShiftResult(
        report: local,
        source: ShiftReportSource.localCache,
      );
    }
  }
}
