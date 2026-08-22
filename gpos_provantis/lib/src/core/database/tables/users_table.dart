import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../utils/date_time_converter.dart';

class UsersTable extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  TextColumn get empId => text()(); // primary key ID from Employees table
  TextColumn get username => text()();
  TextColumn get password => text()();
  TextColumn get createdBy => text()();
  TextColumn get updatedBy => text()();

  // Use TextColumn with the converter for ISO 8601 "Z" strings
  TextColumn get createdAt => text()
      .map(const IsoDateTimeConverter())
      .clientDefault(() => DateTime.now().toUtc().toIso8601String())();
  TextColumn get updatedAt => text()
      .map(const IsoDateTimeConverter())
      .clientDefault(() => DateTime.now().toUtc().toIso8601String())();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
