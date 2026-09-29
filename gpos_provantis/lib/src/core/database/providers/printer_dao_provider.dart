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
