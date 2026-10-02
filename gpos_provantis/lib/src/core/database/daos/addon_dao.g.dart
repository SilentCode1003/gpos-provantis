// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addon_dao.dart';

// ignore_for_file: type=lint
mixin _$AddonDaoMixin on DatabaseAccessor<AppDatabase> {
  $AddonTableTable get addonTable => attachedDatabase.addonTable;
  AddonDaoManager get managers => AddonDaoManager(this);
}

class AddonDaoManager {
  final _$AddonDaoMixin _db;
  AddonDaoManager(this._db);
  $$AddonTableTableTableManager get addonTable =>
      $$AddonTableTableTableManager(_db.attachedDatabase, _db.addonTable);
}
