class PromoDto {
  final int promoId;
  final String name;
  final String description;
  final String condition;
  final String startDate;
  final String endDate;
  final String status;
  final String createdBy;
  final String createdDate;

  PromoDto({
    required this.promoId,
    required this.name,
    required this.description,
    required this.condition,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdBy,
    required this.createdDate,
  });

  factory PromoDto.fromJson(Map<String, dynamic> json) {
    return PromoDto(
      promoId: (json['promoid'] ?? 0).toInt(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      condition: (json['condition'] ?? '').toString(),
      startDate: (json['startdate'] ?? '').toString(),
      endDate: (json['enddate'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      createdBy: (json['createdby'] ?? '').toString(),
      createdDate: (json['createddate'] ?? '').toString(),
    );
  }
}
