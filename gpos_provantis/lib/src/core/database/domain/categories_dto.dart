class CategoriesDto {
  final int categoryCode;
  final String categoryName;
  final String status;
  final String createdBy;
  final String createdDate;
  final int isDisplay;

  CategoriesDto({
    required this.categoryCode,
    required this.categoryName,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.isDisplay,
  });

  factory CategoriesDto.fromJson(Map<String, dynamic> json) {
    return CategoriesDto(
      categoryCode: (json['categorycode'] ?? 0).toInt(),
      categoryName: (json['categoryname'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      createdBy: (json['createdby'] ?? '').toString(),
      createdDate: (json['createddate'] ?? '').toString(),
      isDisplay: (json['is_display'] ?? 0).toInt(),
    );
  }
}
