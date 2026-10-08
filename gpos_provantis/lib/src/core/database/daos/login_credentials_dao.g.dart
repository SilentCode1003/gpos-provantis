// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_credentials_dao.dart';

// ignore_for_file: type=lint
mixin _$LoginCredentialsDaoMixin on DatabaseAccessor<AppDatabase> {
  $LoginCredentialsTableTable get loginCredentialsTable =>
      attachedDatabase.loginCredentialsTable;
  LoginCredentialsDaoManager get managers => LoginCredentialsDaoManager(this);
}

class LoginCredentialsDaoManager {
  final _$LoginCredentialsDaoMixin _db;
  LoginCredentialsDaoManager(this._db);
  $$LoginCredentialsTableTableTableManager get loginCredentialsTable =>
      $$LoginCredentialsTableTableTableManager(
        _db.attachedDatabase,
        _db.loginCredentialsTable,
      );
}
