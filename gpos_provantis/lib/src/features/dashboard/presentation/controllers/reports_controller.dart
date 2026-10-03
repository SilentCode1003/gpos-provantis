import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/repository/shift_report_repository.dart';
import 'package:gpos_provantis/src/services/end_shift_service.dart';

part 'reports_controller.g.dart';

/// Where the list on screen came from.
enum ReportsSource { server, localCache }

/// A one-off message for the UI to show (e.g. in a snackbar).
class ReportsNotice {
  const ReportsNotice(this.message, {this.isError = false});

  final String message;
  final bool isError;
}

/// Identifies one shift row, for tracking which one is printing.
String shiftKey(ShiftReportTableData shift) =>
    '${shift.date}-${shift.pos}-${shift.shift}';

class ReportsState {
  const ReportsState({
    required this.date,
    this.shifts = const [],
    this.source = ReportsSource.server,
    this.isLoading = false,
    this.errorMessage,
    this.printingKey,
    this.notice,
  });

  final DateTime date;
  final List<ShiftReportTableData> shifts;
  final ReportsSource source;
  final bool isLoading;

  /// Set when the day couldn't be loaded at all (no server and no saved copy).
  final String? errorMessage;

  /// [shiftKey] of the shift currently being printed, if any.
  final String? printingKey;

  /// Result of the last print attempt. A new object each time, so the UI can
  /// tell a fresh one from one it already showed.
  final ReportsNotice? notice;

  double get totalSales => shifts.fold(0.0, (sum, s) => sum + s.totalSales);

  ReportsState copyWith({
    String? printingKey,
    bool clearPrinting = false,
    ReportsNotice? notice,
    bool clearNotice = false,
  }) {
    return ReportsState(
      date: date,
      shifts: shifts,
      source: source,
      isLoading: isLoading,
      errorMessage: errorMessage,
      printingKey: clearPrinting ? null : (printingKey ?? this.printingKey),
      notice: clearNotice ? null : (notice ?? this.notice),
    );
  }
}

// Kept alive so a response that lands after the screen closes can't hit a
// disposed notifier. The screen resets it to today every time it opens.
@Riverpod(keepAlive: true)
class ReportsController extends _$ReportsController {
  int _requestId = 0;
  String? _inFlightKey;

  @override
  ReportsState build() =>
      ReportsState(date: _dateOnly(DateTime.now()), isLoading: true);

  /// Loads the shifts for [date] (defaults to the date already selected).
  Future<void> load({DateTime? date}) async {
    final target = _dateOnly(date ?? state.date);
    final key = formatApiDate(target);

    // Same day already loading: don't fire a duplicate request.
    if (_inFlightKey == key) return;

    final requestId = ++_requestId;
    _inFlightKey = key;
    state = ReportsState(date: target, isLoading: true);

    final repository = ref.read(shiftReportRepositoryProvider);

    ReportsState result;
    try {
      final rows = await repository.fetchAndSaveShiftReports(key);
      result = ReportsState(date: target, shifts: rows);
    } on DioException catch (e) {
      debugPrint('Reports: server unreachable (${e.type}), trying local copy.');
      result = await _fromLocal(repository, target, key);
    } catch (e) {
      debugPrint('Reports: load failed: $e');
      result = ReportsState(
        date: target,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }

    // A newer request (e.g. another date) took over while this one ran.
    if (requestId != _requestId) return;
    _inFlightKey = null;
    state = result;
  }

  Future<void> refresh() => load();

  /// Prints [shift]'s end-of-shift report, marked as a REPRINT. One print at
  /// a time: ignored while another is still going.
  Future<void> printShift(ShiftReportTableData shift) async {
    if (state.printingKey != null) return;

    final service = ref.read(endShiftServiceProvider);
    state = state.copyWith(printingKey: shiftKey(shift), clearNotice: true);

    ReportsNotice notice;
    try {
      final result = await service.printEndShiftReport(
        date: shift.date,
        posId: shift.pos,
        shiftId: shift.shift,
        isReprint: true,
      );

      var message = 'Shift ${shift.shift} sent to the printer.';
      if (result.source == ShiftReportSource.localCache) {
        message += ' Printed from the saved copy.';
      }
      if (!result.isComplete) {
        message += ' Some sections were unavailable.';
      }
      notice = ReportsNotice(message);
    } catch (e) {
      debugPrint('Reports: print failed: $e');
      notice = ReportsNotice(
        'Could not print shift ${shift.shift}. ${_describe(e)}',
        isError: true,
      );
    }

    state = state.copyWith(clearPrinting: true, notice: notice);
  }

  String _describe(Object e) {
    if (e is EndShiftReportUnavailableException) return e.message;
    if (e is DioException) {
      return 'Could not reach the server. Check the connection and try again.';
    }
    return e.toString().replaceFirst('Exception: ', '');
  }

  Future<ReportsState> _fromLocal(
    ShiftReportRepository repository,
    DateTime target,
    String key,
  ) async {
    try {
      final local = await repository.getLocalShiftReports(key);
      if (local.isNotEmpty) {
        return ReportsState(
          date: target,
          shifts: local,
          source: ReportsSource.localCache,
        );
      }
    } catch (e) {
      debugPrint('Reports: local read failed: $e');
    }
    return ReportsState(
      date: target,
      errorMessage:
          'Could not reach the server, and no saved reports exist for $key.',
    );
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// `yyyy-MM-dd`, the format the API expects.
  static String formatApiDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }
}
