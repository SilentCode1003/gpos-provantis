// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_detail_id_dao.dart';

// ignore_for_file: type=lint
mixin _$PosDetailIdDaoMixin on DatabaseAccessor<AppDatabase> {
  $PosDetailIdTableTable get posDetailIdTable =>
      attachedDatabase.posDetailIdTable;
  PosDetailIdDaoManager get managers => PosDetailIdDaoManager(this);
}

class PosDetailIdDaoManager {
  final _$PosDetailIdDaoMixin _db;
  PosDetailIdDaoManager(this._db);
  $$PosDetailIdTableTableTableManager get posDetailIdTable =>
      $$PosDetailIdTableTableTableManager(
        _db.attachedDatabase,
        _db.posDetailIdTable,
      );
}
