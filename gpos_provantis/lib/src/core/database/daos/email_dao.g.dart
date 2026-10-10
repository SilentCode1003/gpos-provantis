// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_dao.dart';

// ignore_for_file: type=lint
mixin _$EmailDaoMixin on DatabaseAccessor<AppDatabase> {
  $EmailTableTable get emailTable => attachedDatabase.emailTable;
  EmailDaoManager get managers => EmailDaoManager(this);
}

class EmailDaoManager {
  final _$EmailDaoMixin _db;
  EmailDaoManager(this._db);
  $$EmailTableTableTableManager get emailTable =>
      $$EmailTableTableTableManager(_db.attachedDatabase, _db.emailTable);
}
