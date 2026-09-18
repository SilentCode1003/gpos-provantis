import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/domain/printer_dto.dart';
import 'package:gpos_provantis/src/core/database/providers/printer_dao_provider.dart';

part 'settings_controller.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  @override
  Future<List<PrinterDto>> build() async {
    final dao = ref.watch(printerDaoProvider);
    final rows = await dao.getAllPrinters();
    return rows.map(PrinterDto.fromTableData).toList();
  }

  Future<void> addPrinter(PrinterDto printer) async {
    final dao = ref.read(printerDaoProvider);
    await dao.savePrinter(printer.toCompanion(forInsert: true));
    ref.invalidateSelf();
    await future;
  }

  Future<void> updatePrinter(PrinterDto printer) async {
    final dao = ref.read(printerDaoProvider);
    await dao.upsertPrinter(printer.toCompanion());
    ref.invalidateSelf();
    await future;
  }

  Future<void> removePrinter(String id) async {
    final dao = ref.read(printerDaoProvider);
    await dao.deletePrinter(id);
    ref.invalidateSelf();
    await future;
  }
}
