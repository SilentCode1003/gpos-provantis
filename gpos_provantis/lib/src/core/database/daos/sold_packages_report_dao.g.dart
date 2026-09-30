// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sold_packages_report_dao.dart';

// ignore_for_file: type=lint
mixin _$SoldPackagesReportDaoMixin on DatabaseAccessor<AppDatabase> {
  $SoldPackagesReportTableTable get soldPackagesReportTable =>
      attachedDatabase.soldPackagesReportTable;
  SoldPackagesReportDaoManager get managers =>
      SoldPackagesReportDaoManager(this);
}

class SoldPackagesReportDaoManager {
  final _$SoldPackagesReportDaoMixin _db;
  SoldPackagesReportDaoManager(this._db);
  $$SoldPackagesReportTableTableTableManager get soldPackagesReportTable =>
      $$SoldPackagesReportTableTableTableManager(
        _db.attachedDatabase,
        _db.soldPackagesReportTable,
      );
}
