// tables/user_data_table.dart
import 'package:drift/drift.dart';

class UserDataTable extends Table {
  TextColumn get id => text().withDefault(const Constant('user_data'))();
  TextColumn get employeeId =>
      text().withDefault(const Constant('INVALID USER'))();
  TextColumn get fullName =>
      text().withDefault(const Constant('INVALID USER'))();
  IntColumn get position => integer().withDefault(const Constant(0))();
  TextColumn get contactInfo =>
      text().withDefault(const Constant('INVALID USER'))();
  TextColumn get dateHired =>
      text().withDefault(const Constant('INVALID USER'))();
  IntColumn get userCode => integer().withDefault(const Constant(0))();
  IntColumn get accessType => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('INVALID USER'))();
  TextColumn get apk => text().withDefault(const Constant('INVALID USER'))();

  @override
  Set<Column> get primaryKey => {id};
}
