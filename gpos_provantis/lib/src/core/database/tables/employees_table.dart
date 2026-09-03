import 'package:drift/drift.dart';

class EmployeesTable extends Table {
  IntColumn get employeeId => integer().withDefault(const Constant(0))();
  TextColumn get fullName =>
      text().withDefault(const Constant('UNREGISTERED'))();
  IntColumn get position => integer().withDefault(const Constant(0))();
  TextColumn get contactInfo =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get dateHired =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get status => text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get createdBy =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get createdDate =>
      text().withDefault(const Constant('UNREGISTERED'))();

  @override
  Set<Column> get primaryKey => {employeeId};
}
