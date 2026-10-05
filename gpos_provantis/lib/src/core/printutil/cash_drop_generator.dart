import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:riverpod/riverpod.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/domain/cash_drop_dto.dart';
import 'package:gpos_provantis/src/core/database/domain/printer_dto.dart';
import 'package:gpos_provantis/src/core/database/domain/settings_dto.dart';
import 'package:gpos_provantis/src/core/database/providers/printer_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/settings_dao_provider.dart';
import 'package:gpos_provantis/src/services/printing/usb_printing.dart';
import 'package:gpos_provantis/src/services/printing/wifi_printing.dart';
import 'package:gpos_provantis/src/services/printing/test_ticket.dart'
    show parsePaperSize;
import 'receipt_generator.dart' show PrinterRole, ReceiptPrintException;

/// One denomination row on the slip.
class CashDropSlipLine {
  const CashDropSlipLine({
    required this.label,
    required this.quantity,
    required this.value,
  });

  final String label;
  final int quantity;
  final int value;

  double get lineTotal => (quantity * value).toDouble();
}

/// Everything the cash drop slip prints.
class CashDropSlipData {
  const CashDropSlipData({
    required this.cashier,
    required this.branchId,
    required this.posId,
    required this.shift,
    required this.shiftDate,
    required this.lines,
    required this.total,
    this.isReprint = false,
  });

  /// Builds the slip from a saved cash drop. Only denominations that were
  /// actually dropped are printed.
  factory CashDropSlipData.fromTable(
    CashDropTableData row, {
    bool isReprint = false,
  }) {
    final lines = CashDropDto.decodeLines(row.linesJson);
    return CashDropSlipData(
      cashier: row.cashierName,
      branchId: row.branchId,
      posId: row.posId,
      shift: row.shift,
      shiftDate: row.shiftDate,
      lines: [
        for (final l in lines)
          if (l.quantity > 0)
            CashDropSlipLine(
              label: l.label,
              quantity: l.quantity,
              value: l.value,
            ),
      ],
      total: row.amount,
      isReprint: isReprint,
    );
  }

  final String cashier;
  final String branchId;
  final String posId;
  final String shift;

  /// `yyyy-MM-dd`.
  final String shiftDate;
  final List<CashDropSlipLine> lines;
  final double total;
  final bool isReprint;
}

class CashDropGenerator {
  CashDropGenerator(this.ref);

  final Ref ref;

  final _wifiPrinterService = WifiPrinterService();
  final _usbPrinterService = UsbPrinterService();

  String _formatCurrency(double value) => toCurrencyString(value.toString());

  /// Prints the slip on the assigned [role] printer (the main printer by
  /// default). Throws [ReceiptPrintException] with a message fit to show the
  /// cashier if there is no usable printer or the print fails.
  Future<void> printCashDrop(
    CashDropSlipData slip, {
    PrinterRole role = PrinterRole.main,
  }) async {
    final printer = await _resolvePrinter(role);
    final paper = parsePaperSize(printer.paperSize);
    final profile = await CapabilityProfile.load();

    final bytes = _buildSlipBytes(slip: slip, paper: paper, profile: profile);

    await _sendToPrinter(printer, bytes);
  }

  Future<PrinterDto> _resolvePrinter(PrinterRole role) async {
    final settingsRows = await ref.read(settingsDaoProvider).getSettings();
    final settings = settingsRows.isNotEmpty
        ? SettingsDto.fromTableData(settingsRows.first)
        : SettingsDto.defaults();

    final assignedId = role == PrinterRole.main
        ? settings.mainPrinter
        : settings.subPrinter;

    if (assignedId == 'UNREGISTERED' || assignedId.isEmpty) {
      throw ReceiptPrintException(
        'No ${role.label} is assigned. Assign one from Settings > '
        'Printers before printing a cash drop slip.',
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
      throw ReceiptPrintException(
        'The ${role.label} assigned in Settings no longer exists. '
        'Reassign it from Settings > Printers before printing.',
      );
    }

    final printer = PrinterDto.fromTableData(printerRow);
    if (!printer.isEnabled) {
      throw ReceiptPrintException(
        'The ${role.label} "${printer.name}" is switched off. Enable it from '
        'Settings > Printers to print the cash drop slip.',
      );
    }
    return printer;
  }

  /// Same layout as the old app's CASH DROP SLIP.
  List<int> _buildSlipBytes({
    required CashDropSlipData slip,
    required PaperSize paper,
    required CapabilityProfile profile,
  }) {
    final ticket = Generator(paper, profile);
    final wide = paper == PaperSize.mm80;
    List<int> bytes = [];

    if (slip.isReprint) {
      bytes += ticket.text(
        '**REPRINT**',
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1,
      );
    }

    bytes += ticket.text(
      'CASH DROP SLIP',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
      linesAfter: 1,
    );

    bytes += ticket.hr();

    bytes += _pair(
      ticket,
      wide,
      'CASHIER',
      slip.cashier,
      'BRANCH',
      slip.branchId,
    );
    bytes += _pair(ticket, wide, 'SHIFT', slip.shift, 'POS ID', slip.posId);

    bytes += ticket.hr();

    bytes += ticket.row([
      PosColumn(
        text: 'DATE: ${slip.shiftDate}',
        width: 12,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
    ]);

    bytes += ticket.hr();

    bytes += ticket.row([
      PosColumn(
        text: 'DESCRIPTION',
        width: 4,
        styles: const PosStyles(align: PosAlign.left, bold: true),
      ),
      PosColumn(
        text: 'QTY',
        width: 4,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
      PosColumn(
        text: 'TOTAL',
        width: 4,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    bytes += ticket.hr();

    for (final line in slip.lines) {
      bytes += ticket.row([
        PosColumn(
          text: line.label,
          width: 4,
          styles: const PosStyles(align: PosAlign.left, bold: true),
        ),
        PosColumn(
          text: '${line.quantity} x ${line.value}',
          width: 4,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: _formatCurrency(line.lineTotal),
          width: 4,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]);
    }

    bytes += ticket.hr();

    bytes += ticket.row([
      PosColumn(
        text: 'TOTAL',
        width: 6,
        styles: const PosStyles(align: PosAlign.left, bold: true),
      ),
      PosColumn(
        text: _formatCurrency(slip.total),
        width: 6,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    bytes += ticket.feed(2);
    bytes += ticket.cut();

    return bytes;
  }

  /// Two label/value pairs on one line, like the old slip (CASHIER | BRANCH).
  /// 58mm paper is too narrow for four columns, so there each pair gets its
  /// own line instead.
  List<int> _pair(
    Generator ticket,
    bool wide,
    String leftLabel,
    String leftValue,
    String rightLabel,
    String rightValue,
  ) {
    if (wide) {
      return ticket.row([
        PosColumn(
          text: '$leftLabel:',
          width: 3,
          styles: const PosStyles(align: PosAlign.left, bold: true),
        ),
        PosColumn(
          text: leftValue,
          width: 3,
          styles: const PosStyles(align: PosAlign.left, bold: true),
        ),
        PosColumn(
          text: '$rightLabel:',
          width: 3,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
        PosColumn(
          text: rightValue,
          width: 3,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]);
    }
    return [
      ...ticket.row([
        PosColumn(
          text: '$leftLabel: $leftValue',
          width: 12,
          styles: const PosStyles(bold: true),
        ),
      ]),
      ...ticket.row([
        PosColumn(
          text: '$rightLabel: $rightValue',
          width: 12,
          styles: const PosStyles(bold: true),
        ),
      ]),
    ];
  }

  Future<void> _sendToPrinter(PrinterDto printer, List<int> bytes) async {
    switch (printer.connectionType) {
      case 'WIFI':
        try {
          await _wifiPrinterService.printData(bytes, printer: printer);
        } catch (e) {
          throw ReceiptPrintException(
            'Could not print to "${printer.name}" at ${printer.address}: $e',
          );
        }
        break;

      case 'USB':
        final device = await _usbPrinterService.getSavedUsbPrinter(
          printer.address,
        );
        if (device == null) {
          throw ReceiptPrintException(
            'Could not find "${printer.name}" on USB — check it is '
            'plugged in and powered on.',
          );
        }
        try {
          await _usbPrinterService.printDirect(bytes, printerDevice: device);
        } catch (e) {
          throw ReceiptPrintException(
            'Printing to "${printer.name}" failed: $e',
          );
        }
        break;

      default:
        throw ReceiptPrintException(
          'Printer "${printer.name}" uses connection type '
          '"${printer.connectionType}", which isn\'t supported yet.',
        );
    }
  }
}

final cashDropGeneratorProvider = Provider<CashDropGenerator>((ref) {
  return CashDropGenerator(ref);
});
