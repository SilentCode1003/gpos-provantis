// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_config_dao.dart';

// ignore_for_file: type=lint
mixin _$BranchConfigDaoMixin on DatabaseAccessor<AppDatabase> {
  $BranchConfigTableTable get branchConfigTable =>
      attachedDatabase.branchConfigTable;
  BranchConfigDaoManager get managers => BranchConfigDaoManager(this);
}

class BranchConfigDaoManager {
  final _$BranchConfigDaoMixin _db;
  BranchConfigDaoManager(this._db);
  $$BranchConfigTableTableTableManager get branchConfigTable =>
      $$BranchConfigTableTableTableManager(
        _db.attachedDatabase,
        _db.branchConfigTable,
      );
}
