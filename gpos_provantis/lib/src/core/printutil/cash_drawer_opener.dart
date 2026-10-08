import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod/riverpod.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/printer_dao.dart';
import 'package:gpos_provantis/src/core/database/daos/settings_dao.dart';
import 'package:gpos_provantis/src/core/database/domain/printer_dto.dart';
import 'package:gpos_provantis/src/core/database/providers/printer_dao_provider.dart'
    show printerDaoProvider;
import 'package:gpos_provantis/src/core/database/providers/settings_dao_provider.dart'
    show settingsDaoProvider;

import 'package:gpos_provantis/src/services/printing/usb_printing.dart';
import 'package:gpos_provantis/src/services/printing/wifi_printing.dart';

class CashDrawerOpenException implements Exception {
  const CashDrawerOpenException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Pops the physical cash drawer by sending the ESC/POS "drawer kick" command
/// to the printer the drawer is plugged into.
///
/// Printer choice: only printers that are enabled AND have a cash drawer are
/// candidates. If the main printer in Settings is one of them it wins,
/// otherwise the first candidate is used.
class CashDrawerOpener {
  CashDrawerOpener({
    required PrinterDao printerDao,
    required SettingsDao settingsDao,
  }) : _printerDao = printerDao,
       _settingsDao = settingsDao;

  final PrinterDao _printerDao;
  final SettingsDao _settingsDao;

  Future<void> open() async {
    debugPrint('[CashDrawer] open: looking for a printer with a drawer...');

    final printer = await _pickPrinter();
    debugPrint(
      '[CashDrawer] open: using "${printer.name}" '
      '(${printer.connectionType}, ${printer.address})',
    );

    final paperSize = printer.paperSize.contains('58')
        ? PaperSize.mm58
        : PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final bytes = Generator(paperSize, profile).drawer();

    if (printer.connectionType.toLowerCase().contains('usb')) {
      final usb = UsbPrinterService();
      final device = await usb.getSavedUsbPrinter(printer.address);
      if (device == null) {
        throw CashDrawerOpenException(
          'Could not find "${printer.name}" on USB. Check it is plugged in '
          'and powered on.',
        );
      }
      await usb.printDirect(bytes, printerDevice: device);
    } else {
      await WifiPrinterService().printData(bytes, printer: printer);
    }
    debugPrint('[CashDrawer] open: drawer command sent');
  }

  Future<PrinterDto> _pickPrinter() async {
    // One-shot read of the Drift stream, not a Riverpod stream provider (see
    // DashboardController.isCashDrawerEnabled for why).
    final printers = await _printerDao.watchAllPrinters().first.timeout(
      const Duration(seconds: 5),
    );
    final candidates = printers
        .where((p) => p.isEnabled && p.hasCashDrawer)
        .toList();
    if (candidates.isEmpty) {
      throw const CashDrawerOpenException(
        'No cash drawer is enabled. Turn it on in the printer settings.',
      );
    }

    // Prefer the main printer from Settings (matched by id or name).
    var mainPrinter = '';
    try {
      final settings = await _settingsDao.watchSettings().first.timeout(
        const Duration(seconds: 5),
      );
      if (settings.isNotEmpty) {
        mainPrinter = settings.first.mainPrinter.trim().toLowerCase();
      }
    } catch (e) {
      debugPrint('[CashDrawer] open: could not read main printer setting: $e');
    }

    final PrintersTableData chosen = candidates.firstWhere(
      (p) =>
          mainPrinter.isNotEmpty &&
          (p.id.toLowerCase() == mainPrinter ||
              p.name.toLowerCase() == mainPrinter),
      orElse: () => candidates.first,
    );
    return PrinterDto.fromTableData(chosen);
  }
}

final cashDrawerOpenerProvider = Provider<CashDrawerOpener>((ref) {
  return CashDrawerOpener(
    printerDao: ref.watch(printerDaoProvider),
    settingsDao: ref.watch(settingsDaoProvider),
  );
});
