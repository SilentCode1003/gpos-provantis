import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/repository/receipt_history_repository.dart';

part 'receipts_controller.g.dart';

enum ReceiptsSource { server, localCache }

class ReceiptsState {
  const ReceiptsState({
    required this.dateFrom,
    required this.dateTo,
    this.receipts = const [],
    this.source = ReceiptsSource.server,
    this.isLoading = false,
    this.warning,
  });

  /// The selected range, inclusive, as date-only values.
  final DateTime dateFrom;
  final DateTime dateTo;

  /// Receipts pulled from the server (or its cached copy) for the range.
  final List<ReceiptHistoryTableData> receipts;
  final ReceiptsSource source;
  final bool isLoading;

  /// Something worth telling the cashier, but not fatal: the receipts saved on
  /// this device can still be shown.
  final String? warning;

  bool get isSingleDay => dateFrom == dateTo;
}

// Kept alive so a response that lands after the screen closes can't hit a
// disposed notifier. The screen resets it to today every time it opens.
@Riverpod(keepAlive: true)
class ReceiptsController extends _$ReceiptsController {
  int _requestId = 0;
  String? _inFlightKey;

  @override
  ReceiptsState build() {
    final today = _dateOnly(DateTime.now());
    return ReceiptsState(dateFrom: today, dateTo: today, isLoading: true);
  }

  /// Pulls the receipts for [from]..[to] (inclusive).
  ///
  /// With neither given, reloads the current range. With only one, that single
  /// day is loaded. A reversed range is swapped.
  Future<void> load({DateTime? from, DateTime? to}) async {
    var start = _dateOnly(from ?? to ?? state.dateFrom);
    var end = _dateOnly(to ?? from ?? state.dateTo);
    if (end.isBefore(start)) {
      final swap = start;
      start = end;
      end = swap;
    }

    final dateFrom = formatApiDate(start);
    final dateTo = formatApiDate(end);
    final key = '$dateFrom..$dateTo';

    // Same range already loading: don't fire a duplicate request.
    if (_inFlightKey == key) return;

    final requestId = ++_requestId;
    _inFlightKey = key;
    state = ReceiptsState(dateFrom: start, dateTo: end, isLoading: true);

    final repository = ref.read(receiptHistoryRepositoryProvider);

    ReceiptsState result;
    try {
      final rows = await repository.fetchAndSaveReceipts(
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      result = ReceiptsState(dateFrom: start, dateTo: end, receipts: rows);
    } on DioException catch (e) {
      debugPrint('Receipts: server unreachable (${e.type}), using saved copy.');
      result = await _fromLocal(
        repository,
        start,
        end,
        warning:
            'Could not reach the server. Showing receipts saved on this '
            'device.',
      );
    } catch (e) {
      debugPrint('Receipts: load failed: $e');
      result = await _fromLocal(
        repository,
        start,
        end,
        warning:
            'Could not load receipts from the server: '
            '${e.toString().replaceFirst('Exception: ', '')}',
      );
    }

    // A newer request (e.g. another range) took over while this one ran.
    if (requestId != _requestId) return;
    _inFlightKey = null;
    state = result;
  }

  Future<void> refresh() => load();

  Future<ReceiptsState> _fromLocal(
    ReceiptHistoryRepository repository,
    DateTime start,
    DateTime end, {
    required String warning,
  }) async {
    try {
      final local = await repository.getLocalReceipts(
        dateFrom: formatApiDate(start),
        dateTo: formatApiDate(end),
      );
      return ReceiptsState(
        dateFrom: start,
        dateTo: end,
        receipts: local,
        source: ReceiptsSource.localCache,
        warning: warning,
      );
    } catch (e) {
      debugPrint('Receipts: local read failed: $e');
      return ReceiptsState(dateFrom: start, dateTo: end, warning: warning);
    }
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// `yyyy-MM-dd`, the format the API expects.
  static String formatApiDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }
}
