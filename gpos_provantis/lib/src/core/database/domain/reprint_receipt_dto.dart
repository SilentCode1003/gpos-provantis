/// One row of `/salesdetails/getdetails`.
///
/// A receipt paid with a single method comes back as one row; a SPLIT (or
/// two e-payment) receipt comes back as one row per payment, with the receipt
/// fields repeated on each row.
class ReprintReceiptDto {
  final String orNumber;
  final String orDate;
  final String orDescription; // JSON string of the line items
  final String orPaymentType;
  final String posId;
  final String shift;
  final String cashier;
  final double total;
  final String paymentMethod;
  final String referenceId;
  final double amount;

  const ReprintReceiptDto({
    required this.orNumber,
    required this.orDate,
    required this.orDescription,
    required this.orPaymentType,
    required this.posId,
    required this.shift,
    required this.cashier,
    required this.total,
    required this.paymentMethod,
    required this.referenceId,
    required this.amount,
  });

  factory ReprintReceiptDto.fromJson(Map<String, dynamic> json) {
    return ReprintReceiptDto(
      orNumber: _toStr(json['ornumber']),
      orDate: _toStr(json['ordate']),
      orDescription: _toStr(json['ordescription']),
      orPaymentType: _toStr(json['orpaymenttype']),
      posId: _toStr(json['posid']),
      shift: _toStr(json['shift']),
      cashier: _toStr(json['cashier']),
      total: _toDouble(json['total']),
      paymentMethod: _toStr(json['paymentmethod']),
      referenceId: _toStr(json['referenceid']),
      amount: _toDouble(json['amount']),
    );
  }

  bool get isCash => paymentMethod.trim().toUpperCase() == 'CASH';

  /// The server may send numbers as int, double or numeric strings
  /// (`total` is a string), so nothing is cast directly.
  static double _toDouble(Object? v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }

  static String _toStr(Object? v) => v == null ? '' : v.toString();
}
