import 'package:drift/drift.dart';
import '../app_database.dart';
import 'migrations/all_migrations.dart';

/// Runs the migrations listed in migrations/all_migrations.dart, in order.
///
/// Version 1 is the original schema, so the schema version is simply the
/// number of migrations plus one. This file never needs editing: add a file
/// to migrations/ and list it in all_migrations.dart.
class SchemaMigrator {
  final AppDatabase db;
  final Migrator m;

  SchemaMigrator({required this.db, required this.m});

  /// What AppDatabase.schemaVersion returns.
  static int get currentVersion => allMigrations.length + 1;

  Future<void> upgrade(int from, int to) async {
    assert(
      allMigrations.map((x) => x.name).toSet().length == allMigrations.length,
      'Two migrations in all_migrations.dart share a name.',
    );

    for (var version = from + 1; version <= to; version++) {
      // Version 2 is the first migration, version 3 the second, ...
      final index = version - 2;
      if (index < 0 || index >= allMigrations.length) {
        throw StateError('No migration is listed for schema version $version.');
      }

      final migration = allMigrations[index];
      try {
        await migration.up(m, db);
      } catch (e, stack) {
        Error.throwWithStackTrace(
          StateError(
            'Migration ${migration.name} (to version $version) failed: $e',
          ),
          stack,
        );
      }
    }
  }
}
