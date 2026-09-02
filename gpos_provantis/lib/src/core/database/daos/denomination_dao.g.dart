// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'denomination_dao.dart';

// ignore_for_file: type=lint
mixin _$DenominationDaoMixin on DatabaseAccessor<AppDatabase> {
  $DenominationTableTable get denominationTable =>
      attachedDatabase.denominationTable;
  DenominationDaoManager get managers => DenominationDaoManager(this);
}

class DenominationDaoManager {
  final _$DenominationDaoMixin _db;
  DenominationDaoManager(this._db);
  $$DenominationTableTableTableManager get denominationTable =>
      $$DenominationTableTableTableManager(
        _db.attachedDatabase,
        _db.denominationTable,
      );
}
