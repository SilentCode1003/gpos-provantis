import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/employees_repository.dart';
import '../../domain/employees_model.dart';

part 'employees_controller.g.dart';

@riverpod
class EmployeesController extends _$EmployeesController {
  @override
  Stream<List<EmployeesModel>> build() {
    // The database is the SSOT. Riverpod simply listens to the stream.
    return ref.watch(employeesRepositoryProvider).watchEmployees();
  }

  Future<void> addEmployee(EmployeesModel employee) async {
    // Just tell the database to insert. 
    // Drift automatically updates the Stream, so the UI updates instantly.
    await ref.read(employeesRepositoryProvider).insertEmployee(employee);
  }

  Future<void> updateEmployee(EmployeesModel updatedEmployee) async {
    await ref.read(employeesRepositoryProvider).updateEmployee(updatedEmployee);
  }

  Future<void> deleteEmployee(String id) async {
    await ref.read(employeesRepositoryProvider).deleteEmployee(id);
  }
}
