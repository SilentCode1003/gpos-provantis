class ServicePackageDto {
  final int id;
  final String name;
  final double price;
  final int quantity;

  const ServicePackageDto({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory ServicePackageDto.fromJson(Map<String, dynamic> json) {
    return ServicePackageDto(
      id: _toInt(json['id']),
      name: (json['name'] ?? '').toString(),
      price: _toDouble(json['price']),
      quantity: _toInt(json['quantity']),
    );
  }

  /// The server may send numbers as int, double or a numeric string, so they
  /// are never cast directly.
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
