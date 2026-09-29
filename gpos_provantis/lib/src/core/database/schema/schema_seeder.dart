import 'package:drift/drift.dart';
import '../app_database.dart';

class SchemaSeeder {
  final AppDatabase db;

  SchemaSeeder(this.db);

  Future<void> seedInitialData() async {
    await db.batch((batch) {});
  }
}
