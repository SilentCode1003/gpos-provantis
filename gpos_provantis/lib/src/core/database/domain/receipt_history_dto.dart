import 'dart:convert';

import 'package:gpos_provantis/src/core/database/app_database.dart'
    show ReceiptHistoryTableData;

/// One payment taken for a receipt. The server sends one row per tender, so a
/// split sale (e.g. GCASH 120 + CASH 200) arrives as two rows.
class ReceiptTender {
  const ReceiptTender({
    required this.type,
    required this.amount,
    this.reference = '',
  });

  final String type;
  final double amount;

  /// The e-payment reference for this payment, when the server sends one.
  final String reference;

  Map<String, dynamic> toJson() => {
    'type': type,
    'amount': amount,
    'reference': reference,
  };

  factory ReceiptTender.fromJson(Map<String, dynamic> json) {
    return ReceiptTender(
      type: (json['type'] ?? '').toString(),
      amount: _toDouble(json['amount']),
      reference: (json['reference'] ?? '').toString(),
    );
  }
}

/// One line of a receipt, parsed from the server's `description` JSON.
class ReceiptHistoryItem {
  const ReceiptHistoryItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  final String id;
  final String name;
  final double price;
  final int quantity;

  double get lineTotal => price * quantity;

  factory ReceiptHistoryItem.fromJson(Map<String, dynamic> json) {
    return ReceiptHistoryItem(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      price: _toDouble(json['price']),
      quantity: _toInt(json['quantity']),
    );
  }
}

/// A receipt as sent by `/salesdetails/getreceipts`, with the per-tender rows
/// already merged into [tenders].
class ReceiptHistoryDto {
  const ReceiptHistoryDto({
    required this.detailId,
    required this.dateText,
    required this.dateTime,
    required this.shift,
    required this.paymentType,
    required this.description,
    required this.total,
    required this.cashier,
    required this.status,
    required this.ePaymentType,
    required this.referenceId,
    required this.tenders,
  });

  final String detailId;

  /// As sent, e.g. "2026-09-30 14:19".
  final String dateText;
  final DateTime dateTime;
  final int shift;
  final String paymentType;

  /// Raw JSON array of items, kept as-is.
  final String description;
  final double total;
  final String cashier;
  final String status;
  final String ePaymentType;
  final String referenceId;
  final List<ReceiptTender> tenders;

  /// `yyyy-MM-dd`, or empty if the server's date couldn't be read.
  String get receiptDate =>
      dateText.length >= 10 ? dateText.substring(0, 10) : '';

  /// Parses ONE server row (a receipt with a single tender).
  factory ReceiptHistoryDto.fromJson(Map<String, dynamic> json) {
    final dateText = (json['date'] ?? '').toString();
    final tenderType = (json['tenderpaymenttype'] ?? '').toString();

    return ReceiptHistoryDto(
      detailId: (json['detail_id'] ?? '').toString(),
      dateText: dateText,
      dateTime:
          DateTime.tryParse(dateText) ?? DateTime.fromMillisecondsSinceEpoch(0),
      shift: _toInt(json['shift']),
      paymentType: (json['payment_type'] ?? '').toString(),
      description: (json['description'] ?? '[]').toString(),
      total: _toDouble(json['total']),
      cashier: (json['cashier'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      ePaymentType: (json['epaymenttype'] ?? '').toString(),
      referenceId: (json['referenceid'] ?? '').toString(),
      tenders: tenderType.isEmpty
          ? const []
          : [
              ReceiptTender(
                type: tenderType,
                amount: _toDouble(json['tenderamount']),
                reference: (json['referenceid'] ?? '').toString(),
              ),
            ],
    );
  }

  /// Merges rows that share a `detail_id` into one receipt with all of its
  /// tenders, keeping the order the server sent them in.
  static List<ReceiptHistoryDto> groupRows(Iterable<ReceiptHistoryDto> rows) {
    final byId = <String, ReceiptHistoryDto>{};
    for (final row in rows) {
      final existing = byId[row.detailId];
      if (existing == null) {
        byId[row.detailId] = row;
      } else {
        byId[row.detailId] = existing._withTenders([
          ...existing.tenders,
          ...row.tenders,
        ]);
      }
    }
    return byId.values.toList();
  }

  ReceiptHistoryDto _withTenders(List<ReceiptTender> tenders) {
    return ReceiptHistoryDto(
      detailId: detailId,
      dateText: dateText,
      dateTime: dateTime,
      shift: shift,
      paymentType: paymentType,
      description: description,
      total: total,
      cashier: cashier,
      status: status,
      ePaymentType: ePaymentType,
      referenceId: referenceId,
      tenders: tenders,
    );
  }

  String get tendersJson => jsonEncode([for (final t in tenders) t.toJson()]);
}

/// Convenience readers for a stored receipt.
extension ReceiptHistoryRow on ReceiptHistoryTableData {
  List<ReceiptHistoryItem> get items {
    try {
      final decoded = jsonDecode(description);
      if (decoded is! List) return const [];
      return [
        for (final x in decoded)
          if (x is Map<String, dynamic>) ReceiptHistoryItem.fromJson(x),
      ];
    } catch (_) {
      return const [];
    }
  }

  List<ReceiptTender> get tenders {
    try {
      final decoded = jsonDecode(tendersJson);
      if (decoded is! List) return const [];
      return [
        for (final x in decoded)
          if (x is Map<String, dynamic>) ReceiptTender.fromJson(x),
      ];
    } catch (_) {
      return const [];
    }
  }
}

int _toInt(Object? value) {
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _toDouble(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}
