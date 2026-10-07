import 'dart:convert';

import 'package:gpos_provantis/src/core/database/app_database.dart'
    show CashReportTableData;

/// One denomination in a cash report, e.g. 5 x 100.
class CashReportLineDto {
  const CashReportLineDto({
    required this.denominationId,
    required this.value,
    required this.quantity,
  });

  final int denominationId;
  final int value;
  final int quantity;

  int get lineTotal => value * quantity;

  factory CashReportLineDto.fromJson(Map<String, dynamic> json) {
    return CashReportLineDto(
      denominationId: _toInt(json['id']),
      value: _toInt(json['value']),
      // The server sends quantity as a string ("5").
      quantity: _toInt(json['quantity']),
    );
  }
}

/// A cash report as sent by `/mobile-api/getcashreport`.
class CashReportDto {
  const CashReportDto({
    required this.branchId,
    required this.posId,
    required this.shift,
    required this.shiftDate,
    required this.cashFloat,
    required this.totalCash,
    required this.denomination,
  });

  final String branchId;
  final String posId;
  final int shift;

  /// `yyyy-MM-dd`.
  final String shiftDate;
  final double cashFloat;
  final double totalCash;

  /// Raw JSON array of denominations, kept as-is.
  final String denomination;

  factory CashReportDto.fromJson(Map<String, dynamic> json) {
    final date = (json['shiftdate'] ?? '').toString();

    // The server sends `denomination` as a JSON *string*; accept a real list
    // too in case that ever changes.
    final rawDenomination = json['denomination'];
    final denomination = rawDenomination is String
        ? rawDenomination
        : (rawDenomination is List ? jsonEncode(rawDenomination) : '[]');

    return CashReportDto(
      branchId: (json['branch_id'] ?? '').toString(),
      posId: (json['pos_id'] ?? '').toString(),
      shift: _toInt(json['shift']),
      shiftDate: date.length >= 10 ? date.substring(0, 10) : date,
      cashFloat: _toDouble(json['cash_float']),
      totalCash: _toDouble(json['total_cash']),
      denomination: denomination,
    );
  }
}

/// Convenience readers for a stored cash report.
extension CashReportRow on CashReportTableData {
  /// Every denomination, including those counted as zero.
  List<CashReportLineDto> get lines {
    try {
      final decoded = jsonDecode(denominationJson);
      if (decoded is! List) return const [];
      return [
        for (final x in decoded)
          if (x is Map<String, dynamic>) CashReportLineDto.fromJson(x),
      ];
    } catch (_) {
      return const [];
    }
  }

  /// Only the denominations that actually have cash in them.
  List<CashReportLineDto> get countedLines => [
    for (final l in lines)
      if (l.quantity > 0) l,
  ];
}

int _toInt(Object? value) {
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _toDouble(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}
