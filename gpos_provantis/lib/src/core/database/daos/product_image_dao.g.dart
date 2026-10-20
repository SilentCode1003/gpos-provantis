// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_image_dao.dart';

// ignore_for_file: type=lint
mixin _$ProductImageDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProductImageTableTable get productImageTable =>
      attachedDatabase.productImageTable;
  ProductImageDaoManager get managers => ProductImageDaoManager(this);
}

class ProductImageDaoManager {
  final _$ProductImageDaoMixin _db;
  ProductImageDaoManager(this._db);
  $$ProductImageTableTableTableManager get productImageTable =>
      $$ProductImageTableTableTableManager(
        _db.attachedDatabase,
        _db.productImageTable,
      );
}
