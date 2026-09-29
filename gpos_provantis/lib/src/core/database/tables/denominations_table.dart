import 'package:drift/drift.dart';

class DenominationsTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  TextColumn get code => text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get description =>
      text().withDefault(const Constant('UNREGISTERED'))();
  IntColumn get value => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get createdBy =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get createdDate =>
      text().withDefault(const Constant('UNREGISTERED'))();

  @override
  Set<Column> get primaryKey => {id};
}
