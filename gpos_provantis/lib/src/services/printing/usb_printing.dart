import 'dart:io';

import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';

import 'package:gpos_provantis/src/core/database/domain/printer_dto.dart';
import 'test_ticket.dart';

class UsbPrinterService {
  final _printerPlugin = FlutterThermalPrinter.instance;

  Stream<List<Printer>> get devicesStream => _printerPlugin.devicesStream;

  Future<void> scan() async {
    debugPrint('[USB] Starting scan for USB printers...');
    await _printerPlugin.getPrinters(connectionTypes: [ConnectionType.USB]);
  }

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

  Future<Printer?> getSavedUsbPrinter(String targetMacAddress) async {
    try {
      debugPrint(
        '[USB] Looking for a scanned device with address '
        '"$targetMacAddress"...',
      );

      final streamFuture = _printerPlugin.devicesStream
          .firstWhere(
            (printerList) =>
                printerList.any((p) => p.address == targetMacAddress),
          )
          .timeout(const Duration(seconds: 3));

      await _printerPlugin.getPrinters(connectionTypes: [ConnectionType.USB]);

      final matchingList = await streamFuture;
      debugPrint(
        '[USB] Scan tick returned ${matchingList.length} device(s): '
        '${matchingList.map((p) => '"${p.name}" (${p.address})').join(', ')}',
      );

      return matchingList.firstWhere((p) => p.address == targetMacAddress);
    } catch (e) {
      debugPrint('[USB] Printer not found, unplugged, or scan timed out: $e');
      return null;
    }
  }
}
