import 'package:drift/drift.dart';

class LoginCredentialsTable extends Table {
  TextColumn get id =>
      text().withDefault(const Constant('login_credentials'))();
  TextColumn get username => text()();
  TextColumn get passwordHash => text()();
  TextColumn get salt => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
