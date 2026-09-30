class PaymentSummaryReportDto {
  final String paymentType;
  final double total;

  const PaymentSummaryReportDto({
    required this.paymentType,
    required this.total,
  });

  factory PaymentSummaryReportDto.fromJson(Map<String, dynamic> json) {
    return PaymentSummaryReportDto(
      paymentType: json['paymenttype'] as String? ?? '',
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
