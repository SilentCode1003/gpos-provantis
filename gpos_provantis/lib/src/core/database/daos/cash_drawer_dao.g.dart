// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_drawer_dao.dart';

// ignore_for_file: type=lint
mixin _$CashDrawerDaoMixin on DatabaseAccessor<AppDatabase> {
  $CashDrawerTableTable get cashDrawerTable => attachedDatabase.cashDrawerTable;
  CashDrawerDaoManager get managers => CashDrawerDaoManager(this);
}

class CashDrawerDaoManager {
  final _$CashDrawerDaoMixin _db;
  CashDrawerDaoManager(this._db);
  $$CashDrawerTableTableTableManager get cashDrawerTable =>
      $$CashDrawerTableTableTableManager(
        _db.attachedDatabase,
        _db.cashDrawerTable,
      );
}
