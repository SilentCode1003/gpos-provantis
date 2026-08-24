import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:uuid/uuid.dart';
// import '../utils/date_time_converter.dart';

import 'schema/schema_migrator.dart';
import 'schema/schema_seeder.dart';

import 'tables/pos_config_table.dart';
import 'tables/branch_config_table.dart';
import 'tables/domain_config_table.dart';
import 'tables/user_data_table.dart';

import 'daos/domain_config_dao.dart';
import 'daos/branch_config_dao.dart';
import 'daos/pos_config_dao.dart';

part 'app_database.g.dart';

/// The central SQLite database managed by Drift.
///
/// To update the schema (add tables/columns):
/// 1. Modify the table classes in /tables/
/// 2. Run 'dart run build_runner build'
/// 3. Increment [schemaVersion]
/// 4. Add migration logic in the [migration] getter below.
@DriftDatabase(
  tables: [POSConfigTable, UserDataTable, BranchConfigTable, DomainConfigTable],
  daos: [DomainConfigDao, BranchConfigDao, PosConfigDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      // Delegate migration to the specialized class
      await SchemaMigrator(db: this, m: m).upgrade(from, to);
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');

      // Check if the database was just created
      if (details.wasCreated) {
        await SchemaSeeder(this).seedInitialData();
      }
    },
  );

  Stream<UserDataTableData?> watchCurrentUser() {
    return select(userDataTable).watchSingleOrNull();
  }
}

/// Helper function to locate the database file and establish the connection.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Finds the app's local document directory on the device.
    final dbFolder = await getApplicationDocumentsDirectory();
    // Names the physical file on disk.
    final file = File(p.join(dbFolder.path, 'gpos_provantis_local.sqlite'));

    // Background execution prevents UI jank during heavy DB operations.
    return NativeDatabase.createInBackground(file);
  });
}

/// Riverpod provider to make the database accessible throughout the app.
/// [keepAlive] is true because we want one database instance to live as long as the app.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();

  // Ensures the database connection is closed safely if the app process is killed.
  ref.onDispose(() => db.close());

  return db;
}
