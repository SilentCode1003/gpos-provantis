import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/employees_table.dart';

part 'employees_dao.g.dart';

@DriftAccessor(tables: [EmployeesTable])
class EmployeesDao extends DatabaseAccessor<AppDatabase>
    with _$EmployeesDaoMixin {
  EmployeesDao(super.db);

  // Saves an employee row in local storage.
  // Keeps the local roster ready for staffing and sync operations.
  Future<void> saveEmployee(EmployeesTableData employee) {
    return into(employeesTable).insert(employee);
  }

  // Replaces the cached employee list with a fresh snapshot.
  // Used to refresh roster data after a remote sync.
  Future<void> replaceEmployees(List<EmployeesTableCompanion> employees) {
    return transaction(() async {
      await delete(employeesTable).go();
      await batch((batch) {
        batch.insertAll(employeesTable, employees);
      });
    });
  }

  // Reads all employees from local storage.
  // Returns the full cached roster for the current device.
  Future<List<EmployeesTableData>> getAllEmployees() {
    return select(employeesTable).get();
  }

  // Watches the employee list for live updates.
  // Useful for screens that react to roster changes immediately.
  Stream<List<EmployeesTableData>> watchAllEmployees() {
    return select(employeesTable).watch();
  }
}
