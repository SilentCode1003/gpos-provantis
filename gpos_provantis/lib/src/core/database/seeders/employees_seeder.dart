import 'package:drift/drift.dart';
import '../app_database.dart';
import 'seed_constants.dart';

abstract class EmployeesSeeder {
  static void insert(AppDatabase db, Batch batch) {
    batch.insertAll(db.employeesTable, [
      EmployeesTableCompanion.insert(
          id: const Value(SeedIds.adminEmployeeId),
          employeeId: 'EMP-001',
          fullname: 'System Administrator',
          contactNo: '09123456789',
          email: 'admin@system.local',
          createdBy: 'SYSTEM_INITIALIZER',
          updatedBy: 'SYSTEM_INITIALIZER',
        ),
        EmployeesTableCompanion.insert(
          id: const Value(SeedIds.staffEmployeeId),
          employeeId: 'EMP-002',
          fullname: 'Jane Doe',
          contactNo: '09987654321',
          email: 'jane.doe@system.local',
          createdBy: 'SYSTEM_INITIALIZER',
          updatedBy: 'SYSTEM_INITIALIZER',
        ),
    ]);
  }
}
