// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_purchase_order_dao.dart';

// ignore_for_file: type=lint
mixin _$SalesPurchaseOrderDaoMixin on DatabaseAccessor<AppDatabase> {
  $SalesPurchaseOrderTableTable get salesPurchaseOrderTable =>
      attachedDatabase.salesPurchaseOrderTable;
  SalesPurchaseOrderDaoManager get managers =>
      SalesPurchaseOrderDaoManager(this);
}

class SalesPurchaseOrderDaoManager {
  final _$SalesPurchaseOrderDaoMixin _db;
  SalesPurchaseOrderDaoManager(this._db);
  $$SalesPurchaseOrderTableTableTableManager get salesPurchaseOrderTable =>
      $$SalesPurchaseOrderTableTableTableManager(
        _db.attachedDatabase,
        _db.salesPurchaseOrderTable,
      );
}
