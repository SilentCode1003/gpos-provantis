import 'db_migration.dart';
import 'migration_11_13_26.dart';
import 'migration_11_13_26_r1.dart';

/// Every migration, oldest first. This is the only file to touch when you
/// add one:
///
///   1. Create the migration file (copy migration_11_13_26.dart).
///   2. Import it above.
///   3. Add `const MigrationXXXXXX(),` at the END of the list.
///
/// The position in this list IS the schema version: the first entry takes the
/// database from version 1 to 2, the second from 2 to 3, and so on. So only
/// ever add to the end. Never reorder, rename or delete an entry that has
/// shipped, or devices that already ran it will get out of step.
const List<DbMigration> allMigrations = [
  Migration111326(),
  Migration111326R1(),
];
