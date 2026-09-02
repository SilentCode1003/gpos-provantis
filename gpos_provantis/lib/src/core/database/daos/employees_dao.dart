import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/employees_table.dart';

part 'employees_dao.g.dart';

@DriftAccessor(tables: [EmployeesTable])
class EmployeesDao extends DatabaseAccessor<AppDatabase>
    with _$EmployeesDaoMixin {
  EmployeesDao(super.db);

  Future<void> saveEmployee(EmployeesTableData employee) {
    return into(employeesTable).insert(employee);
  }

  Future<List<EmployeesTableData>> getAllEmployees() {
    return select(employeesTable).get();
  }

  Stream<List<EmployeesTableData>> watchAllEmployees() {
    return select(employeesTable).watch();
  }
}
