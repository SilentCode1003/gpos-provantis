import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:riverpod/riverpod.dart';

import 'package:gpos_provantis/src/core/database/daos/printer_dao.dart';
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
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'logo_image.dart';

class ReceiptSaleData {
  const ReceiptSaleData({
    required this.detailId,
    required this.posId,
    required this.shift,
    required this.cashier,
    required this.branchId,
    required this.dateTime,
    required this.items,
    required this.subtotal,
    required this.discountLabel,
    required this.discountAmount,
    required this.total,
    required this.paymentType,
    required this.cash,
    required this.ecash,
    required this.referenceId,
    required this.paymentName,
    this.isReprint = false,
  });

  final String detailId;
  final String posId;
  final String shift;
  final String cashier;
  final String branchId;
  final DateTime dateTime;
  final List<ReceiptLineItem> items;
  final double subtotal;

  final String? discountLabel;
  final double discountAmount;
  final double total;

  final String paymentType;

  final double cash;

  final double ecash;

  final String referenceId;

  final String paymentName;

  final bool isReprint;

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get changeDue {
    final tendered = paymentType == 'SPLIT' ? cash + ecash : cash;
    final due = tendered - total;
    return due > 0 ? due : 0;
  }
}

enum PrinterRole {
  main('main printer'),
  sub('sub printer');

  const PrinterRole(this.label);

  final String label;
}

class ReceiptLineItem {
  const ReceiptLineItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  final String name;
  final int quantity;
  final double price;

  double get lineTotal => price * quantity;
}

class ReceiptGenerator {
  ReceiptGenerator(this.ref);

  final Ref ref;

  final _wifiPrinterService = WifiPrinterService();
  final _usbPrinterService = UsbPrinterService();

  String _formatCurrency(double value) => toCurrencyString(value.toString());

  Future<void> printForSale(
    ReceiptSaleData sale, {
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
        'Printers before printing a receipt.',
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
        'receipt.',
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

    final bytes = _buildTicketBytes(
      sale: sale,
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

  List<int> _buildTicketBytes({
    required ReceiptSaleData sale,
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

    if (sale.isReprint) {
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

    bytes += _kv(
      ticket,
      wide,
      'OR',
      sale.detailId,
      'DATE',
      _formatDate(sale.dateTime),
    );

    if (sale.paymentType == 'EPAYMENT' || sale.paymentType == 'SPLIT') {
      bytes += _kv(
        ticket,
        wide,
        'REF#',
        sale.referenceId,
        'TYPE',
        sale.paymentName,
      );
    }

    bytes += wide
        ? ticket.row([
            PosColumn(
              text: 'PAYMENT TYPE: ${sale.paymentType}',
              width: 12,
              styles: const PosStyles(bold: true),
            ),
          ])
        : ticket.row([
            PosColumn(text: 'PAYMENT TYPE: ${sale.paymentType}', width: 12),
          ]);

    bytes += ticket.hr();

    bytes += _kv(
      ticket,
      wide,
      'CASHIER',
      sale.cashier,
      'STAFF',
      sale.cashier,
      leftBold: true,
      reversedRight: true,
    );
    bytes += _kv(
      ticket,
      wide,
      'POS',
      sale.posId,
      'SHIFT',
      sale.shift,
      rightBold: true,
      reversedRight: true,
    );
    bytes += _kv(
      ticket,
      wide,
      'SN#',
      serialNumber,
      'BRANCH',
      sale.branchId,
      reversedRight: true,
    );

    bytes += ticket.hr();

    if (wide) {
      bytes += ticket.row([
        PosColumn(text: 'DESC', width: 6, styles: const PosStyles(bold: true)),
        PosColumn(
          text: 'QTY',
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: 'Amount',
          width: 4,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]);
      for (final item in sale.items) {
        bytes += ticket.row([
          PosColumn(
            text: item.name,
            width: 6,
            styles: const PosStyles(bold: true),
          ),
          PosColumn(
            text: '${item.quantity}',
            styles: const PosStyles(align: PosAlign.center, bold: true),
          ),
          PosColumn(
            text: _formatCurrency(item.lineTotal),
            width: 4,
            styles: const PosStyles(align: PosAlign.right, bold: true),
          ),
        ]);
      }
    } else {
      for (final item in sale.items) {
        bytes += ticket.row([
          PosColumn(text: '${item.name} x ${item.quantity}', width: 12),
        ]);
        bytes += ticket.row([
          PosColumn(
            text: _formatCurrency(item.lineTotal),
            width: 12,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }
    }

    bytes += ticket.hr();
    bytes += ticket.text(
      '--Total Items ${sale.totalItemCount}--',
      styles: PosStyles(align: PosAlign.center, bold: wide),
    );
    bytes += ticket.hr();

    bytes += _amountRow(
      ticket,
      wide,
      'TOTAL AMOUNT',
      sale.total,
      emphasize: true,
    );

    if (sale.discountLabel != null) {
      bytes += _amountRow(
        ticket,
        wide,
        'DISCOUNT (${sale.discountLabel})',
        -sale.discountAmount,
      );
    }

    if (sale.paymentType == 'CASH' || sale.paymentType == 'SPLIT') {
      bytes += _amountRow(ticket, wide, 'CASH', sale.cash);
    }
    if (sale.paymentType == 'EPAYMENT') {
      bytes += _amountRow(ticket, wide, sale.paymentName, sale.cash);
    }
    if (sale.paymentType == 'SPLIT') {
      bytes += _amountRow(ticket, wide, sale.paymentName, sale.ecash);
    }

    bytes += _amountRow(ticket, wide, 'CHANGE', sale.changeDue);

    if (settings.showVatOnReceipt) {
      final vatable = double.parse((sale.total / 1.12).toStringAsFixed(2));
      final vatAmount = sale.total - vatable;
      bytes += _amountRow(ticket, wide, 'Vatable', vatable);
      bytes += _amountRow(ticket, wide, 'VAT Amount', vatAmount);
      bytes += _amountRow(ticket, wide, 'VAT Exempt', 0);
      bytes += _amountRow(ticket, wide, 'Zero Rated', 0);

      bytes += ticket.hr();
      bytes += ticket.text(
        'Customer Name: ____________________________',
        styles: PosStyles(bold: wide),
      );
      bytes += ticket.text(
        'Customer Address: _________________________',
        styles: PosStyles(bold: wide),
      );
      bytes += ticket.text(
        'Customer TIN:  ____________________________',
        styles: PosStyles(bold: wide),
      );
      bytes += ticket.text(
        'Business Type: ____________________________',
        styles: PosStyles(bold: wide),
      );
    }

    if (settings.birAccredited) {
      bytes += ticket.hr();
      bytes += ticket.text(
        settings.companyName,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      );
      bytes += ticket.text(
        settings.address,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      );
      bytes += ticket.text(
        'VAT REG: ${settings.vatReg}',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      );
      bytes += ticket.text(
        'ACCREDITATION NO: ${settings.accreditationNo}',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      );
      bytes += ticket.text(
        'VALID UNTIL: ${settings.validUntil}',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      );
      bytes += ticket.text(
        'PTU: ${settings.permitToUse}',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      );
    }

    if (settings.showOfficialReceiptMessageAtTheBottom) {
      bytes += ticket.feed(1);
      bytes += ticket.text(
        '---THIS IS AN OFFICIAL RECEIPT---',
        styles: const PosStyles(align: PosAlign.center),
      );
    } else {
      bytes += ticket.feed(1);
      bytes += ticket.text(
        'Thank you! Come again!',
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += ticket.text(
        '***NOT AN OFFICIAL RECEIPT***',
        styles: const PosStyles(align: PosAlign.center),
      );
    }

    bytes += ticket.feed(2);
    bytes += ticket.cut();

    return bytes;
  }

  List<int> _kv(
    Generator ticket,
    bool wide,
    String leftLabel,
    String leftValue,
    String rightLabel,
    String rightValue, {
    bool leftBold = false,
    bool? rightBold,
    bool reversedRight = false,
  }) {
    final resolvedRightBold = rightBold ?? wide;
    final rightText = reversedRight
        ? '$rightValue:$rightLabel'
        : '$rightLabel: $rightValue';
    if (wide) {
      return ticket.row([
        PosColumn(
          text: '$leftLabel: $leftValue',
          width: 6,
          styles: PosStyles(bold: leftBold),
        ),
        PosColumn(
          text: rightText,
          width: 6,
          styles: PosStyles(align: PosAlign.right, bold: resolvedRightBold),
        ),
      ]);
    }
    return [
      ...ticket.row([
        PosColumn(
          text: '$leftLabel: $leftValue',
          width: 12,
          styles: PosStyles(bold: leftBold),
        ),
      ]),
      ...ticket.row([
        PosColumn(
          text: rightText,
          width: 12,
          styles: PosStyles(bold: resolvedRightBold),
        ),
      ]),
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

  String _formatDate(DateTime dateTime) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)} '
        '${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}';
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

class ReceiptPrintException implements Exception {
  const ReceiptPrintException(this.message);
  final String message;

  @override
  String toString() => 'ReceiptPrintException: $message';
}

final receiptGeneratorProvider = Provider<ReceiptGenerator>((ref) {
  return ReceiptGenerator(ref);
});
