import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/repository/cash_report_repository.dart';

part 'cash_reports_controller.g.dart';

enum CashReportsSource { server, localCache }

class CashReportsState {
  const CashReportsState({
    required this.date,
    this.reports = const [],
    this.source = CashReportsSource.server,
    this.isLoading = false,
    this.warning,
    this.errorMessage,
  });

  /// The selected day, as a date-only value.
  final DateTime date;
  final List<CashReportTableData> reports;
  final CashReportsSource source;
  final bool isLoading;

  /// Not fatal: the list is showing a saved copy because the server couldn't
  /// be reached.
  final String? warning;

  /// Fatal for this day: nothing could be loaded at all.
  final String? errorMessage;
}

// Kept alive so a response that lands after the screen closes can't hit a
// disposed notifier. The screen resets it to today every time it opens.
@Riverpod(keepAlive: true)
class CashReportsController extends _$CashReportsController {
  int _requestId = 0;
  String? _inFlightKey;

  @override
  CashReportsState build() =>
      CashReportsState(date: _dateOnly(DateTime.now()), isLoading: true);

  /// Pulls the cash reports for [date] (defaults to the date already selected).
  Future<void> load({DateTime? date}) async {
    final target = _dateOnly(date ?? state.date);
    final key = formatApiDate(target);

    // Same day already loading: don't fire a duplicate request.
    if (_inFlightKey == key) return;

    final requestId = ++_requestId;
    _inFlightKey = key;
    state = CashReportsState(date: target, isLoading: true);

    final repository = ref.read(cashReportRepositoryProvider);

    CashReportsState result;
    try {
      final rows = await repository.fetchAndSaveCashReports(key);
      result = CashReportsState(date: target, reports: rows);
    } on DioException catch (e) {
      debugPrint('CashReports: server unreachable (${e.type}), trying cache.');
      result = await _fromLocal(repository, target, key);
    } catch (e) {
      debugPrint('CashReports: load failed: $e');
      result = CashReportsState(
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

  Future<CashReportsState> _fromLocal(
    CashReportRepository repository,
    DateTime target,
    String key,
  ) async {
    try {
      final local = await repository.getLocalCashReports(key);
      if (local.isNotEmpty) {
        return CashReportsState(
          date: target,
          reports: local,
          source: CashReportsSource.localCache,
          warning: 'Could not reach the server. Showing a saved copy.',
        );
      }
    } catch (e) {
      debugPrint('CashReports: local read failed: $e');
    }
    return CashReportsState(
      date: target,
      errorMessage:
          'Could not reach the server, and no saved cash reports exist for '
          '$key.',
    );
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// `yyyy-MM-dd`, the format the API expects.
  static String formatApiDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }
}
