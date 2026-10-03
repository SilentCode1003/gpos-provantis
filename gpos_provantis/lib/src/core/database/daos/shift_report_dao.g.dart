// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_report_dao.dart';

// ignore_for_file: type=lint
mixin _$ShiftReportDaoMixin on DatabaseAccessor<AppDatabase> {
  $ShiftReportTableTable get shiftReportTable =>
      attachedDatabase.shiftReportTable;
  ShiftReportDaoManager get managers => ShiftReportDaoManager(this);
}

class ShiftReportDaoManager {
  final _$ShiftReportDaoMixin _db;
  ShiftReportDaoManager(this._db);
  $$ShiftReportTableTableTableManager get shiftReportTable =>
      $$ShiftReportTableTableTableManager(
        _db.attachedDatabase,
        _db.shiftReportTable,
      );
}
