// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_sales_report_dao.dart';

// ignore_for_file: type=lint
mixin _$StaffSalesReportDaoMixin on DatabaseAccessor<AppDatabase> {
  $StaffSalesReportTableTable get staffSalesReportTable =>
      attachedDatabase.staffSalesReportTable;
  StaffSalesReportDaoManager get managers => StaffSalesReportDaoManager(this);
}

class StaffSalesReportDaoManager {
  final _$StaffSalesReportDaoMixin _db;
  StaffSalesReportDaoManager(this._db);
  $$StaffSalesReportTableTableTableManager get staffSalesReportTable =>
      $$StaffSalesReportTableTableTableManager(
        _db.attachedDatabase,
        _db.staffSalesReportTable,
      );
}
