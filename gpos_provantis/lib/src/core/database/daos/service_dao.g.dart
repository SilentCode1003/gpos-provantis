// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_dao.dart';

// ignore_for_file: type=lint
mixin _$ServiceDaoMixin on DatabaseAccessor<AppDatabase> {
  $ServiceTableTable get serviceTable => attachedDatabase.serviceTable;
  ServiceDaoManager get managers => ServiceDaoManager(this);
}

class ServiceDaoManager {
  final _$ServiceDaoMixin _db;
  ServiceDaoManager(this._db);
  $$ServiceTableTableTableManager get serviceTable =>
      $$ServiceTableTableTableManager(_db.attachedDatabase, _db.serviceTable);
}
