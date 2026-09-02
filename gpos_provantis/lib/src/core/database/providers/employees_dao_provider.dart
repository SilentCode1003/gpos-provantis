import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/employees_dao.dart';

part 'employees_dao_provider.g.dart';

@Riverpod(keepAlive: true)
EmployeesDao employeesDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return EmployeesDao(db);
}

final employeesProvider =
    StreamNotifierProvider<EmployeesNotifier, List<EmployeesTableData>>(
      EmployeesNotifier.new,
    );

class EmployeesNotifier extends StreamNotifier<List<EmployeesTableData>> {
  @override
  Stream<List<EmployeesTableData>> build() {
    final dao = ref.watch(employeesDaoProvider);
    return dao.watchAllEmployees();
  }
}
