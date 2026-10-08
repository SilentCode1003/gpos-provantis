import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/printer_dao.dart';

part 'printer_dao_provider.g.dart';

@Riverpod(keepAlive: true)
PrinterDao printerDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return PrinterDao(db);
}

final printerProvider =
    StreamNotifierProvider<PrinterNotifier, List<PrintersTableData>>(
      PrinterNotifier.new,
    );

class PrinterNotifier extends StreamNotifier<List<PrintersTableData>> {
  @override
  Stream<List<PrintersTableData>> build() {
    final dao = ref.watch(printerDaoProvider);
    return dao.watchAllPrinters();
  }
}

/// True when at least one enabled printer has a cash drawer attached.
///
/// Watched by the cash-drawer buttons (Cash drop, Open cashdrawer) so they
/// grey out, and re-enable live, when the setting changes. False while the
/// printers are still loading (or failed to load), so the buttons stay off
/// until the answer is known.
final cashDrawerEnabledProvider = Provider<bool>((ref) {
  final printers = ref.watch(printerProvider);
  return printers.maybeWhen(
    data: (rows) => rows.any((p) => p.isEnabled && p.hasCashDrawer),
    orElse: () => false,
  );
});
