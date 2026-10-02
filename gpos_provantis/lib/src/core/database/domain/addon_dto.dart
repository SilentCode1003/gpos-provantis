class AddonDto {
  final int id;
  final String name;
  final String type;
  final double price;
  final bool isProduct;
  final String status;
  final String createdBy;
  final String createdDate;

  const AddonDto({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.isProduct,
    required this.status,
    required this.createdBy,
    required this.createdDate,
  });

  factory AddonDto.fromJson(Map<String, dynamic> json) {
    return AddonDto(
      id: _toInt(json['id']),
      name: (json['name'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      price: _toDouble(json['price']),
      isProduct: _toBool(json['isproduct']),
      status: (json['status'] ?? '').toString(),
      createdBy: (json['createdby'] ?? '').toString(),
      createdDate: (json['createddate'] ?? '').toString(),
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

  /// Flags straight from MySQL often arrive as 0/1 (tinyint) or "0"/"1", not
  /// real booleans.
  static bool _toBool(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final v = value.trim().toLowerCase();
      return v == 'true' || v == '1';
    }
    return false;
  }
}
