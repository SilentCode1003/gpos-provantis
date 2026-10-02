// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_package_dao.dart';

// ignore_for_file: type=lint
mixin _$ServicePackageDaoMixin on DatabaseAccessor<AppDatabase> {
  $ServicePackageTableTable get servicePackageTable =>
      attachedDatabase.servicePackageTable;
  ServicePackageDaoManager get managers => ServicePackageDaoManager(this);
}

class ServicePackageDaoManager {
  final _$ServicePackageDaoMixin _db;
  ServicePackageDaoManager(this._db);
  $$ServicePackageTableTableTableManager get servicePackageTable =>
      $$ServicePackageTableTableTableManager(
        _db.attachedDatabase,
        _db.servicePackageTable,
      );
}
