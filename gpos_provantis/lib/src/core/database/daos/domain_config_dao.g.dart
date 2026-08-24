// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'domain_config_dao.dart';

// ignore_for_file: type=lint
mixin _$DomainConfigDaoMixin on DatabaseAccessor<AppDatabase> {
  $DomainConfigTableTable get domainConfigTable =>
      attachedDatabase.domainConfigTable;
  DomainConfigDaoManager get managers => DomainConfigDaoManager(this);
}

class DomainConfigDaoManager {
  final _$DomainConfigDaoMixin _db;
  DomainConfigDaoManager(this._db);
  $$DomainConfigTableTableTableManager get domainConfigTable =>
      $$DomainConfigTableTableTableManager(
        _db.attachedDatabase,
        _db.domainConfigTable,
      );
}
