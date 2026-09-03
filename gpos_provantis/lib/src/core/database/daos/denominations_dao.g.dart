// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'denominations_dao.dart';

// ignore_for_file: type=lint
mixin _$DenominationsDaoMixin on DatabaseAccessor<AppDatabase> {
  $DenominationsTableTable get denominationsTable =>
      attachedDatabase.denominationsTable;
  DenominationsDaoManager get managers => DenominationsDaoManager(this);
}

class DenominationsDaoManager {
  final _$DenominationsDaoMixin _db;
  DenominationsDaoManager(this._db);
  $$DenominationsTableTableTableManager get denominationsTable =>
      $$DenominationsTableTableTableManager(
        _db.attachedDatabase,
        _db.denominationsTable,
      );
}
