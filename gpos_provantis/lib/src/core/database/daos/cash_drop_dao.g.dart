// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_drop_dao.dart';

// ignore_for_file: type=lint
mixin _$CashDropDaoMixin on DatabaseAccessor<AppDatabase> {
  $CashDropTableTable get cashDropTable => attachedDatabase.cashDropTable;
  CashDropDaoManager get managers => CashDropDaoManager(this);
}

class CashDropDaoManager {
  final _$CashDropDaoMixin _db;
  CashDropDaoManager(this._db);
  $$CashDropTableTableTableManager get cashDropTable =>
      $$CashDropTableTableTableManager(_db.attachedDatabase, _db.cashDropTable);
}
