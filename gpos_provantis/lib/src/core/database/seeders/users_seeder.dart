import 'package:drift/drift.dart';
import '../app_database.dart';
import 'seed_constants.dart';

abstract class UsersSeeder {
  static void insert(AppDatabase db, Batch batch) {
    batch.insertAll(db.usersTable, [
      UsersTableCompanion.insert(
        empId: SeedIds.adminEmployeeId,
        username: 'admin',
        password: 'admin',
        createdBy: 'SYSTEM_INITIALIZER',
        updatedBy: 'SYSTEM_INITIALIZER',
      ),
      UsersTableCompanion.insert(
        empId: SeedIds.staffEmployeeId,
        username: 'user',
        password: 'user',
        createdBy: 'SYSTEM_INITIALIZER',
        updatedBy: 'SYSTEM_INITIALIZER',
      ),
    ]);
  }
}
