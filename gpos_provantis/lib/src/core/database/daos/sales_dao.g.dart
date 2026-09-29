// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_dao.dart';

// ignore_for_file: type=lint
mixin _$SalesDaoMixin on DatabaseAccessor<AppDatabase> {
  $SalesTableTable get salesTable => attachedDatabase.salesTable;
  SalesDaoManager get managers => SalesDaoManager(this);
}

class SalesDaoManager {
  final _$SalesDaoMixin _db;
  SalesDaoManager(this._db);
  $$SalesTableTableTableManager get salesTable =>
      $$SalesTableTableTableManager(_db.attachedDatabase, _db.salesTable);
}
