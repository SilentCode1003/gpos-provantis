import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod/riverpod.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/domain/printer_dto.dart';
import 'package:gpos_provantis/src/core/database/domain/settings_dto.dart';
import 'package:gpos_provantis/src/core/database/providers/printer_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/settings_dao_provider.dart';
import 'package:gpos_provantis/src/core/printutil/receipt_generator.dart'
    show
        PrinterRole,
        ReceiptLineItem,
        ReceiptPrintException,
        ReceiptSaleData,
        receiptGeneratorProvider;
import 'package:gpos_provantis/src/services/printing/test_ticket.dart'
    show parsePaperSize;
import 'package:gpos_provantis/src/shared/widgets/toast_emitter.dart';

/// Everything an order slip needs. Built from the same [ReceiptSaleData] the
/// receipt uses, so the controller doesn't have to collect anything new.
class OrderSlipData {
  const OrderSlipData({
    required this.detailId,
    required this.dateTime,
    required this.items,
  });

  factory OrderSlipData.fromSale(ReceiptSaleData sale) => OrderSlipData(
    detailId: sale.detailId,
    dateTime: sale.dateTime,
    items: sale.items,
  );

  /// The receipt (OR) number of the sale this slip belongs to.
  final String detailId;
  final DateTime dateTime;

  /// Cart lines only. The discount is never a line here, so nothing needs
  /// filtering out.
  final List<ReceiptLineItem> items;

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

/// A slip waiting for the cashier's yes / no ([OrderSlipMode.ask]).
class OrderSlipPromptRequest {
  const OrderSlipPromptRequest({required this.data, required this.printerName});

  final OrderSlipData data;

  /// Name of the sub printer the slip will go to, shown in the prompt.
  final String printerName;
}

/// Slips waiting for an answer. The sale flow adds to it; the
/// OrderSlipPromptHost widget (order_slip_prompt.dart) shows them one at a
/// time. A queue, not a single value, so a slip is never lost if a second sale
/// finishes while the first prompt is still open.
class OrderSlipPromptQueue extends Notifier<List<OrderSlipPromptRequest>> {
  @override
  List<OrderSlipPromptRequest> build() => const [];

  void add(OrderSlipPromptRequest request) {
    state = [...state, request];
  }

  void resolve(OrderSlipPromptRequest request) {
    state = state.where((r) => !identical(r, request)).toList();
  }
}

final orderSlipPromptQueueProvider =
    NotifierProvider<OrderSlipPromptQueue, List<OrderSlipPromptRequest>>(
      OrderSlipPromptQueue.new,
    );

class OrderSlipGenerator {
  OrderSlipGenerator(this.ref);

  final Ref ref;

  /// Call once a sale is saved. Does what the Order Slip setting says:
  ///
  /// * [OrderSlipMode.off]  - nothing.
  /// * [OrderSlipMode.auto] - prints on the sub printer right away.
  /// * [OrderSlipMode.ask]  - queues a prompt; the slip only prints if the
  ///   cashier says yes. This returns immediately and does NOT wait for the
  ///   answer, so the sale flow is never held up by the dialog.
  ///
  /// Never throws. The sale is already saved, so a slip problem is reported
  /// as a warning toast instead of looking like a failed payment.
  Future<void> handleAfterSale(OrderSlipData data) async {
    try {
      final mode = await _readMode();
      switch (mode) {
        case OrderSlipMode.off:
          return;
        case OrderSlipMode.auto:
          await printSlip(data);
        case OrderSlipMode.ask:
          // Check the sub printer BEFORE asking, so the cashier is never
          // offered a slip that can't be printed.
          final printer = await _resolveSubPrinter();
          ref
              .read(orderSlipPromptQueueProvider.notifier)
              .add(
                OrderSlipPromptRequest(data: data, printerName: printer.name),
              );
      }
    } catch (e, st) {
      _announceFailure(data, e, st);
    }
  }

  /// Prints the slip on the sub printer. Throws if the sub printer is not
  /// assigned, no longer exists, or the print fails.
  Future<void> printSlip(OrderSlipData data) async {
    final printer = await _resolveSubPrinter();

    // Needs the asset bundle, so it is loaded here on the main isolate.
    final profile = await CapabilityProfile.load();

    // Text only, so unlike the receipt (logo) this is cheap enough to build
    // on the main isolate.
    final bytes = buildSlipBytes(
      data: data,
      paper: parsePaperSize(printer.paperSize),
      profile: profile,
    );

    await ref.read(receiptGeneratorProvider).sendToPrinter(printer, bytes);
  }

  /// Used when the cashier taps Print in the prompt: prints, then reports how
  /// it went. Never throws.
  Future<void> printConfirmed(OrderSlipData data) async {
    try {
      await printSlip(data);
      ref.read(toastEmitterProvider).success('Order slip printed.');
    } catch (e, st) {
      _announceFailure(data, e, st);
    }
  }

  Future<OrderSlipMode> _readMode() async {
    final rows = await ref.read(settingsDaoProvider).getSettings();
    if (rows.isEmpty) return OrderSlipMode.off;
    return OrderSlipMode.fromName(rows.first.subPrinterOrderSlipMode);
  }

  /// Finds the printer assigned as the SUB printer (never the main one).
  Future<PrinterDto> _resolveSubPrinter() async {
    const role = PrinterRole.sub;

    final settingsRows = await ref.read(settingsDaoProvider).getSettings();
    final settings = settingsRows.isNotEmpty
        ? SettingsDto.fromTableData(settingsRows.first)
        : SettingsDto.defaults();

    final assignedId = settings.subPrinter;
    if (assignedId == 'UNREGISTERED' || assignedId.isEmpty) {
      throw OrderSlipPrintException(
        'No ${role.label} is assigned. Assign one from Settings > '
        'Printers to print order slips.',
      );
    }

    final printerRows = await ref.read(printerDaoProvider).getAllPrinters();
    PrintersTableData? printerRow;
    for (final row in printerRows) {
      if (row.id == assignedId) {
        printerRow = row;
        break;
      }
    }
    if (printerRow == null) {
      throw OrderSlipPrintException(
        'The ${role.label} assigned in Settings no longer exists. '
        'Reassign it from Settings > Printers.',
      );
    }

    return PrinterDto.fromTableData(printerRow);
  }

  void _announceFailure(OrderSlipData data, Object e, StackTrace st) {
    debugPrint('Order slip for sale ${data.detailId} did not print: $e\n$st');
    ref
        .read(toastEmitterProvider)
        .warning(
          'The order slip for sale #${data.detailId} did not print: '
          '${_describeSentence(e)}',
        );
  }

  static String _describeSentence(Object e) {
    final String text;
    if (e is OrderSlipPrintException) {
      text = e.message;
    } else if (e is ReceiptPrintException) {
      text = e.message;
    } else {
      final raw = e.toString().replaceFirst('Exception: ', '').trim();
      text = raw.isEmpty ? 'Unknown error.' : raw;
    }
    return RegExp(r'[.!?]$').hasMatch(text) ? text : '$text.';
  }

  /// Builds the ESC/POS bytes. Static and free of Ref / DAOs, like the
  /// receipt's builder, so it stays easy to test.
  static List<int> buildSlipBytes({
    required OrderSlipData data,
    required PaperSize paper,
    required CapabilityProfile profile,
  }) {
    final ticket = Generator(paper, profile, spaceBetweenRows: 2);
    final wide = paper == PaperSize.mm80;
    List<int> bytes = [];

    bytes += ticket.text(
      'ORDER SLIP',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
      linesAfter: 1,
    );
    bytes += ticket.hr();

    // Side by side on 80mm; stacked on 58mm where half a line is too short
    // for "DATE: 2026-11-16 14:05".
    final refText = 'OR REF# ${data.detailId}';
    final dateText = 'DATE: ${_formatDate(data.dateTime)}';
    if (wide) {
      bytes += ticket.row([
        PosColumn(text: refText, width: 6, styles: const PosStyles(bold: true)),
        PosColumn(
          text: dateText,
          width: 6,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]);
    } else {
      bytes += ticket.row([
        PosColumn(
          text: refText,
          width: 12,
          styles: const PosStyles(bold: true),
        ),
      ]);
      bytes += ticket.row([
        PosColumn(
          text: dateText,
          width: 12,
          styles: const PosStyles(bold: true),
        ),
      ]);
    }

    bytes += ticket.hr();
    bytes += ticket.text(
      '--Item List--',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    bytes += ticket.hr();

    bytes += ticket.row([
      PosColumn(
        text: 'DESCRIPTION',
        width: 9,
        styles: const PosStyles(bold: true),
      ),
      PosColumn(
        text: 'QTY',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
    ]);
    bytes += ticket.hr();

    for (final item in data.items) {
      bytes += ticket.row([
        PosColumn(
          text: item.name,
          width: 9,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: '${item.quantity}',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
      ]);
    }

    bytes += ticket.hr();
    bytes += ticket.text(
      '--Total Items ${data.totalItemCount}--',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    bytes += ticket.feed(2);
    bytes += ticket.cut();
    return bytes;
  }

  static String _formatDate(DateTime dateTime) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)} '
        '${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}';
  }
}

class OrderSlipPrintException implements Exception {
  const OrderSlipPrintException(this.message);
  final String message;

  @override
  String toString() => 'OrderSlipPrintException: $message';
}

final orderSlipGeneratorProvider = Provider<OrderSlipGenerator>((ref) {
  return OrderSlipGenerator(ref);
});
