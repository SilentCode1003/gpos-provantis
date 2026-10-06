import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';

/// One denomination in the count, e.g. 5 x 100.
class SendCashReportLineDto {
  const SendCashReportLineDto({
    required this.denominationId,
    required this.value,
    required this.quantity,
  });

  final int denominationId;
  final int value;
  final int quantity;

  int get lineTotal => value * quantity;

  Map<String, dynamic> toJson() => {
    'id': denominationId,
    'value': value,
    'quantity': quantity,
  };

  factory SendCashReportLineDto.fromJson(Map<String, dynamic> json) {
    return SendCashReportLineDto(
      denominationId: _toInt(json['id']),
      value: _toInt(json['value']),
      quantity: _toInt(json['quantity']),
    );
  }

  static int _toInt(Object? value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

/// Values for [SendCashReportTableData.syncStatus].
abstract class SendCashReportSyncStatus {
  static const pending = 'PENDING';
  static const synced = 'SYNCED';
}

class SendCashReportDto {
  const SendCashReportDto({
    required this.id,
    required this.branchId,
    required this.posId,
    required this.shift,
    required this.shiftDate,
    required this.cashierId,
    required this.lines,
    required this.createdAt,
    this.syncStatus = SendCashReportSyncStatus.pending,
  });

  /// A brand-new report for the shift being closed, with a fresh id.
  factory SendCashReportDto.create({
    required String branchId,
    required String posId,
    required String shift,
    required String shiftDate,
    required String cashierId,
    required List<SendCashReportLineDto> lines,
  }) {
    return SendCashReportDto(
      id: const Uuid().v4(),
      branchId: branchId,
      posId: posId,
      shift: shift,
      shiftDate: shiftDate,
      cashierId: cashierId,
      lines: lines,
      createdAt: DateTime.now(),
    );
  }

  final String id;
  final String branchId;
  final String posId;
  final String shift;
  final String shiftDate;
  final String cashierId;
  final List<SendCashReportLineDto> lines;
  final DateTime createdAt;
  final String syncStatus;

  /// Total cash counted.
  double get amount => lines.fold(0, (sum, line) => sum + line.lineTotal);

  factory SendCashReportDto.fromTableData(SendCashReportTableData row) {
    return SendCashReportDto(
      id: row.id,
      branchId: row.branchId,
      posId: row.posId,
      shift: row.shift,
      shiftDate: row.shiftDate,
      cashierId: row.cashierId,
      lines: decodeLines(row.linesJson),
      createdAt: row.createdAt,
      syncStatus: row.syncStatus,
    );
  }

  SendCashReportTableCompanion toCompanion() {
    return SendCashReportTableCompanion.insert(
      id: Value(id),
      branchId: branchId,
      posId: posId,
      shift: shift,
      shiftDate: shiftDate,
      cashierId: cashierId,
      amount: amount,
      linesJson: Value(encodeLines(lines)),
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
    );
  }

  /// The body `POST /mobile-api/cash-report` expects. Every value is a string,
  /// `denomination` is itself a JSON string, and each `quantity` inside it is a
  /// string too:
  ///
  /// ```
  /// {branchid: '001', shift: '2', cashier: '200000', shiftdate: '2026-10-06',
  ///  posid: '1', amount: '750.0',
  ///  denomination: '[{"id":6,"value":50,"quantity":"5"}, ...]'}
  /// ```
  Map<String, dynamic> toApiJson() => {
    'branchid': branchId,
    'shift': shift,
    'cashier': cashierId,
    'shiftdate': shiftDate,
    'posid': posId,
    'amount': amount.toString(),
    'denomination': jsonEncode([
      for (final l in lines)
        {'id': l.denominationId, 'value': l.value, 'quantity': '${l.quantity}'},
    ]),
  };

  static String encodeLines(List<SendCashReportLineDto> lines) =>
      jsonEncode([for (final l in lines) l.toJson()]);

  static List<SendCashReportLineDto> decodeLines(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return [
        for (final x in decoded)
          if (x is Map<String, dynamic>) SendCashReportLineDto.fromJson(x),
      ];
    } catch (_) {
      return const [];
    }
  }
}