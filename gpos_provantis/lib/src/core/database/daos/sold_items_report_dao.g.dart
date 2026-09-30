// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sold_items_report_dao.dart';

// ignore_for_file: type=lint
mixin _$SoldItemsReportDaoMixin on DatabaseAccessor<AppDatabase> {
  $SoldItemsReportTableTable get soldItemsReportTable =>
      attachedDatabase.soldItemsReportTable;
  SoldItemsReportDaoManager get managers => SoldItemsReportDaoManager(this);
}

class SoldItemsReportDaoManager {
  final _$SoldItemsReportDaoMixin _db;
  SoldItemsReportDaoManager(this._db);
  $$SoldItemsReportTableTableTableManager get soldItemsReportTable =>
      $$SoldItemsReportTableTableTableManager(
        _db.attachedDatabase,
        _db.soldItemsReportTable,
      );
}
