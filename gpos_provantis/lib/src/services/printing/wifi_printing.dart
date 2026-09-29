import 'dart:io';
import 'package:flutter/material.dart';

import 'package:gpos_provantis/src/core/database/domain/printer_dto.dart';
import 'test_ticket.dart';

class WifiPrinterService {
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

  Future<void> printTestPage(PrinterDto printer) async {
    final bytes = await buildTestTicket(
      printerName: printer.name,
      paperSizeMm: printer.paperSize,
    );
    await printData(bytes, printer: printer);
  }

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

  int _resolvePort(PrinterDto printer) => 9100;
}
