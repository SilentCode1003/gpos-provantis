import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

/// Converts `PrinterDto.paperSize` (the bare width string the printers
/// panel saves — one of `_paperSizes = ['58', '72', '80']` in
/// `printers_panel.dart`, no `mm` prefix) into the `PaperSize` enum
/// `esc_pos_utils_plus` expects.
///
/// Single source of truth for this mapping — both a real print
/// (`receipt_generator.dart`'s `printForSale`) and a test print
/// (`buildTestTicket` below, used by both `usb_printing.dart`'s and
/// `wifi_printing.dart`'s `printTestPage`) must agree on paper width, or
/// "Test print" and an actual sale receipt can silently render at
/// different widths for the same saved printer. Unrecognized/empty
/// values (e.g. a row that predates the form's validation) fall back to
/// mm80, matching `PrintersTable.paperSize`'s column default.
PaperSize parsePaperSize(String paperSizeMm) => switch (paperSizeMm) {
  '58' => PaperSize.mm58,
  '72' => PaperSize.mm72,
  _ => PaperSize.mm80,
};

/// Builds a small ESC/POS "test print" ticket for the given paper width.
///
/// Shared by every transport (USB, WiFi, and eventually Bluetooth) so a
/// test print always looks the same regardless of how the bytes got to
/// the printer — only the transport differs.
Future<List<int>> buildTestTicket({
  required String printerName,
  required String paperSizeMm,
}) async {
  final profile = await CapabilityProfile.load();
  final paperSize = parsePaperSize(paperSizeMm);
  final generator = Generator(paperSize, profile);

  var bytes = <int>[];
  bytes += generator.text(
    'TEST PRINT',
    styles: const PosStyles(
      align: PosAlign.center,
      bold: true,
      height: PosTextSize.size2,
      width: PosTextSize.size2,
    ),
  );
  bytes += generator.hr();
  bytes += generator.text(
    printerName,
    styles: const PosStyles(align: PosAlign.center),
  );
  bytes += generator.text(
    DateTime.now().toString(),
    styles: const PosStyles(align: PosAlign.center),
  );
  bytes += generator.hr();
  bytes += generator.text('If you can read this, the connection works.');
  bytes += generator.feed(2);
  bytes += generator.cut();
  return bytes;
}
