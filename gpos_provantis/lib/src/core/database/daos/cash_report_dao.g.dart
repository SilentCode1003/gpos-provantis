// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_report_dao.dart';

// ignore_for_file: type=lint
mixin _$CashReportDaoMixin on DatabaseAccessor<AppDatabase> {
  $CashReportTableTable get cashReportTable => attachedDatabase.cashReportTable;
  CashReportDaoManager get managers => CashReportDaoManager(this);
}

class CashReportDaoManager {
  final _$CashReportDaoMixin _db;
  CashReportDaoManager(this._db);
  $$CashReportTableTableTableManager get cashReportTable =>
      $$CashReportTableTableTableManager(
        _db.attachedDatabase,
        _db.cashReportTable,
      );
}
