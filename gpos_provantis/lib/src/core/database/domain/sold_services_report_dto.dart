class SoldServicesReportDto {
  final String item;
  final int quantity;
  final double total;

  const SoldServicesReportDto({
    required this.item,
    required this.quantity,
    required this.total,
  });

  factory SoldServicesReportDto.fromJson(Map<String, dynamic> json) {
    return SoldServicesReportDto(
      item: json['item'] as String? ?? '',
      quantity: _toInt(json['quantity']),
      total: _toDouble(json['total']),
    );
  }

  /// The server may send numbers as int, double (`3.0`) or a numeric string,
  /// so they are never cast directly.
  static int _toInt(Object? value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
