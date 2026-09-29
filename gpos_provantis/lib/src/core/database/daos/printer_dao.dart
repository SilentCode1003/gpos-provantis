import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/printers_table.dart';

part 'printer_dao.g.dart';

@DriftAccessor(tables: [PrintersTable])
class PrinterDao extends DatabaseAccessor<AppDatabase> with _$PrinterDaoMixin {
  PrinterDao(super.db);

  Future<void> savePrinter(PrintersTableCompanion data) {
    return into(printersTable).insert(data);
  }

  Future<void> upsertPrinter(PrintersTableCompanion data) {
    return into(printersTable).insertOnConflictUpdate(data);
  }

  Future<void> deletePrinter(String id) {
    return (delete(printersTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> replacePrinters(List<PrintersTableCompanion> data) {
    return transaction(() async {
      await delete(printersTable).go();
      await batch((batch) {
        batch.insertAll(printersTable, data);
      });
    });
  }

  Future<List<PrintersTableData>> getAllPrinters() {
    return select(printersTable).get();
  }

  Stream<List<PrintersTableData>> watchAllPrinters() {
    return select(printersTable).watch();
  }
}
