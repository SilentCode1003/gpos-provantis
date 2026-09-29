// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_config_dao.dart';

// ignore_for_file: type=lint
mixin _$PosConfigDaoMixin on DatabaseAccessor<AppDatabase> {
  $POSConfigTableTable get pOSConfigTable => attachedDatabase.pOSConfigTable;
  PosConfigDaoManager get managers => PosConfigDaoManager(this);
}

class PosConfigDaoManager {
  final _$PosConfigDaoMixin _db;
  PosConfigDaoManager(this._db);
  $$POSConfigTableTableTableManager get pOSConfigTable =>
      $$POSConfigTableTableTableManager(
        _db.attachedDatabase,
        _db.pOSConfigTable,
      );
}
