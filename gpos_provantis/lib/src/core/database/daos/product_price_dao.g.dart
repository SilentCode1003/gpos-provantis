// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_price_dao.dart';

// ignore_for_file: type=lint
mixin _$ProductPriceDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProductPriceTableTable get productPriceTable =>
      attachedDatabase.productPriceTable;
  ProductPriceDaoManager get managers => ProductPriceDaoManager(this);
}

class ProductPriceDaoManager {
  final _$ProductPriceDaoMixin _db;
  ProductPriceDaoManager(this._db);
  $$ProductPriceTableTableTableManager get productPriceTable =>
      $$ProductPriceTableTableTableManager(
        _db.attachedDatabase,
        _db.productPriceTable,
      );
}
