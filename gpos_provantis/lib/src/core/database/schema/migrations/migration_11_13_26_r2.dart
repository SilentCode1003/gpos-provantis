import 'package:drift/drift.dart';
import '../../app_database.dart';
import 'db_migration.dart';

/// Settings > Developer: the on-device developer log.
class Migration111326R2 extends DbMigration {
  const Migration111326R2();

  @override
  String get name => 'migration_11_13_26_r2';

  @override
  Future<void> up(Migrator m, AppDatabase db) async {
    await m.createTable(db.appLogTable);
  }
}
