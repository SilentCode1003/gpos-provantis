import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/printers_table.dart';

part 'printer_dao.g.dart';

@DriftAccessor(tables: [PrintersTable])
class PrinterDao extends DatabaseAccessor<AppDatabase> with _$PrinterDaoMixin {
  PrinterDao(super.db);

  // Saves a printer row in local storage.
  // Keeps the device printer setup available for later reads.
  Future<void> savePrinter(PrintersTableCompanion data) {
    return into(printersTable).insert(data);
  }

  // Upserts the printer row to keep configuration current.
  // Prevents duplicate entries while preserving the latest printer values.
  Future<void> upsertPrinter(PrintersTableCompanion data) {
    return into(printersTable).insertOnConflictUpdate(data);
  }

  // Deletes a printer record for the given local ID.
  // Used when removing a printer from the current device setup.
  Future<void> deletePrinter(String id) {
    return (delete(printersTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Replaces the cached printer list with a fresh snapshot.
  // Used when the local device configuration is refreshed from sync.
  Future<void> replacePrinters(List<PrintersTableCompanion> data) {
    return transaction(() async {
      await delete(printersTable).go();
      await batch((batch) {
        batch.insertAll(printersTable, data);
      });
    });
  }

  // Reads all printers from local storage.
  // Returns the current device printer configuration.
  Future<List<PrintersTableData>> getAllPrinters() {
    return select(printersTable).get();
  }

  // Watches the printer list for live updates.
  // Useful for screens that react to configuration changes immediately.
  Stream<List<PrintersTableData>> watchAllPrinters() {
    return select(printersTable).watch();
  }
}
