import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/printers_table.dart';

part 'printer_dao.g.dart';

@DriftAccessor(tables: [PrintersTable])
class PrinterDao extends DatabaseAccessor<AppDatabase> with _$PrinterDaoMixin {
  PrinterDao(super.db);

  /// Inserts a brand-new printer row (id comes from the table's
  /// `clientDefault` uuid unless the companion already sets one).
  Future<void> savePrinter(PrintersTableCompanion data) {
    return into(printersTable).insert(data);
  }

  /// Insert-or-update by primary key (`id`). Use this for edits, since
  /// `insert` alone would throw on a duplicate id.
  Future<void> upsertPrinter(PrintersTableCompanion data) {
    return into(printersTable).insertOnConflictUpdate(data);
  }

  Future<void> deletePrinter(String id) {
    return (delete(printersTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Wholesale replace, kept for parity with `PosShiftDao.replacePosShifts`
  /// in case printers ever get bulk-synced from a back office the same way
  /// shifts do. Individual add/edit/remove from Settings should prefer
  /// `upsertPrinter` / `deletePrinter` instead, so one edit doesn't wipe
  /// every other configured printer.
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
