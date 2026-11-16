import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:gpos_provantis/src/core/database/domain/printer_dto.dart';

/// Prints through the printer that is built into a Landi handheld POS.
///
/// Unlike the WiFi / USB / Bluetooth printers, the Landi SDK does not accept
/// raw ESC/POS bytes. It takes plain text (and an optional logo image) and does
/// the layout itself. So this service has no `printData(bytes)`: callers hand
/// it a ready-made text receipt, built with [ReceiptTextLayout].
///
/// The native half lives in `LandiPrinterChannel.kt` (MethodChannel
/// "landi_printer").
class IntegratedPrinterService {
  /// Value stored in `PrintersTable.connectionType` for this printer.
  static const String connectionType = 'INTEGRATED';

  /// Value to store in `PrintersTable.address`. There is nothing to address (the
  /// printer is part of the device), but the column must not be empty.
  static const String defaultAddress = 'BUILT_IN';

  /// Characters per line. The Landi handhelds have a fixed 58 mm print head, so
  /// this deliberately ignores `PrinterDto.paperSize` (a stray 80 mm value
  /// would otherwise make every line wrap on this hardware).
  static const int columns = 32;

  static const MethodChannel _channel = MethodChannel('landi_printer');

  /// The built-in printer only exists on Android devices.
  static bool get isSupported => !kIsWeb && Platform.isAndroid;

  /// True once the Landi service is connected and the printer is ready.
  ///
  /// The Landi driver connects asynchronously after the app starts, and on a
  /// device that isn't a Landi handheld it never connects at all, so this waits
  /// up to [timeout] before giving up.
  Future<bool> isAvailable({
    Duration timeout = const Duration(seconds: 3),
  }) async {
    if (!isSupported) return false;

    final deadline = DateTime.now().add(timeout);
    while (true) {
      try {
        final ready = await _channel.invokeMethod<bool>('isAvailable');
        if (ready == true) return true;
      } on PlatformException catch (e) {
        debugPrint('[INTEGRATED] isAvailable failed: ${e.code} ${e.message}');
        return false;
      } on MissingPluginException {
        debugPrint('[INTEGRATED] Native "landi_printer" channel not found.');
        return false;
      }
      if (DateTime.now().isAfter(deadline)) return false;
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }
  }

  /// Checks the printer can be reached. Throws if it can't (mirrors the WiFi
  /// printer's `ping`).
  Future<void> ping(PrinterDto printer) async {
    await _requireAvailable(printer);
  }

  /// Prints one receipt: the optional [logoPng] first, then [text].
  ///
  /// [text] must already be laid out for [columns] characters per line.
  Future<void> printReceipt({
    required String text,
    Uint8List? logoPng,
    PrinterDto? printer,
  }) async {
    await _requireAvailable(printer);

    debugPrint(
      '[INTEGRATED] Printing ${text.length} chars'
      '${logoPng == null ? '' : ' + ${logoPng.length}-byte logo'}...',
    );

    try {
      await _channel.invokeMethod<void>('printReceipt', {
        'text': text,
        if (logoPng != null) 'logo': logoPng,
      });
      debugPrint('[INTEGRATED] Print job finished.');
    } on PlatformException catch (e) {
      debugPrint('[INTEGRATED] Print failed: ${e.code} ${e.message}');
      throw Exception(_describe(e));
    }
  }

  Future<void> printTestPage(PrinterDto printer) async {
    final layout = const ReceiptTextLayout(columns);
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');

    final lines = <String>[
      ...layout.center('PRINTER TEST'),
      layout.hr('='),
      ...layout.wrap('Printer: ${printer.name}'),
      'Type: Built-in (Landi)',
      'Width: $columns characters',
      'Date: ${now.year}-${two(now.month)}-${two(now.day)} '
          '${two(now.hour)}:${two(now.minute)}',
      layout.hr(),
      // A ruler: if this wraps or gets cut off, the width is wrong.
      '12345678901234567890123456789012',
      layout.hr(),
      ...layout.center('If you can read this,'),
      ...layout.center('printing works.'),
    ];

    // Trailing blank lines push the page past the tear bar.
    await printReceipt(text: '${lines.join('\n')}\n\n\n\n', printer: printer);
  }

  Future<void> _requireAvailable(PrinterDto? printer) async {
    final name = printer == null ? 'The built-in printer' : '"${printer.name}"';

    if (!isSupported) {
      throw Exception(
        '$name is only available on Landi handheld devices (Android).',
      );
    }
    if (!await isAvailable()) {
      throw Exception(
        '$name is not available. This only works on a Landi handheld POS '
        'with its printer service running — if you are on one, wait a few '
        'seconds after the app starts and try again.',
      );
    }
  }

  String _describe(PlatformException e) {
    switch (e.code) {
      case 'PRINTER_NOT_READY':
        return 'The built-in printer is not ready yet. Try again in a moment.';
      case 'PRINTER_BUSY':
        return 'The built-in printer is still printing the previous job.';
      case 'PRINTER_TIMEOUT':
        return 'The built-in printer did not answer in time. Check that it '
            'has paper and the cover is closed.';
      case 'PRINTER_FAILED':
        // The SDK only gives a numeric code. Out of paper / cover open are the
        // usual causes on these handhelds.
        return 'The built-in printer reported error code ${e.details ?? '?'}. '
            'Check that it has paper and the cover is closed.';
      default:
        return 'Built-in printer error: ${e.message ?? e.code}';
    }
  }
}

/// Lays text out in fixed-width lines for a plain-text printer.
///
/// Every method returns whole lines (no trailing newline), already wrapped to
/// [columns], so the printer never has to break a line itself.
class ReceiptTextLayout {
  const ReceiptTextLayout(this.columns);

  final int columns;

  /// A full-width rule, e.g. `hr('=')`.
  String hr([String char = '-']) => char * columns;

  /// Word-wraps [text] to [width] (default: the full width). Words longer than
  /// a whole line are split. Always returns at least one line.
  List<String> wrap(String text, [int? width]) {
    var w = width ?? columns;
    if (w < 1) w = 1;
    if (w > columns) w = columns;
    final lines = <String>[];

    for (final paragraph in text.split('\n')) {
      var line = '';
      for (final raw in paragraph.trim().split(RegExp(r'\s+'))) {
        var word = raw;
        if (word.isEmpty) continue;

        while (word.length > w) {
          if (line.isNotEmpty) {
            lines.add(line);
            line = '';
          }
          lines.add(word.substring(0, w));
          word = word.substring(w);
        }

        if (line.isEmpty) {
          line = word;
        } else if (line.length + 1 + word.length <= w) {
          line = '$line $word';
        } else {
          lines.add(line);
          line = word;
        }
      }
      lines.add(line);
    }
    return lines;
  }

  /// Wraps [text] and centres every line.
  List<String> center(String text) {
    return [
      for (final line in wrap(text))
        '${' ' * ((columns - line.length) ~/ 2)}$line',
    ];
  }

  /// [left] against the left edge and [right] against the right edge.
  ///
  /// When [left] is too long it wraps, and [right] sits on the last line.
  List<String> leftRight(String left, String right) {
    final leftWidth = columns - right.length - 1;

    // Normal case: [right] fits next to the (possibly wrapped) [left].
    if (leftWidth >= 8) {
      final lines = wrap(left, leftWidth);
      final last = lines.length - 1;
      lines[last] = lines[last].padRight(columns - right.length) + right;
      return lines;
    }

    // [right] is too wide to share a line: give it a line of its own.
    return [...wrap(left), right.padLeft(columns)];
  }
}
