class SalesDto {
  final int id;
  final DateTime createdAt;
  final String detailId;
  final String date;
  final String posId;
  final String paymentType;
  final String referenceId;
  final String paymentName;
  final String items;
  final String total;
  final String cashier;
  final String cash;
  final String ecash;
  final String branch;
  final String discountDetail;
  final String isSync;

  SalesDto({
    required this.id,
    required this.createdAt,
    required this.detailId,
    required this.date,
    required this.posId,
    required this.paymentType,
    required this.referenceId,
    required this.paymentName,
    required this.items,
    required this.total,
    required this.cashier,
    required this.cash,
    required this.ecash,
    required this.branch,
    required this.discountDetail,
    required this.isSync,
  });

  factory SalesDto.fromJson(Map<String, dynamic> json) {
    return SalesDto(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      detailId: json['detailId'],
      date: json['date'],
      posId: json['posId'],
      paymentType: json['paymentType'],
      referenceId: json['referenceId'],
      paymentName: json['paymentName'],
      items: json['items'],
      total: json['total'],
      cashier: json['cashier'],
      cash: json['cash'],
      ecash: json['ecash'],
      branch: json['branch'],
      discountDetail: json['discountDetail'],
      isSync: json['isSync'],
    );
  }
}
