import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/database/app_database.dart';
import '../domain/employees_model.dart';

part 'employees_repository.g.dart';

class EmployeesRepository {
  final AppDatabase _db;

  EmployeesRepository(this._db);

  // 1. READ (Now a Stream instead of a Future)
  Stream<List<EmployeesModel>> watchEmployees() {
    return _db
        .select(_db.employeesTable)
        .watch()
        .map(
          (rows) => rows
              .map(
                (row) => EmployeesModel(
                  id: row.id,
                  employeeId: row.employeeId,
                  fullName: row.fullname,
                  contactNo: row.contactNo,
                  email: row.email,
                  createdBy: row.createdBy,
                  updatedBy: row.updatedBy,
                  createdAt: row.createdAt,
                  updatedAt: row.updatedAt,
                  isActive: row.isActive,
                ),
              )
              .toList(),
        );
  }

  // 2. CREATE
  Future<void> insertEmployee(EmployeesModel employee) async {
    await _db
        .into(_db.employeesTable)
        .insert(
          EmployeesTableCompanion.insert(
            // If the UI sends an empty ID, let Drift generate it!
            id: employee.id.isEmpty ? const Value.absent() : Value(employee.id),
            employeeId: employee.employeeId,
            fullname: employee.fullName,
            contactNo: employee.contactNo,
            email: employee.email,
            createdBy: employee.createdBy,
            updatedBy: employee.updatedBy,

            // Let Drift generate the timestamps for new entries
            createdAt: const Value.absent(),
            updatedAt: const Value.absent(),
            isActive: Value(employee.isActive),
          ),
        );
  }

  // 3. UPDATE
  Future<void> updateEmployee(EmployeesModel employee) async {
    await _db
        .update(_db.employeesTable)
        .replace(
          EmployeesTableCompanion(
            id: Value(employee.id), // Primary Key determines which row updates
            employeeId: Value(employee.employeeId),
            fullname: Value(employee.fullName),
            contactNo: Value(employee.contactNo),
            email: Value(employee.email),
            createdBy: Value(employee.createdBy),
            updatedBy: Value(employee.updatedBy),
            createdAt: Value(employee.createdAt),
            // Optionally, update the timestamp here if you want to track edits:
            // updatedAt: Value(DateTime.now().toUtc().toIso8601String()),
            updatedAt: Value(employee.updatedAt),
            isActive: Value(employee.isActive),
          ),
        );
  }

  // 4. DELETE
  Future<void> deleteEmployee(String id) async {
    await (_db.delete(
      _db.employeesTable,
    )..where((tbl) => tbl.id.equals(id))).go();
  }
}

@riverpod
EmployeesRepository employeesRepository(Ref ref) {
  return EmployeesRepository(ref.watch(appDatabaseProvider));
}
