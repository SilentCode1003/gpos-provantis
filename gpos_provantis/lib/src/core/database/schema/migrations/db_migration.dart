import 'package:drift/drift.dart';
import '../../app_database.dart';

/// One database change. Each lives in its own file in this folder, named
/// after the day it was written: migration_11_13_26.dart (MM_DD_YY), or
/// migration_11_13_26_r1.dart, _r2, ... for a second, third, ... one that day.
abstract class DbMigration {
  const DbMigration();

  /// Same as the file name, without ".dart". Used in error messages.
  String get name;

  /// Moves the database forward by this one change.
  Future<void> up(Migrator m, AppDatabase db);
}
