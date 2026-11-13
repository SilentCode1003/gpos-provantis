import 'package:drift/drift.dart';
import '../../app_database.dart';
import 'db_migration.dart';

/// Settings > Login: "Remember last login".
class Migration111326 extends DbMigration {
  const Migration111326();

  @override
  String get name => 'migration_11_13_26';

  @override
  Future<void> up(Migrator m, AppDatabase db) async {
    await m.addColumn(db.settingsTable, db.settingsTable.rememberLastLogin);
    await m.addColumn(db.settingsTable, db.settingsTable.lastLoginUsername);
  }
}
