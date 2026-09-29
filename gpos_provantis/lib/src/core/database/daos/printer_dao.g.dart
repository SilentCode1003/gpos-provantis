// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer_dao.dart';

// ignore_for_file: type=lint
mixin _$PrinterDaoMixin on DatabaseAccessor<AppDatabase> {
  $PrintersTableTable get printersTable => attachedDatabase.printersTable;
  PrinterDaoManager get managers => PrinterDaoManager(this);
}

class PrinterDaoManager {
  final _$PrinterDaoMixin _db;
  PrinterDaoManager(this._db);
  $$PrintersTableTableTableManager get printersTable =>
      $$PrintersTableTableTableManager(_db.attachedDatabase, _db.printersTable);
}
