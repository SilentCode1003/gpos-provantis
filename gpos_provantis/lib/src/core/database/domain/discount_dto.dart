class DiscountDto {
  final int discountId;
  final String name;
  final String description;
  final int rate;
  final String status;
  final String createdBy;
  final String createdDate;

  DiscountDto({
    required this.discountId,
    required this.name,
    required this.description,
    required this.rate,
    required this.status,
    required this.createdBy,
    required this.createdDate,
  });

  factory DiscountDto.fromJson(Map<String, dynamic> json) {
    return DiscountDto(
      discountId: (json['discountid'] ?? 0).toInt(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      rate: (json['rate'] ?? 0).toInt(),
      status: (json['status'] ?? '').toString(),
      createdBy: (json['createdby'] ?? '').toString(),
      createdDate: (json['createddate'] ?? '').toString(),
    );
  }
}
