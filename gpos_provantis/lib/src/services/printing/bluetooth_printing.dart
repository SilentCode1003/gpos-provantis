import 'package:flutter/material.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';

import 'package:gpos_provantis/src/core/database/domain/printer_dto.dart';
import 'test_ticket.dart';

/// Bluetooth Low Energy (BLE) printing.
///
/// Note: flutter_thermal_printer only supports BLE, not Bluetooth Classic
/// (SPP). Classic-only printers will not show up in [scan].
class BluetoothPrinterService {
  final _printerPlugin = FlutterThermalPrinter.instance;

  Stream<List<Printer>> get devicesStream => _printerPlugin.devicesStream;

  Future<void> scan() async {
    debugPrint('[BLE] Starting scan for Bluetooth printers...');
    await _printerPlugin.getPrinters(connectionTypes: [ConnectionType.BLE]);
  }

  Future<void> stopScan() async {
    try {
      await _printerPlugin.stopScan();
    } catch (e) {
      debugPrint('[BLE] stopScan() failed (ignored): $e');
    }
  }

  Future<void> printDirect(
    List<int> data, {
    required Printer printerDevice,
  }) async {
    debugPrint(
      '[BLE] Target device — name: "${printerDevice.name}", '
      'address: "${printerDevice.address}", bytes: ${data.length}',
    );

    try {
      debugPrint('[BLE] Connecting to "${printerDevice.name}"...');
      // The plugin's default stabilization delay is 10s, which makes every
      // print painfully slow. 2s is enough for most printers; raise it if
      // you see dropped/garbled prints on a specific model.
      final connected = await _printerPlugin.connect(
        printerDevice,
        connectionStabilizationDelay: const Duration(seconds: 2),
      );
      if (!connected) {
        throw Exception(
          'Could not connect to "${printerDevice.name}" over Bluetooth.',
        );
      }

      debugPrint('[BLE] Sending ${data.length} bytes...');
      await _printerPlugin.printData(
        printerDevice,
        data,
        // Chunk the data: BLE has small packet sizes.
        longData: true,
      );
      debugPrint('[BLE] Print job sent successfully!');
    } catch (e, st) {
      debugPrint('[BLE] ERROR printing to Bluetooth printer: $e');
      debugPrint('[BLE] Stack trace: $st');
      rethrow;
    } finally {
      try {
        await _printerPlugin.disconnect(printerDevice);
      } catch (e) {
        debugPrint('[BLE] disconnect() failed (ignored): $e');
      }
    }
  }

  Future<void> printTestPage(PrinterDto printer) async {
    debugPrint(
      '[BLE] printTestPage() for saved printer "${printer.name}" '
      '(address: "${printer.address}", paperSize: ${printer.paperSize}mm)',
    );

    final device = await getSavedBlePrinter(printer.address);
    if (device == null) {
      throw Exception(
        'Could not find "${printer.name}" over Bluetooth — check it is '
        'powered on, in range, and Bluetooth is enabled.',
      );
    }

    final bytes = await buildTestTicket(
      printerName: printer.name,
      paperSizeMm: printer.paperSize,
    );
    await printDirect(bytes, printerDevice: device);
  }

  Future<Printer?> getSavedBlePrinter(String targetAddress) async {
    try {
      debugPrint(
        '[BLE] Looking for a scanned device with address '
        '"$targetAddress"...',
      );

      final streamFuture = _printerPlugin.devicesStream
          .firstWhere(
            (list) => list.any(
              (p) =>
                  p.address == targetAddress &&
                  p.connectionType == ConnectionType.BLE,
            ),
          )
          // BLE scans are slower than USB, so allow more time.
          .timeout(const Duration(seconds: 10));

      await _printerPlugin.getPrinters(connectionTypes: [ConnectionType.BLE]);

      final list = await streamFuture;
      return list.firstWhere((p) => p.address == targetAddress);
    } catch (e) {
      debugPrint('[BLE] Printer not found, off, or scan timed out: $e');
      return null;
    } finally {
      await stopScan();
    }
  }
}
