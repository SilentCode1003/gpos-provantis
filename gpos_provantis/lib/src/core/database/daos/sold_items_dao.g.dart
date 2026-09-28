// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sold_items_dao.dart';

// ignore_for_file: type=lint
mixin _$SoldItemsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SoldItemsTableTable get soldItemsTable => attachedDatabase.soldItemsTable;
  SoldItemsDaoManager get managers => SoldItemsDaoManager(this);
}

class SoldItemsDaoManager {
  final _$SoldItemsDaoMixin _db;
  SoldItemsDaoManager(this._db);
  $$SoldItemsTableTableTableManager get soldItemsTable =>
      $$SoldItemsTableTableTableManager(
        _db.attachedDatabase,
        _db.soldItemsTable,
      );
}
