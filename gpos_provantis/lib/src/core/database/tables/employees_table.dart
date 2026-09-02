import 'package:drift/drift.dart';

class EmployeesTable extends Table {
  // Add autoincrement id
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fullName =>
      text().withDefault(const Constant('UNREGISTERED'))();

  @override
  Set<Column> get primaryKey => {id};
}
