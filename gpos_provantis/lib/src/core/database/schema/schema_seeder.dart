import 'package:drift/drift.dart';
import '../app_database.dart';
import '../seeders/employees_seeder.dart';
import '../seeders/users_seeder.dart';

class SchemaSeeder {
  final AppDatabase db;

  SchemaSeeder(this.db);

  Future<void> seedInitialData() async {
    await db.batch((batch) {
      // NOTE: Sequence matters.
      EmployeesSeeder.insert(db, batch);

      UsersSeeder.insert(db, batch);
    });
  }
}
