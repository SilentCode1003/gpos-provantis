// Location: src/features/dashboard/controllers/receipt_reprint_controller.dart
//
// Reprint's own way of producing a `ReceiptSaleData` — the mirror of
// `_receiptDataFromCheckout` in dashboard_controller.dart, but reading
// a persisted `SalesTableData` row back out of `SalesDao` instead of a
// live `DashboardState`. See receipt_generator.dart's file-level
// ISOLATION note: that file deliberately has no factory for this, so
// the translation from a saved row to `ReceiptSaleData` lives here
// instead, next to the reprint screen that needs it.
import 'dart:convert';

import 'package:gpos_provantis/src/core/database/app_database.dart'
    show SalesTableData;
import 'package:gpos_provantis/src/core/printutil/receipt_generator.dart'
    show ReceiptSaleData, ReceiptLineItem;

/// Prefix every synthetic discount line's `name` starts with — see
/// `_buildItemsJson`/`_cartLineToItemJson` in dashboard_controller.dart,
/// which is the only place that writes this format. Matched here so a
/// reprinted ticket can pull that line back out and show it as its own
/// DISCOUNT row again, the same way the original ticket did, instead of
/// printing it as if it were an ordinary product line.
const _discountLineNamePrefix = 'Discount (';

/// Builds a [ReceiptSaleData] for reprinting from a row already saved
/// by `SalesDao` (see sales_table.dart / sales_dao.dart). Every field on
/// `SalesTable` is a plain `TextColumn` — including `total`, `cash` and
/// `ecash`, which checkout writes as `value.toString()` (see
/// `_formatMoney` in dashboard_controller.dart) — so numeric fields are
/// parsed back out here, falling back to `0` for a row saved before a
/// field existed or with unexpectedly malformed data, rather than
/// throwing and blocking the reprint entirely.
///
/// `subtotal`/`discountLabel`/`discountAmount` have no columns of their
/// own on `SalesTable` — checkout folds the discount into `items` as one
/// synthetic negative-price line (see `_buildItemsJson`'s doc comment).
/// This reverses that: any item line whose name starts with
/// [_discountLineNamePrefix] is pulled out of the printed item list and
/// used to populate those three fields instead, so the reprinted ticket
/// shows the same TOTAL AMOUNT / DISCOUNT (..) / etc breakdown the
/// original did rather than listing "Discount (5% Discount)" as if it
/// were a product.
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
      // The discount line's own price is stored negative (see
      // `_buildItemsJson`); `discountAmount` on `ReceiptSaleData` is a
      // positive magnitude that `_buildTicketBytes` negates itself when
      // printing (see `_amountRow(..., -sale.discountAmount)`), so flip
      // the sign back here.
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

  // `SalesTable` has no `subtotal` column — recovered as total plus
  // whatever discount was pulled back out above (0 when there wasn't
  // one, so subtotal falls back to total exactly like a no-discount
  // sale).
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

/// Decodes `row.items` (see `_buildItemsJson`) defensively: a row saved
/// before this column existed, or any unexpectedly malformed JSON,
/// yields an empty item list rather than throwing and blocking the
/// reprint — the rest of the ticket (totals, payment, cashier) still has
/// everything it needs to print correctly even with no item rows shown.
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
