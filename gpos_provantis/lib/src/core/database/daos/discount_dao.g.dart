// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount_dao.dart';

// ignore_for_file: type=lint
mixin _$DiscountDaoMixin on DatabaseAccessor<AppDatabase> {
  $DiscountTableTable get discountTable => attachedDatabase.discountTable;
  DiscountDaoManager get managers => DiscountDaoManager(this);
}

class DiscountDaoManager {
  final _$DiscountDaoMixin _db;
  DiscountDaoManager(this._db);
  $$DiscountTableTableTableManager get discountTable =>
      $$DiscountTableTableTableManager(_db.attachedDatabase, _db.discountTable);
}
