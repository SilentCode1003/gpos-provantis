import 'dart:io';

import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';

import 'package:gpos_provantis/src/core/database/domain/printer_dto.dart';
import 'test_ticket.dart';

/// USB printing never depended on GetX in the first place, so this file
/// is functionally the same as your old one — the only additions are
/// `printTestPage`, which the settings panel now calls directly, and
/// `getSavedUsbPrinter` taking the address straight off a `PrinterDto`
/// instead of a bare string, so callers don't have to unwrap the DTO
/// themselves.
///
/// IMPORTANT PLATFORM DIFFERENCE (this is almost certainly why "sent
/// successfully" doesn't mean "printed" on Windows):
///
/// `flutter_thermal_printer`'s `printData` takes two completely different
/// code paths depending on platform:
///   - Windows: ignores `printer.address` entirely and opens the Win32
///     print spooler BY NAME — `RawPrinter(printer.name!, ...)`. This only
///     works if a printer with that *exact* name is installed in Windows
///     and is either a "Generic / Text Only" driver or a manufacturer
///     driver configured to pass raw ESC/POS bytes straight through
///     instead of interpreting them as a text/graphics document. If the
///     Windows print queue accepts the job (spools it) but the driver
///     mangles or discards the raw bytes, or the queue is paused, or the
///     job goes to the wrong physical printer, the native call still
///     returns normally — Dart has no way to know the physical page never
///     came out, so `printData` reports success regardless.
///   - Android/other: uses `printer.address` as a device path and talks to
///     the USB endpoint directly, so success there is a much stronger
///     signal that something physically happened.
///
/// The logging below is there specifically to separate those cases: it
/// tells you which native path was taken, exactly what device/name was
/// targeted, and exactly how many bytes were sent, so "it says success"
/// and "it printed" can be told apart instead of both looking identical
/// in the console.
class UsbPrinterService {
  final _printerPlugin = FlutterThermalPrinter.instance;

  // Expose the stream of devices found during scanning
  Stream<List<Printer>> get devicesStream => _printerPlugin.devicesStream;

  // Start scanning for USB devices
  Future<void> scan() async {
    debugPrint('[USB] Starting scan for USB printers...');
    await _printerPlugin.getPrinters(connectionTypes: [ConnectionType.USB]);
  }

  /// Print directly to a known USB printer.
  Future<void> printDirect(
    List<int> data, {
    required Printer printerDevice,
  }) async {
    _logDeviceDetails(printerDevice);
    debugPrint('[USB] Ticket size: ${data.length} bytes');

    if (Platform.isWindows) {
      debugPrint(
        '[USB] Platform is Windows — flutter_thermal_printer will send this '
        'job through the Win32 spooler using the printer NAME '
        '"${printerDevice.name}", NOT the saved address. This requires a '
        'Windows printer with that exact name to be installed and set to '
        'pass raw bytes through (e.g. "Generic / Text Only" driver, or the '
        'manufacturer driver with a raw/passthrough port). If the name '
        'here does not exactly match an installed Windows printer, or that '
        'printer\'s driver does not accept raw ESC/POS, this call will '
        'still report success with nothing printed.',
      );
    } else {
      debugPrint(
        '[USB] Non-Windows platform — flutter_thermal_printer will open '
        'the USB device at address "${printerDevice.address}" directly.',
      );
    }

    try {
      debugPrint('[USB] Connecting to "${printerDevice.name}"...');
      await _printerPlugin.connect(printerDevice);
      debugPrint('[USB] connect() returned without throwing.');

      debugPrint('[USB] Calling printData() with ${data.length} bytes...');
      await _printerPlugin.printData(printerDevice, data);
      debugPrint(
        '[USB] printData() returned without throwing. On Windows this only '
        'confirms the job reached the spooler, NOT that paper came out — '
        'check the Windows print queue and the printer\'s driver/port '
        'settings if nothing physically printed.',
      );

      debugPrint('[USB] Disconnecting...');
      await _printerPlugin.disconnect(printerDevice);
      debugPrint('[USB] disconnect() returned without throwing.');

      debugPrint('[USB] Print job sent successfully!');
    } catch (e, st) {
      debugPrint('[USB] ERROR printing to USB printer: $e');
      debugPrint('[USB] Stack trace: $st');
      rethrow;
    }
  }

  void _logDeviceDetails(Printer p) {
    debugPrint(
      '[USB] Target device — name: "${p.name}", address: "${p.address}", '
      'vendorId: ${p.vendorId}, productId: ${p.productId}, '
      'connectionType: ${p.connectionType}, isConnected: ${p.isConnected}',
    );
  }

  /// Builds a standard test ticket and sends it to [printer]'s saved
  /// address. Throws if the device can't be found on a fresh scan (e.g.
  /// unplugged) — callers (the settings panel) turn that into a SnackBar.
  Future<void> printTestPage(PrinterDto printer) async {
    debugPrint(
      '[USB] printTestPage() for saved printer "${printer.name}" '
      '(address: "${printer.address}", paperSize: ${printer.paperSize}mm)',
    );

    final device = await getSavedUsbPrinter(printer.address);
    if (device == null) {
      debugPrint(
        '[USB] No matching USB device found for address '
        '"${printer.address}" — is it plugged in / powered on?',
      );
      throw Exception(
        'Could not find "${printer.name}" on USB — check it is plugged in and powered on.',
      );
    }

    debugPrint('[USB] Matched saved printer to a live scanned device.');
    _logDeviceDetails(device);

    final bytes = await buildTestTicket(
      printerName: printer.name,
      paperSizeMm: printer.paperSize,
    );
    debugPrint('[USB] Built test ticket: ${bytes.length} bytes.');

    await printDirect(bytes, printerDevice: device);
  }

  /// Helper to scan and find a saved USB printer by its stored MAC/device
  /// address.
  Future<Printer?> getSavedUsbPrinter(String targetMacAddress) async {
    try {
      debugPrint(
        '[USB] Looking for a scanned device with address '
        '"$targetMacAddress"...',
      );

      // 1. Start listening to the stream BEFORE scanning to avoid race conditions
      final streamFuture = _printerPlugin.devicesStream
          .firstWhere(
            (printerList) =>
                printerList.any((p) => p.address == targetMacAddress),
          )
          .timeout(const Duration(seconds: 3));

      // 2. Trigger the hardware scan
      await _printerPlugin.getPrinters(connectionTypes: [ConnectionType.USB]);

      // 3. Wait for the stream result
      final matchingList = await streamFuture;
      debugPrint(
        '[USB] Scan tick returned ${matchingList.length} device(s): '
        '${matchingList.map((p) => '"${p.name}" (${p.address})').join(', ')}',
      );

      // 4. Pluck our specific printer out of that emitted list
      return matchingList.firstWhere((p) => p.address == targetMacAddress);
    } catch (e) {
      debugPrint('[USB] Printer not found, unplugged, or scan timed out: $e');
      return null;
    }
  }
}
