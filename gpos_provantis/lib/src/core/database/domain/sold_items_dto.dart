class SoldItemsDto {
  final String branch;
  final String category;
  final String name;
  final int quantity;

  const SoldItemsDto({
    required this.branch,
    required this.category,
    required this.name,
    required this.quantity,
  });

  factory SoldItemsDto.fromJson(Map<String, dynamic> json) {
    return SoldItemsDto(
      branch: json['branch'] as String? ?? '',
      category: json['category'] as String? ?? '',
      name: json['name'] as String? ?? '',
      quantity: _toInt(json['quantity']),
    );
  }

  /// The server may send quantity as int, double (`3.0`) or a numeric string,
  /// so it is never cast directly.
  static int _toInt(Object? value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
