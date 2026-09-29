class PosShiftDto {
  final String posId;
  final String date;
  final String shift;
  final String status;

  PosShiftDto({
    required this.posId,
    required this.date,
    required this.shift,
    required this.status,
  });

  factory PosShiftDto.fromJson(Map<String, dynamic> json) {
    return PosShiftDto(
      posId: (json['posid'] ?? '').toString(),
      date: (json['date'] ?? '').toString(),
      shift: (json['shift'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
    );
  }
}
