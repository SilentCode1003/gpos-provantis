class PosDetailDto {
  final String posDetailId;

  PosDetailDto({required this.posDetailId});

  factory PosDetailDto.fromJson(Map<String, dynamic> json) {
    return PosDetailDto(posDetailId: (json['posDetailId'] ?? '').toString());
  }
}
