class StaffSalesReportDto {
  final String salesStaff;
  final double total;

  const StaffSalesReportDto({required this.salesStaff, required this.total});

  factory StaffSalesReportDto.fromJson(Map<String, dynamic> json) {
    return StaffSalesReportDto(
      salesStaff: json['salesstaff'] as String? ?? '',
      total: _toDouble(json['total']),
    );
  }

  /// The server may send numbers as int, double or a numeric string, so they
  /// are never cast directly.
  static double _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
