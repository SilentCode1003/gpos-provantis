import 'package:drift/drift.dart';
import '../../app_database.dart';
import 'db_migration.dart';

/// Settings > Printers: when the sub printer prints an order slip.
class Migration111326R1 extends DbMigration {
  const Migration111326R1();

  @override
  String get name => 'migration_11_13_26_r1';

  @override
  Future<void> up(Migrator m, AppDatabase db) async {
    await m.addColumn(
      db.settingsTable,
      db.settingsTable.subPrinterOrderSlipMode,
    );
  }
}
