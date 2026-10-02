import 'package:drift/drift.dart';

class ServiceTable extends Table {
  /// The server's own service id (not a local UUID), so the same service always
  /// maps to the same row.
  IntColumn get id => integer()();

  TextColumn get name => text().withDefault(const Constant(''))();
  RealColumn get price => real().withDefault(const Constant(0.0))();
  TextColumn get status => text().withDefault(const Constant('ACTIVE'))();
  TextColumn get createdBy => text().withDefault(const Constant(''))();

  /// Kept exactly as the server sends it, e.g. "2026-08-24 11:01".
  TextColumn get createdDate => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}