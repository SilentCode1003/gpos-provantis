import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

PaperSize parsePaperSize(String paperSizeMm) => switch (paperSizeMm) {
  '58' => PaperSize.mm58,
  '72' => PaperSize.mm72,
  _ => PaperSize.mm80,
};

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
