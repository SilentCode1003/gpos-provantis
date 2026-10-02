import 'package:drift/drift.dart';

class ServicePackageTable extends Table {
  /// The server's own package id (not a local UUID), so the same package
  /// always maps to the same row.
  IntColumn get id => integer()();

  TextColumn get name => text().withDefault(const Constant(''))();
  RealColumn get price => real().withDefault(const Constant(0.0))();
  IntColumn get quantity => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
