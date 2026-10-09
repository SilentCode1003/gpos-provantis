import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod/riverpod.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart'
    show SalesTableData;
import 'package:gpos_provantis/src/core/printutil/receipt_generator.dart'
    show
        ReceiptSaleData,
        ReceiptLineItem,
        ReceiptPrintException,
        receiptGeneratorProvider;
import 'package:gpos_provantis/src/shared/widgets/toast_emitter.dart';

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

class ReprintState {
  const ReprintState({this.printingDetailId});

  /// Receipt number being printed right now, or null when idle. The screen can
  /// use it to show a spinner on that row and disable the other buttons.
  final String? printingDetailId;

  bool get isPrinting => printingDetailId != null;
}

/// Reprints a saved sale and tells the cashier how it went.
///
/// Written as a manual provider (like `soldItemsListProvider`) so it does not
/// need a build_runner pass. It is not auto-dispose, so the result still
/// reaches the cashier if they leave the screen while the receipt prints.
final reprintControllerProvider =
    NotifierProvider<ReprintController, ReprintState>(ReprintController.new);

class ReprintController extends Notifier<ReprintState> {
  @override
  ReprintState build() => const ReprintState();

  /// Prints [row] again, marked as a REPRINT. Never throws: every outcome is
  /// shown as a toast.
  Future<void> reprint(SalesTableData row) async {
    // Everything from `ref` is read before the first await.
    final toast = ref.read(toastEmitterProvider);
    final generator = ref.read(receiptGeneratorProvider);

    // Double-tap guard.
    if (state.isPrinting) {
      toast.warning('Another receipt is still printing. Please wait.');
      return;
    }

    final detailId = row.detailId;
    state = ReprintState(printingDetailId: detailId);

    try {
      await generator.printForSale(receiptSaleDataFromSaleRow(row));
      toast.success('Receipt #$detailId reprinted.');
    } catch (e, st) {
      debugPrint('Reprint: receipt $detailId failed: $e\n$st');
      toast.error('Could not reprint receipt #$detailId. ${_describe(e)}');
    } finally {
      if (ref.mounted) state = const ReprintState();
    }
  }

  String _describe(Object e) {
    if (e is ReceiptPrintException) return e.message;
    return e.toString().replaceFirst('Exception: ', '');
  }
}
