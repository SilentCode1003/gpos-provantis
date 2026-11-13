// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_log_dao.dart';

// ignore_for_file: type=lint
mixin _$AppLogDaoMixin on DatabaseAccessor<AppDatabase> {
  $AppLogTableTable get appLogTable => attachedDatabase.appLogTable;
  AppLogDaoManager get managers => AppLogDaoManager(this);
}

class AppLogDaoManager {
  final _$AppLogDaoMixin _db;
  AppLogDaoManager(this._db);
  $$AppLogTableTableTableManager get appLogTable =>
      $$AppLogTableTableTableManager(_db.attachedDatabase, _db.appLogTable);
}
