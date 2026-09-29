// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data_dao.dart';

// ignore_for_file: type=lint
mixin _$UserDataDaoMixin on DatabaseAccessor<AppDatabase> {
  $UserDataTableTable get userDataTable => attachedDatabase.userDataTable;
  UserDataDaoManager get managers => UserDataDaoManager(this);
}

class UserDataDaoManager {
  final _$UserDataDaoMixin _db;
  UserDataDaoManager(this._db);
  $$UserDataTableTableTableManager get userDataTable =>
      $$UserDataTableTableTableManager(_db.attachedDatabase, _db.userDataTable);
}
