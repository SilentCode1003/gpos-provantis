import 'package:gpos_provantis/src/core/database/app_database.dart'
    show ReceiptHistoryTableData;
import 'package:gpos_provantis/src/core/printutil/receipt_generator.dart'
    show ReceiptSaleData, ReceiptLineItem;

import 'receipt_history_dto.dart';

/// Rebuilds the [ReceiptSaleData] for a receipt pulled from the server, so it
/// can be previewed and reprinted like any other.
///
/// It mirrors how the dashboard fills the same data at checkout:
///  * CASH     -> cash = amount tendered, ecash = 0, name/reference "CASH".
///  * EPAYMENT -> cash = 0, ecash = the full total, name = the e-wallet.
///  * SPLIT    -> cash = the CASH tender, ecash = the non-cash tender(s).
///  * A discount is stored as a negative line named "Discount (...)" inside the
///    items; it is pulled out into [ReceiptSaleData.discountAmount] / label and
///    left out of the item list, exactly as at checkout.
///
/// [branchId] isn't part of the server's response, so the caller supplies the
/// one configured on this device.
ReceiptSaleData receiptHistoryToSaleData(
  ReceiptHistoryTableData row, {
  required String branchId,
}) {
  final lines = row.items;

  bool isDiscount(ReceiptHistoryItem i) =>
      i.name.toLowerCase().contains('discount');

  final productLines = lines.where((i) => !isDiscount(i)).toList();
  final discountLines = lines.where(isDiscount).toList();

  final subtotal = productLines.fold<double>(0, (sum, i) => sum + i.lineTotal);
  final discountAmount = discountLines
      .fold<double>(0, (sum, i) => sum + i.lineTotal)
      .abs();

  // ---- payment -------------------------------------------------------------
  final tenders = row.tenders;
  bool isCash(ReceiptTender t) => t.type.toUpperCase() == 'CASH';

  final cashTendered = tenders
      .where(isCash)
      .fold<double>(0, (sum, t) => sum + t.amount);
  final nonCash = tenders.where((t) => !isCash(t)).toList();
  final nonCashTendered = nonCash.fold<double>(0, (sum, t) => sum + t.amount);

  final paymentType = row.paymentType.toUpperCase();

  final double cash;
  final double ecash;
  switch (paymentType) {
    case 'EPAYMENT':
      cash = 0;
      // The server records 0 as the tender for a pure e-payment.
      ecash = nonCashTendered > 0 ? nonCashTendered : row.total;
    case 'SPLIT':
      cash = cashTendered;
      ecash = nonCashTendered;
    case 'E2E':
      // Two e-payments: `ecash` is the first one; the second is passed
      // separately below.
      cash = 0;
      ecash = nonCash.isNotEmpty ? nonCash.first.amount : row.total;
    default:
      cash = cashTendered > 0 ? cashTendered : row.total;
      ecash = 0;
  }

  final isE2E = paymentType == 'E2E';
  final isCashSale =
      paymentType != 'EPAYMENT' && paymentType != 'SPLIT' && !isE2E;
  final paymentName = isCashSale
      ? 'CASH'
      : (nonCash.isNotEmpty ? nonCash.first.type : '');
  final referenceId = isCashSale
      ? 'CASH'
      : (isE2E && nonCash.isNotEmpty
            ? nonCash.first.reference
            : row.referenceId);

  final second = isE2E && nonCash.length > 1 ? nonCash[1] : null;

  return ReceiptSaleData(
    detailId: row.detailId,
    posId: row.posId.toString(),
    shift: row.shift.toString(),
    cashier: row.cashier,
    branchId: branchId,
    dateTime: row.createdAt,
    items: [
      for (final i in productLines)
        ReceiptLineItem(name: i.name, quantity: i.quantity, price: i.price),
    ],
    subtotal: subtotal,
    discountLabel: discountLines.isEmpty
        ? null
        : _discountLabel(discountLines.first.name),
    discountAmount: discountAmount,
    total: row.total,
    paymentType: row.paymentType,
    cash: cash,
    ecash: ecash,
    referenceId: referenceId,
    paymentName: paymentName,
    secondPaymentName: second?.type ?? '',
    secondReferenceId: second?.reference ?? '',
    secondAmount: second?.amount ?? 0,
    isReprint: true,
  );
}

/// "Discount (20% Discount)" -> "20% Discount", so the receipt prints
/// "DISCOUNT (20% Discount)" rather than repeating the word twice.
String _discountLabel(String lineName) {
  final match = RegExp(r'\((.*)\)\s*$').firstMatch(lineName);
  return match != null ? match.group(1)! : lineName;
}
