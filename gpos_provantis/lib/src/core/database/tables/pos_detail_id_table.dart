import 'package:drift/drift.dart';

class PosDetailIdTable extends Table {
  TextColumn get id => text().withDefault(const Constant('pos_detail_id'))();
  TextColumn get posDetailId =>
      text().withDefault(const Constant('UNREGISTERED'))();

  @override
  Set<Column> get primaryKey => {id};
}
