class ShiftReportDto {
  final String date;
  final int pos;
  final int shift;
  final String cashier;
  final String? floating;
  final double? cashFloat;
  final double salesBeginning;
  final double salesEnding;
  final double totalSales;
  final int receiptBeginning;
  final int receiptEnding;
  final String status;
  final String? approvedBy;
  final String? approvedDate;

  const ShiftReportDto({
    required this.date,
    required this.pos,
    required this.shift,
    required this.cashier,
    required this.floating,
    required this.cashFloat,
    required this.salesBeginning,
    required this.salesEnding,
    required this.totalSales,
    required this.receiptBeginning,
    required this.receiptEnding,
    required this.status,
    required this.approvedBy,
    required this.approvedDate,
  });

  factory ShiftReportDto.fromJson(Map<String, dynamic> json) {
    return ShiftReportDto(
      date: _dateOnly(json['date']),
      pos: _toInt(json['pos']),
      shift: _toInt(json['shift']),
      cashier: (json['cashier'] ?? '').toString(),
      floating: _toNullableString(json['floating']),
      cashFloat: _toNullableDouble(json['cash_float']),
      salesBeginning: _toDouble(json['sales_beginning']),
      salesEnding: _toDouble(json['sales_ending']),
      totalSales: _toDouble(json['total_sales']),
      receiptBeginning: _toInt(json['receipt_beginning']),
      receiptEnding: _toInt(json['receipt_ending']),
      status: (json['status'] ?? '').toString(),
      approvedBy: _toNullableString(json['approvedby']),
      approvedDate: _toNullableString(json['approveddate']),
    );
  }

  /// Keeps just `yyyy-MM-dd`, so a full ISO timestamp from the server still
  /// matches the date that was requested.
  static String _dateOnly(Object? value) {
    final s = (value ?? '').toString();
    return s.length >= 10 ? s.substring(0, 10) : s;
  }

  static String? _toNullableString(Object? value) {
    if (value == null) return null;
    final s = value.toString();
    return s.isEmpty ? null : s;
  }

  /// The server may send numbers as int, double or a numeric string, so they
  /// are never cast directly.
  static int _toInt(Object? value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _toDouble(Object? value) => _toNullableDouble(value) ?? 0;

  static double? _toNullableDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
