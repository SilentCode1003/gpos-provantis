import 'dart:convert';

import 'package:gpos_provantis/src/core/database/app_database.dart'
    show SalesTableData;
import 'package:gpos_provantis/src/core/printutil/receipt_generator.dart'
    show ReceiptSaleData, ReceiptLineItem;

const _discountLineNamePrefix = 'Discount (';

ReceiptSaleData receiptSaleDataFromSaleRow(SalesTableData row) {
  final total = double.tryParse(row.total) ?? 0;
  final cash = double.tryParse(row.cash) ?? 0;
  final ecash = double.tryParse(row.ecash) ?? 0;

  final rawItems = _decodeItemsJson(row.items);

  String? discountLabel;
  double discountAmount = 0;
  final lineItems = <ReceiptLineItem>[];

  for (final raw in rawItems) {
    final name = raw['name'] as String? ?? '';
    final price = (raw['price'] as num?)?.toDouble() ?? 0;

    if (name.startsWith(_discountLineNamePrefix) && price < 0) {
      discountLabel = name;
      discountAmount = -price;
      continue;
    }

    lineItems.add(
      ReceiptLineItem(
        name: name,
        quantity: (raw['quantity'] as num?)?.toInt() ?? 1,
        price: price,
      ),
    );
  }

  final subtotal = total + discountAmount;

  return ReceiptSaleData(
    detailId: row.detailId,
    posId: row.posid,
    shift: row.shift,
    cashier: row.cashier,
    branchId: row.branch,
    dateTime: row.createdAt,
    items: lineItems,
    subtotal: subtotal,
    discountLabel: discountLabel,
    discountAmount: discountAmount,
    total: total,
    paymentType: row.paymentType,
    cash: cash,
    ecash: ecash,
    referenceId: row.referenceId,
    paymentName: row.paymentName,
    isReprint: true,
  );
}

List<Map<String, dynamic>> _decodeItemsJson(String raw) {
  if (raw.isEmpty || raw == 'UNREGISTERED') return const [];
  try {
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      return decoded.whereType<Map<String, dynamic>>().toList();
    }
    return const [];
  } catch (_) {
    return const [];
  }
}
