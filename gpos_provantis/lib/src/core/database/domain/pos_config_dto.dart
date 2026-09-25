class PosConfigDto {
  final int posId;
  final String posName;
  final String serial;
  final String min;
  final String ptu;
  final String status;
  final String createdBy;
  final String createdDate;

  PosConfigDto({
    required this.posId,
    required this.posName,
    required this.serial,
    required this.min,
    required this.ptu,
    required this.status,
    required this.createdBy,
    required this.createdDate,
  });

  factory PosConfigDto.fromJson(Map<String, dynamic> json) {
    return PosConfigDto(
      posId: json['posid'] is int
          ? json['posid'] as int
          : int.tryParse(json['posid'].toString()) ?? 0,
      posName: (json['posname'] ?? '').toString(),
      serial: (json['serial'] ?? '').toString(),
      min: (json['min'] ?? '').toString(),
      ptu: (json['ptu'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      createdBy: (json['createdby'] ?? '').toString(),
      createdDate: (json['createddate'] ?? '').toString(),
    );
  }
}
