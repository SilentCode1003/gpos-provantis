import 'dart:io';
import 'package:flutter/material.dart';

import 'package:gpos_provantis/src/core/database/domain/printer_dto.dart';
import 'test_ticket.dart';

/// WiFi printing, ported off GetX.
///
/// The old version pulled `Get.find<SettingsRepository>()` and resolved a
/// printer by a `posPrinterId` / `kitchenPrinterId` role lookup against a
/// separate `PrinterModel`. None of that exists in the new app — printers
/// now live in `settingsControllerProvider` as `PrinterDto`, and the panel
/// already has the exact `PrinterDto` the user tapped in hand. So instead
/// of re-plumbing a role-lookup system that has no equivalent here, every
/// method below takes the `PrinterDto` directly. If you later want
/// "the configured POS printer" / "the configured kitchen printer" as a
/// concept again, that selection should live as two fields (e.g.
/// `posPrinterId`, `kitchenPrinterId`) on your app-level settings state in
/// Riverpod, with a provider that resolves them against
/// `settingsControllerProvider`'s printer list — happy to wire that up
/// once that settings model exists.
class WifiPrinterService {
  /// Sends raw ESC/POS bytes to [printer]'s saved IP/port.
  Future<void> printData(List<int> data, {required PrinterDto printer}) async {
    final ip = printer.address;
    final port = _resolvePort(printer);

    if (ip.isEmpty) {
      throw Exception('Printer IP is missing for "${printer.name}".');
    }

    try {
      debugPrint("Connecting to WiFi Printer: $ip:$port...");

      final socket = await Socket.connect(
        ip,
        port,
        timeout: const Duration(seconds: 5),
      );

      socket.add(data);
      await socket.flush();
      await socket.close();

      debugPrint("Print job sent successfully to $ip:$port");
    } catch (e) {
      debugPrint("Error printing to WiFi printer: $e");
      rethrow;
    }
  }

  /// Allows printing to an arbitrary IP/port, bypassing saved printers —
  /// useful for a "test this address before saving" step in the add-printer
  /// form.
  Future<void> printDirect(
    List<int> data, {
    required String ip,
    required int port,
  }) async {
    try {
      debugPrint("Testing connection to $ip:$port...");

      final socket = await Socket.connect(
        ip,
        port,
        timeout: const Duration(seconds: 5),
      );

      socket.add(data);
      await socket.flush();
      await socket.close();

      debugPrint("Direct print success to $ip");
    } catch (e) {
      debugPrint("Direct print error: $e");
      rethrow;
    }
  }

  /// Builds a standard test ticket and sends it to [printer].
  Future<void> printTestPage(PrinterDto printer) async {
    final bytes = await buildTestTicket(
      printerName: printer.name,
      paperSizeMm: printer.paperSize,
    );
    await printData(bytes, printer: printer);
  }

  /// Test WiFi printer connection without sending a real job.
  Future<void> ping(PrinterDto printer) async {
    final ip = printer.address;
    final port = _resolvePort(printer);

    if (ip.isEmpty) throw Exception("Printer IP not configured");

    try {
      final socket = await Socket.connect(
        ip,
        port,
        timeout: const Duration(seconds: 3),
      );
      await socket.close();
      debugPrint("Ping success: $ip:$port");
    } catch (e) {
      debugPrint("Ping failed: $e");
      rethrow;
    }
  }

  /// `PrinterDto` (from the printers_panel form) doesn't currently carry a
  /// port field — the add/edit sheet only collects a single "address"
  /// string. Thermal printers overwhelmingly listen on 9100, so that's the
  /// default here. If you add a port field to `PrinterDto` later, read it
  /// here instead of hardcoding.
  int _resolvePort(PrinterDto printer) => 9100;
}
