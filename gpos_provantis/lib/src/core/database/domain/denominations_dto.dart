class DenominationsDto {
  final int id;
  final String code;
  final String description;
  final int value;
  final String status;
  final String createdBy;
  final String createdDate;

  DenominationsDto({
    required this.id,
    required this.code,
    required this.description,
    required this.value,
    required this.status,
    required this.createdBy,
    required this.createdDate,
  });

  factory DenominationsDto.fromJson(Map<String, dynamic> json) {
    return DenominationsDto(
      id: (json['id'] ?? 0),
      code: (json['code'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      value: (json['value'] ?? 0),
      status: (json['status'] ?? '').toString(),
      createdBy: (json['createdBy'] ?? '').toString(),
      createdDate: (json['createdDate'] ?? '').toString(),
    );
  }
}
