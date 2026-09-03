class PaymentsDto {
  final int paymentId;
  final String paymentName;
  final String status;
  final String createdby;
  final String createddate;

  PaymentsDto({
    required this.paymentId,
    required this.paymentName,
    required this.status,
    required this.createdby,
    required this.createddate,
  });

  factory PaymentsDto.fromJson(Map<String, dynamic> json) {
    return PaymentsDto(
      paymentId: (json['paymentid'] ?? 0).toInt(),
      paymentName: (json['paymentname'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      createdby: (json['createdby'] ?? '').toString(),
      createddate: (json['createddate'] ?? '').toString(),
    );
  }
}
