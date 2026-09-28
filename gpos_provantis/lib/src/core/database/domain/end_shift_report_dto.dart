class EndShiftReportDto {
  final String date;
  final int pos;
  final int shift;
  final String cashier;
  final String? floating;
  final String? cashfloat;
  final double salesBeginning;
  final double salesEnding;
  final double totalSales;
  final int receiptBeginning;
  final int receiptEnding;
  final String status;
  final String? approvedBy;
  final String? approvedDate;

  const EndShiftReportDto({
    required this.date,
    required this.pos,
    required this.shift,
    required this.cashier,
    this.floating,
    this.cashfloat,
    required this.salesBeginning,
    required this.salesEnding,
    required this.totalSales,
    required this.receiptBeginning,
    required this.receiptEnding,
    required this.status,
    this.approvedBy,
    this.approvedDate,
  });

  /// The server returns all-lowercase keys (`salesbeginning`, `receiptending`,
  /// `approvedby`, ...) and may send numbers as either int or double
  /// (e.g. `600` rather than `600.0`), so every numeric field goes through
  /// [_toDouble] / [_toInt] instead of a direct cast.
  factory EndShiftReportDto.fromJson(Map<String, dynamic> json) {
    return EndShiftReportDto(
      date: json['date'] as String? ?? '',
      pos: _toInt(json['pos']),
      shift: _toInt(json['shift']),
      cashier: json['cashier'] as String? ?? '',
      floating: json['floating'] as String?,
      cashfloat: json['cashfloat'] as String?,
      salesBeginning: _toDouble(json['salesbeginning']),
      salesEnding: _toDouble(json['salesending']),
      totalSales: _toDouble(json['totalsales']),
      receiptBeginning: _toInt(json['receiptbeginning']),
      receiptEnding: _toInt(json['receiptending']),
      status: json['status'] as String? ?? '',
      approvedBy: json['approvedby'] as String?,
      approvedDate: json['approveddate'] as String?,
    );
  }

  static double _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _toInt(Object? value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
