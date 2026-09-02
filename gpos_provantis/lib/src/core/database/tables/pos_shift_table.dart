import 'package:drift/drift.dart';

class PosShiftTable extends Table {
  TextColumn get posId => text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get date => text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get shift => text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get status => text().withDefault(const Constant('UNREGISTERED'))();

  @override
  Set<Column> get primaryKey => {posId};
}
