import 'package:drift/drift.dart';
import '../app_database.dart';

class SchemaMigrator {
  final AppDatabase db;
  final Migrator m;

  SchemaMigrator({required this.db, required this.m});

  Future<void> upgrade(int from, int to) async {
    for (var i = from + 1; i <= to; i++) {
      await _runMigrationForVersion(i);
    }
  }

  Future<void> _runMigrationForVersion(int version) async {
    switch (version) {
      case 2:
        break;
      default:
        break;
    }
  }
}
