// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_summary_report_dao.dart';

// ignore_for_file: type=lint
mixin _$PaymentSummaryReportDaoMixin on DatabaseAccessor<AppDatabase> {
  $PaymentSummaryReportTableTable get paymentSummaryReportTable =>
      attachedDatabase.paymentSummaryReportTable;
  PaymentSummaryReportDaoManager get managers =>
      PaymentSummaryReportDaoManager(this);
}

class PaymentSummaryReportDaoManager {
  final _$PaymentSummaryReportDaoMixin _db;
  PaymentSummaryReportDaoManager(this._db);
  $$PaymentSummaryReportTableTableTableManager get paymentSummaryReportTable =>
      $$PaymentSummaryReportTableTableTableManager(
        _db.attachedDatabase,
        _db.paymentSummaryReportTable,
      );
}
