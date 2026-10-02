import 'package:drift/drift.dart';

class AddonTable extends Table {
  /// The server's own addon id (not a local UUID), so the same addon always
  /// maps to the same row.
  IntColumn get id => integer()();

  TextColumn get name => text().withDefault(const Constant(''))();

  /// The addon type's name, e.g. what the server joins from `addon_type`.
  TextColumn get addonType => text().withDefault(const Constant(''))();

  RealColumn get price => real().withDefault(const Constant(0.0))();
  BoolColumn get isProduct => boolean().withDefault(const Constant(false))();
  TextColumn get status => text().withDefault(const Constant('ACTIVE'))();
  TextColumn get createdBy => text().withDefault(const Constant(''))();

  /// Kept exactly as the server sends it.
  TextColumn get createdDate => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}
