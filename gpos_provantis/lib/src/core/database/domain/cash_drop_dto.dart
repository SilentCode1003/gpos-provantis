import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:gpos_provantis/src/core/database/app_database.dart';

/// One denomination in a cash drop, e.g. 3 x 500.
class CashDropLineDto {
  const CashDropLineDto({
    required this.denominationId,
    required this.label,
    required this.value,
    required this.quantity,
  });

  final int denominationId;
  final String label;
  final int value;
  final int quantity;

  double get lineTotal => (value * quantity).toDouble();

  Map<String, dynamic> toJson() => {
    'id': denominationId,
    'label': label,
    'value': value,
    'quantity': quantity,
  };

  factory CashDropLineDto.fromJson(Map<String, dynamic> json) {
    return CashDropLineDto(
      denominationId: _toInt(json['id']),
      label: (json['label'] ?? '').toString(),
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

/// Values for [CashDropTableData.syncStatus].
abstract class CashDropSyncStatus {
  static const pending = 'PENDING';
  static const synced = 'SYNCED';
}

class CashDropDto {
  const CashDropDto({
    required this.id,
    required this.branchId,
    required this.posId,
    required this.shift,
    required this.shiftDate,
    required this.cashierId,
    required this.cashierName,
    required this.lines,
    required this.createdAt,
    this.syncStatus = CashDropSyncStatus.pending,
  });

  final String id;
  final String branchId;
  final String posId;
  final String shift;
  final String shiftDate;
  final String cashierId;
  final String cashierName;
  final List<CashDropLineDto> lines;
  final DateTime createdAt;
  final String syncStatus;

  double get amount => lines.fold(0, (sum, line) => sum + line.lineTotal);

  factory CashDropDto.fromTableData(CashDropTableData row) {
    return CashDropDto(
      id: row.id,
      branchId: row.branchId,
      posId: row.posId,
      shift: row.shift,
      shiftDate: row.shiftDate,
      cashierId: row.cashierId,
      cashierName: row.cashierName,
      lines: decodeLines(row.linesJson),
      createdAt: row.createdAt,
      syncStatus: row.syncStatus,
    );
  }

  CashDropTableCompanion toCompanion() {
    return CashDropTableCompanion.insert(
      id: Value(id),
      branchId: branchId,
      posId: posId,
      shift: shift,
      shiftDate: shiftDate,
      cashierId: cashierId,
      cashierName: cashierName,
      amount: amount,
      linesJson: Value(encodeLines(lines)),
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
    );
  }

  /// PLACEHOLDER payload, modelled on what the old app saved for a cash drop
  /// (`cashdrop.json` + the cash-drawer activity). Adjust once the server
  /// endpoint actually exists.
  Map<String, dynamic> toApiJson() => {
    'id': id,
    'branchid': branchId,
    'posid': posId,
    'shift': shift,
    'shiftdate': shiftDate,
    'cashier': cashierId,
    'amount': amount,
    'denomination': [
      for (final l in lines)
        {'id': l.denominationId, 'value': l.value, 'quantity': l.quantity},
    ],
  };

  static String encodeLines(List<CashDropLineDto> lines) =>
      jsonEncode([for (final l in lines) l.toJson()]);

  static List<CashDropLineDto> decodeLines(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return [
        for (final x in decoded)
          if (x is Map<String, dynamic>) CashDropLineDto.fromJson(x),
      ];
    } catch (_) {
      return const [];
    }
  }
}
