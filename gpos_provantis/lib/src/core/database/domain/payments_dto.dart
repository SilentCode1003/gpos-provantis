class PaymentsDto {
  final String paymentName;

  PaymentsDto({required this.paymentName});

  factory PaymentsDto.fromJson(Map<String, dynamic> json) {
    return PaymentsDto(paymentName: (json['paymentName'] ?? '').toString());
  }
}
