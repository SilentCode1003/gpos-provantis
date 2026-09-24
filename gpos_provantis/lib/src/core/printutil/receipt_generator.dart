// Location: src/features/dashboard/controllers/receipt_generator.dart
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

/// =========================================================================
/// RECEIPT GENERATOR — new-app (Riverpod/Drift) replacement for the old
/// `Receipt` class (see `receipt.dart`, kept only as a reference during
/// the port). Builds one ESC/POS ticket and sends it to whichever
/// printer is configured, using `esc_pos_utils_plus` to build the
/// ticket bytes and `flutter_thermal_printer` to send them (originally
/// `flutter_esc_pos_network`, WIFI/network-only — see PRINTER
/// TRANSPORT below for why it changed).
///
/// ISOLATION — READ THIS BEFORE CHANGING THE SIGNATURE OF ANYTHING HERE:
/// This file deliberately knows nothing about `DashboardController` or
/// any other screen. Its only inputs are `ReceiptSaleData` (plain data)
/// plus whatever it reads itself from `PrinterDao`/`SettingsDao`/the
/// identity DAOs. That's on purpose: a `ReceiptSaleData` is built by
/// the caller (checkout uses `_receiptDataFromCheckout` in
/// dashboard_controller.dart) and handed to this generator, which only
/// prints it — it never reaches back into a screen or the database to
/// build its own input. A future reprint screen/controller should do
/// the same: build its own `ReceiptSaleData` from whatever it reads
/// back out of storage, and hand it to `ReceiptGenerator.printForSale`
/// the same way checkout does. That translation belongs in the
/// reprint screen, not here.
/// If this file ever imports `dashboard_controller.dart` (or any other
/// screen/controller), that breaks this isolation — don't.
///
/// WHAT CHANGED FROM THE OLD VERSION, AND WHY:
///  - Old: static config read from loose JSON files on disk
///    (`pos.json`, `branch.json`, `printer.json`, `posconfig.json`, ...).
///    New: the same information now lives in Drift, behind
///    `SettingsDao`/`PrinterDao` (this feature). Sale identity
///    (posId/shift/cashier/branch/detailId) is no longer re-resolved
///    here at all — by the time a `ReceiptSaleData` exists, those are
///    already just plain fields on it, set by whoever built it.
///  - Old: one `Receipt` held both the ticket-building logic AND the
///    transport (network / bluetooth / "mobile" ESC-POS / a PDF
///    fallback) in a single `printReceipt()` god-method. New: this file
///    only builds bytes (`_buildTicketBytes`) and sends them to ONE
///    network printer (see PRINTER TRANSPORT below); nothing else is
///    wired up yet.
///  - Old: cart items were passed as `List<Map<String, dynamic>>` with
///    magic string keys. New: cart items arrive already as typed
///    `ReceiptLineItem`s on `ReceiptSaleData` — no JSON decoding
///    happens in this file at all; that's the caller's job.
///  - Old: the printer's paper size, cash-drawer flag, and connection
///    were one hardcoded `printer.json`. New: `PrinterDao` can hold
///    several named printers (see `printer_dto.dart`) — this class
///    always prints to whichever one `PrinterDto.name` matches, so a
///    "main" and "kitchen" printer, or a receipt/kitchen split, can be
///    added later without changing this file's shape. Right now the
///    dashboard only wires up printing the main receipt printer — see
///    `ReceiptGenerator.printForSale`.
///
/// PRINTER TRANSPORT (see PrinterDto.connectionType):
///   All three below go through `flutter_thermal_printer`, which
///   replaced `flutter_esc_pos_network` (WIFI/network-only, called
///   `'NETWORK'` there) so one package now covers all connection types
///   instead of three separate ones. Values match `PrintersTable`'s
///   default and what `printers_panel.dart` already uses:
///   'WIFI'      — `FlutterThermalPrinterNetwork` (WiFi/Ethernet).
///   'USB'       — discovered via `getPrinters(connectionTypes: [...])`
///                 and matched against `PrinterDto.address`.
///   'BLUETOOTH' — same discovery path, BLE.
///   See `_sendToPrinter`'s doc comment for the caveat on how
///   `PrinterDto.address` is being reused across all three types.
///   There's still no PDF fallback (the old `printReceipt()`'s
///   `pw.Document` branch) for when no printer is configured at all —
///   left as a TODO, since it has no equivalent in the new printer
///   config shape yet.
///
/// NOT YET PORTED FROM THE OLD RECEIPT:
///   - The promo footer (`Receipt.promo()`, a live API call). Nothing
///     in the new schema models a promo yet either.
///   - Cash-drawer kick (`ticket.drawer()`), gated in the old file by
///     `printerconfig['iscashdrawer']` — `PrinterDto` has no such flag;
///     add one there first if a physical drawer needs wiring back up.
///   - MIN (`min`) is part of the old accreditation block; the new
///     `SettingsDto` doesn't carry it — that line is dropped, not
///     guessed at.
/// =========================================================================

/// Everything about ONE sale that the ticket layout needs — nothing
/// more. This is the generator's entire public input surface: build one
/// of these from live checkout state (see `_receiptDataFromCheckout` in
/// dashboard_controller.dart) and hand it to
/// `ReceiptGenerator.printForSale`. Deliberately plain data with no
/// reference to `DashboardState` or anything else screen-shaped, so
/// the generator itself never has to import it.
///
/// Reprinting an old sale is a separate concern and belongs in its own
/// screen/controller — that code is responsible for reading the saved
/// row (however it's stored) and building a `ReceiptSaleData` from it,
/// the same way `_receiptDataFromCheckout` does for a live checkout.
/// This file deliberately has no factory for that and no DB/table
/// import, so it stays usable from anywhere without pulling in
/// database-shaped types.
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

  /// e.g. `"Senior Citizen (20%)"`. Null when no discount was applied.
  final String? discountLabel;
  final double discountAmount;
  final double total;

  /// One of `'CASH'`, `'EPAYMENT'`, `'SPLIT'` — matches
  /// `SalesTable.paymentType` exactly (see dashboard_controller.dart).
  final String paymentType;

  /// Cash portion of the tender. Full total for CASH, 0 for EPAYMENT,
  /// the cash slot's amount for SPLIT.
  final double cash;

  /// E-payment portion of the tender. 0 for CASH, full total for
  /// EPAYMENT, the e-payment slot's amount for SPLIT.
  final double ecash;

  /// Reference number for the e-payment leg. Blank for a pure-CASH
  /// sale.
  final String referenceId;

  /// Display name of the e-payment method (e.g. `'GCash'`). Blank for
  /// a pure-CASH sale.
  final String paymentName;

  /// True when this ticket is being printed again for an already-saved
  /// sale, rather than at the moment of the original checkout. Purely a
  /// print-layout flag — it never affects `SalesTable`, the sale's
  /// `isSync` state, or anything else about the underlying sale record;
  /// it only tells `_buildTicketBytes` to add the REPRINT marker so the
  /// customer/cashier can tell this ticket apart from the original.
  final bool isReprint;

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get changeDue {
    final tendered = paymentType == 'SPLIT' ? cash + ecash : cash;
    final due = tendered - total;
    return due > 0 ? due : 0;
  }
}

/// The two jobs a saved printer can be assigned to in Settings (see
/// `SettingsDto.mainPrinter`/`.subPrinter`) — mirrors the private
/// `_PrinterRole` in `printers_panel.dart`, exposed here since this
/// file needs to resolve the same assignment from outside that panel.
enum PrinterRole {
  main('main printer'),
  sub('sub printer');

  const PrinterRole(this.label);

  final String label;
}

/// One printed line item.
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

/// Builds and prints the receipt for one sale, given a `ReceiptSaleData`
/// — this class doesn't know or care whether that data came from a
/// fresh checkout or was reconstructed later for a reprint. See the
/// file-level ISOLATION note above for why that matters.
///
/// USAGE (see dashboard_controller.dart's `_receiptDataFromCheckout`
/// for how `ReceiptSaleData` gets built there):
/// ```dart
/// await ref.read(receiptGeneratorProvider).printForSale(saleData);
/// ```
/// A reprint screen/controller would build its own `ReceiptSaleData`
/// from whatever it reads back out of storage and call this the same
/// way — that translation isn't this file's job.
///
/// Callers should wrap this in a print-failure-must-never-undo-anything
/// guard: for checkout, the sale is already committed by the time
/// printing runs, so a printer that's offline, misconfigured, or just
/// slow should show up as a snackbar, never as a rolled-back or
/// duplicated sale. See `ReceiptPrintException`.
class ReceiptGenerator {
  ReceiptGenerator(this.ref);

  final Ref ref;

  /// Same services `printers_panel.dart` uses for "Test print" — see
  /// `_sendToPrinter` below.
  final _wifiPrinterService = WifiPrinterService();
  final _usbPrinterService = UsbPrinterService();

  /// Formats a peso value the same way the old `Receipt` class did —
  /// no leading currency symbol, comma-grouped, two decimals.
  String _formatCurrency(double value) => toCurrencyString(value.toString());

  /// Builds the ticket and sends it to the printer assigned as
  /// `SettingsDto.mainPrinter` (pass `role: PrinterRole.sub` for the
  /// sub printer instead) — the same "assigned by saved uuid" model
  /// `printers_panel.dart` uses to resolve Main/Sub in Settings (see
  /// its `_printerById`). Looks that printer up via `PrinterDao` and
  /// the shared receipt settings via `SettingsDao`, both already
  /// synced/edited from the Settings screen.
  ///
  /// Throws [ReceiptPrintException] if no printer is assigned to that
  /// role, the assigned uuid no longer matches any saved printer, or
  /// the configured connection type isn't supported yet (see
  /// `_sendToPrinter`). Callers should catch this and surface it (e.g.
  /// a snackbar) rather than letting it propagate — printing is
  /// best-effort once the sale itself is already saved.
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

    // See `parsePaperSize`'s doc comment (test_ticket.dart) — this must
    // stay in sync with what "Test print" uses, or the two can silently
    // print at different widths for the same saved printer.
    final paperSize = parsePaperSize(printer.paperSize);
    final profile = await CapabilityProfile.load();

    // Decoded/rasterized here (before `_buildTicketBytes`, which stays
    // synchronous) since `decodeBranchLogo` is async — see
    // `logo_image.dart` for why SVG rasterization needs to await
    // `dart:ui`. Fixed 50x50px box regardless of paper size: a small,
    // consistent logo rather than one that scales with paper width (the
    // 70%-of-paper-width sizing this replaced could run quite large on
    // 80mm paper). `decodeBranchLogo` fits the logo inside this box
    // without stretching it, so a non-square logo comes out smaller than
    // 50px on whichever axis its aspect ratio implies.
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

  /// Draws the full ticket and returns the raw ESC/POS bytes — this is
  /// a straight, mechanical port of the old `Receipt
  /// .transactionReceipt`'s `mm80`/`mm58` branches (see receipt.dart),
  /// minus the promo footer (see the file-level doc comment above for
  /// why — the logo itself is now ported; see `_buildTicketBytes`'s
  /// [logo] and `printForSale`'s call to `decodeBranchLogo`, which is
  /// where it's decoded before this method runs). Kept as one method
  /// rather than split per-paper-size like the old file, since the two
  /// branches only ever differed in column widths, not content — a
  /// shared builder with a `paper` check per row is less to keep in
  /// sync than two near-duplicate 300-line methods.
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

    // `logo` is already `null` (see `decodeBranchLogo`) for every
    // failure case — empty/missing field, bad base64, corrupt/truncated
    // image, unparseable SVG — so this only ever prints when there's a
    // real, decoded image to show, exactly like `top_bar.dart`'s
    // fallback-to-icon behavior on-screen.
    if (logo != null) {
      bytes += ticket.image(logo);
    }

    // Sits below the logo and above the branch name, so it's the first
    // thing read on the ticket after the logo either way (logo present
    // or not) — the customer shouldn't have to reach the footer to find
    // out this isn't the original ticket.
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

    // -- Transaction info ---------------------------------------------
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

    // CASHIER/POS/SN# on the left, STAFF/SHIFT/BRANCH on the right.
    // STAFF has no field of its own yet, so it mirrors CASHIER for now.
    // CASHIER and SHIFT are explicitly bold; the other four are plain.
    // The right column (STAFF/SHIFT/BRANCH) reads value-first —
    // `reversedRight` prints e.g. `1:SHIFT` instead of `SHIFT: 1` — the
    // left column keeps the normal `LABEL: value` order.
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

    // -- Items -----------------------------------------------------
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

    // -- Summary -----------------------------------------------------
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

  /// One two-column key/value row (wide paper) or two stacked
  /// full-width rows (narrow paper) — the pattern every info row in the
  /// old ticket used (`OR:`/`DATE:`, `CASHIER:`/`STAFF:`, ...).
  ///
  /// On wide paper the right side is bold by default (matching the old
  /// ticket) and the left side plain; pass [leftBold]/[rightBold] to
  /// override either side individually — e.g. CASHIER and SHIFT are
  /// forced bold regardless of which column they end up in. On narrow
  /// paper both stacked rows default to plain, matching the old ticket
  /// (which had no bold in `_kv` at all pre-split); an explicit
  /// [leftBold]/[rightBold] still applies to its row on narrow paper too,
  /// so CASHIER/SHIFT stay bold there as well.
  ///
  /// [reversedRight], when true, prints the right column as
  /// `value:label` (e.g. `1:SHIFT`) instead of the normal `label: value`
  /// — used for STAFF/SHIFT/BRANCH, which sit in the right column and
  /// are read value-first rather than label-first. The left column is
  /// never affected by this flag. On narrow paper the right value's row
  /// still stacks under the left row same as always; only the text
  /// within that row's own column changes shape.
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

  /// One label/amount row in the summary block (`TOTAL AMOUNT`, `CASH`,
  /// `CHANGE`, VAT breakdown, ...) — same layout on both paper sizes,
  /// since the old file's `mm58` summary block used the same 6/6 split
  /// as `mm80` despite the rest of that branch being full-width.
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

  /// Sends [bytes] to [printer] via `flutter_thermal_printer`, which
  /// replaced `flutter_esc_pos_network` here so WIFI, USB and
  /// BLUETOOTH are all handled by one package instead of three.
  /// `printer.connectionType` is one of `'WIFI'`, `'USB'`,
  /// `'BLUETOOTH'` — matches `PrintersTable`'s default and the values
  /// `printers_panel.dart` already uses (see its `_connectionTypeIcon`).
  ///
  /// NOTE ON `printer.address`: `PrinterDto` (as seen by this file) only
  /// exposes one address-like string field. This code reuses that same
  /// Sends [bytes] to [printer] by delegating to the same
  /// `WifiPrinterService`/`UsbPrinterService` the Settings > Printers
  /// panel's "Test print" already uses (see `printers_panel.dart`'s
  /// `_testPrinter`) — this file no longer talks to
  /// `flutter_thermal_printer` directly, so WIFI/USB behavior here is
  /// guaranteed to match what "Test print" already does, rather than a
  /// second, possibly-diverging implementation.
  /// `printer.connectionType` is one of `'WIFI'`, `'USB'`, `'BLUETOOTH'`
  /// — matches `PrintersTable`'s default and the values
  /// `printers_panel.dart` already uses (see its `_connectionTypeIcon`).
  /// BLUETOOTH has no service yet (see `_testPrinter`'s own doc
  /// comment) — same "not supported yet" outcome as before.
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

/// Thrown by [ReceiptGenerator] for any printing failure — no printer
/// configured, connection type unsupported, or the print itself
/// failing. Callers (see dashboard_controller.dart's `createSaleFrom*`)
/// should catch this the same way they already catch
/// `PosDetailIdUnavailableException`/`PosIdentityUnavailableException`:
/// surface it, but never let it undo or duplicate the sale that was
/// just saved.
class ReceiptPrintException implements Exception {
  const ReceiptPrintException(this.message);
  final String message;

  @override
  String toString() => 'ReceiptPrintException: $message';
}

/// Riverpod access point — mirrors `printerDaoProvider`/
/// `settingsDaoProvider`'s plain-`Provider` style (see
/// printer_dao_provider.dart / settings_dao_provider.dart) rather than
/// `@riverpod`-generating a new part file, since this provider needs no
/// generated mixin (it isn't watched anywhere, just read once per
/// print).
final receiptGeneratorProvider = Provider<ReceiptGenerator>((ref) {
  return ReceiptGenerator(ref);
});
