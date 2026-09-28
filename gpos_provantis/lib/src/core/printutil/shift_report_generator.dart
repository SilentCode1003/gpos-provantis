import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:riverpod/riverpod.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/domain/printer_dto.dart';
import 'package:gpos_provantis/src/core/database/domain/settings_dto.dart';
import 'package:gpos_provantis/src/core/database/providers/printer_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/settings_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/branch_config_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_config_dao_provider.dart';
import 'package:gpos_provantis/src/services/printing/usb_printing.dart';
import 'package:gpos_provantis/src/services/printing/wifi_printing.dart';
import 'package:gpos_provantis/src/services/printing/test_ticket.dart'
    show parsePaperSize;

import 'logo_image.dart';
import 'receipt_generator.dart' show PrinterRole, ReceiptPrintException;

// ---------------------------------------------------------------------------
// Print data
// ---------------------------------------------------------------------------

/// One row in a "sold items" / "sold services" / "sold packages" section.
class ShiftReportLine {
  const ShiftReportLine({
    required this.name,
    required this.quantity,
    required this.total,
  });

  final String name;
  final int quantity;
  final double total;
}

/// A label + amount row, used for the payments summary and staff sales.
class ShiftReportAmountLine {
  const ShiftReportAmountLine({required this.label, required this.total});

  final String label;
  final double total;
}

/// Everything the Z-reading printout needs, with no dependency on where it
/// came from. The end-shift flow, a future "shift report logs" screen, or a
/// manual reprint can all build one of these and hand it to
/// [ShiftReportPrinterService].
///
/// The section lists are optional. An empty list means the section is skipped
/// on the printout, so a header-only report (all we store locally today) still
/// prints correctly.
class ShiftReportPrintData {
  const ShiftReportPrintData({
    required this.date,
    required this.posId,
    required this.shift,
    required this.cashier,
    required this.salesBeginning,
    required this.salesEnding,
    required this.totalSales,
    required this.receiptBeginning,
    required this.receiptEnding,
    this.soldItems = const [],
    this.soldServices = const [],
    this.soldPackages = const [],
    this.paymentSummary = const [],
    this.staffSales = const [],
    this.isReprint = false,
  });

  /// Maps a locally stored report row. This is the single mapping point, so
  /// any screen that has an [EndShiftTableData] can print via
  /// `ShiftReportPrintData.fromTable(row, isReprint: true)`.
  factory ShiftReportPrintData.fromTable(
    EndShiftTableData row, {
    List<ShiftReportLine> soldItems = const [],
    List<ShiftReportLine> soldServices = const [],
    List<ShiftReportLine> soldPackages = const [],
    List<ShiftReportAmountLine> paymentSummary = const [],
    List<ShiftReportAmountLine> staffSales = const [],
    bool isReprint = false,
  }) {
    return ShiftReportPrintData(
      date: row.date,
      posId: row.pos,
      shift: row.shift,
      cashier: row.cashier,
      salesBeginning: row.salesBeginning,
      salesEnding: row.salesEnding,
      totalSales: row.totalSales,
      receiptBeginning: row.receiptBeginning,
      receiptEnding: row.receiptEnding,
      soldItems: soldItems,
      soldServices: soldServices,
      soldPackages: soldPackages,
      paymentSummary: paymentSummary,
      staffSales: staffSales,
      isReprint: isReprint,
    );
  }

  final String date;
  final int posId;
  final int shift;
  final String cashier;
  final double salesBeginning;
  final double salesEnding;
  final double totalSales;
  final int receiptBeginning;
  final int receiptEnding;

  final List<ShiftReportLine> soldItems;
  final List<ShiftReportLine> soldServices;
  final List<ShiftReportLine> soldPackages;
  final List<ShiftReportAmountLine> paymentSummary;
  final List<ShiftReportAmountLine> staffSales;

  /// Prints a **REPRINT** banner at the top when true.
  final bool isReprint;
}

// ---------------------------------------------------------------------------
// Printer service
// ---------------------------------------------------------------------------

/// Builds and sends the Z-reading printout.
///
/// Mirrors [ReceiptGenerator]: printer resolution, byte building and
/// transport are kept in one place, and the input is a plain data class.
class ShiftReportPrinterService {
  ShiftReportPrinterService(this.ref);

  final Ref ref;

  final _wifiPrinterService = WifiPrinterService();
  final _usbPrinterService = UsbPrinterService();

  String _formatCurrency(double value) =>
      toCurrencyString(value.toString(), mantissaLength: 2);

  Future<void> printShiftReport(
    ShiftReportPrintData report, {
    PrinterRole role = PrinterRole.main,
  }) async {
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
        'Printers before printing a shift report.',
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
        'Reassign it from Settings > Printers before printing a '
        'shift report.',
      );
    }
    final printer = PrinterDto.fromTableData(printerRow);

    final branch = await ref.read(branchConfigDaoProvider).getBranch();
    final posConfig = await ref.read(posConfigDaoProvider).getPos();

    final paperSize = parsePaperSize(printer.paperSize);
    final profile = await CapabilityProfile.load();

    final logo = await decodeBranchLogo(
      branch?.logo ?? '',
      maxWidthPx: 250,
      maxHeightPx: 250,
    );

    final bytes = _buildReportBytes(
      report: report,
      settings: settings,
      paper: paperSize,
      profile: profile,
      serialNumber: posConfig?.serial ?? '',
      branchName: branch?.branchName ?? 'UNREGISTERED',
      branchAddress: branch?.address ?? '',
      logo: logo,
    );

    await _sendToPrinter(printer, bytes);
  }

  List<int> _buildReportBytes({
    required ShiftReportPrintData report,
    required SettingsDto settings,
    required PaperSize paper,
    required CapabilityProfile profile,
    required String serialNumber,
    required String branchName,
    required String branchAddress,
    required img.Image? logo,
  }) {
    final ticket = Generator(paper, profile, spaceBetweenRows: 2);
    final wide = paper == PaperSize.mm80;
    List<int> bytes = [];

    if (logo != null) {
      bytes += ticket.image(logo);
    }

    if (report.isReprint) {
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

    // --- Header ---------------------------------------------------------
    bytes += ticket.text(
      branchName,
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
      linesAfter: 1,
    );
    bytes += ticket.text(
      branchAddress,
      styles: const PosStyles(align: PosAlign.center),
    );
    if (settings.birAccredited) {
      bytes += ticket.text(
        'VAT REG TIN: ${settings.vatReg}',
        styles: const PosStyles(align: PosAlign.center),
      );
    }

    bytes += ticket.hr();
    bytes += ticket.text(
      'Z-READING',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    bytes += ticket.feed(1);

    // --- Shift info -----------------------------------------------------
    bytes += _kv(ticket, wide, 'DATE', report.date, 'POSID', '${report.posId}');
    bytes += _kv(
      ticket,
      wide,
      'SHIFT',
      '${report.shift}',
      'CASHIER',
      report.cashier,
    );
    bytes += _kv(ticket, wide, 'SN#', serialNumber, 'BRANCH', branchName);

    bytes += ticket.hr();

    // --- Sales / receipt ranges ----------------------------------------
    bytes += _kv(
      ticket,
      wide,
      'SLS BEG',
      _formatCurrency(report.salesBeginning),
      'RCPT BEG',
      '${report.receiptBeginning}',
    );
    bytes += _kv(
      ticket,
      wide,
      'SLS END',
      _formatCurrency(report.salesEnding),
      'RCPT END',
      '${report.receiptEnding}',
    );

    // --- Optional sections ---------------------------------------------
    bytes += _lineSection(ticket, wide, '--SOLD ITEMS--', report.soldItems);
    bytes += _lineSection(
      ticket,
      wide,
      '--SOLD SERVICES--',
      report.soldServices,
    );
    bytes += _lineSection(
      ticket,
      wide,
      '--SOLD PACKAGES--',
      report.soldPackages,
    );
    bytes += _amountSection(
      ticket,
      wide,
      '--PAYMENTS SUMMARY--',
      report.paymentSummary,
    );
    bytes += _amountSection(ticket, wide, '--STAFF SALES--', report.staffSales);

    // --- Totals ---------------------------------------------------------
    bytes += ticket.hr();
    bytes += ticket.text(
      '--TOTAL SUMMARY--',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    bytes += ticket.hr();
    bytes += _amountRow(
      ticket,
      wide,
      'TOTAL SALES',
      report.totalSales,
      emphasize: true,
    );

    bytes += ticket.feed(2);
    bytes += ticket.cut();

    return bytes;
  }

  /// "DESC / QTY / TOTAL" table (wide) or "name x qty" + amount (narrow).
  /// Returns nothing when [lines] is empty so the section is skipped.
  List<int> _lineSection(
    Generator ticket,
    bool wide,
    String title,
    List<ShiftReportLine> lines,
  ) {
    if (lines.isEmpty) return const [];

    final bytes = <int>[];
    bytes.addAll(ticket.hr());
    bytes.addAll(
      ticket.text(
        title,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
    );

    if (wide) {
      bytes.addAll(
        ticket.row([
          PosColumn(
            text: 'DESC',
            width: 7,
            styles: const PosStyles(bold: true),
          ),
          PosColumn(
            text: 'QTY',
            width: 2,
            styles: const PosStyles(align: PosAlign.center, bold: true),
          ),
          PosColumn(
            text: 'TOTAL',
            width: 3,
            styles: const PosStyles(align: PosAlign.right, bold: true),
          ),
        ]),
      );
      bytes.addAll(ticket.hr());
      for (final line in lines) {
        bytes.addAll(
          ticket.row([
            PosColumn(
              text: line.name,
              width: 7,
              styles: const PosStyles(bold: true),
            ),
            PosColumn(
              text: '${line.quantity}',
              width: 2,
              styles: const PosStyles(align: PosAlign.center, bold: true),
            ),
            PosColumn(
              text: _formatCurrency(line.total),
              width: 3,
              styles: const PosStyles(align: PosAlign.right, bold: true),
            ),
          ]),
        );
      }
    } else {
      bytes.addAll(ticket.hr());
      for (final line in lines) {
        bytes.addAll(
          ticket.row([
            PosColumn(text: '${line.name} x ${line.quantity}', width: 12),
          ]),
        );
        bytes.addAll(
          ticket.row([
            PosColumn(
              text: _formatCurrency(line.total),
              width: 12,
              styles: const PosStyles(align: PosAlign.right),
            ),
          ]),
        );
      }
    }
    return bytes;
  }

  /// Label + amount rows (payments summary, staff sales). Skipped when empty.
  List<int> _amountSection(
    Generator ticket,
    bool wide,
    String title,
    List<ShiftReportAmountLine> lines,
  ) {
    if (lines.isEmpty) return const [];

    final bytes = <int>[];
    bytes.addAll(ticket.hr());
    bytes.addAll(
      ticket.text(
        title,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
    );
    bytes.addAll(ticket.hr());
    for (final line in lines) {
      bytes.addAll(_amountRow(ticket, wide, line.label, line.total));
    }
    return bytes;
  }

  List<int> _kv(
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
          text: '$leftLabel: $leftValue',
          width: 6,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: '$rightLabel: $rightValue',
          width: 6,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]);
    }
    return [
      ...ticket.row([PosColumn(text: '$leftLabel: $leftValue', width: 12)]),
      ...ticket.row([PosColumn(text: '$rightLabel: $rightValue', width: 12)]),
    ];
  }

  List<int> _amountRow(
    Generator ticket,
    bool wide,
    String label,
    double amount, {
    bool emphasize = false,
  }) {
    return ticket.row([
      PosColumn(
        text: label,
        width: 6,
        styles: PosStyles(bold: emphasize || wide),
      ),
      PosColumn(
        text: _formatCurrency(amount),
        width: 6,
        styles: PosStyles(align: PosAlign.right, bold: emphasize || wide),
      ),
    ]);
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

final shiftReportPrinterServiceProvider = Provider<ShiftReportPrinterService>((
  ref,
) {
  return ShiftReportPrinterService(ref);
});
