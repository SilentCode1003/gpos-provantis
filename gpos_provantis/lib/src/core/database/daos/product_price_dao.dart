import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/product_price_table.dart';

part 'product_price_dao.g.dart';

@DriftAccessor(tables: [ProductPriceTable])
class ProductPriceDao extends DatabaseAccessor<AppDatabase>
    with _$ProductPriceDaoMixin {
  ProductPriceDao(super.db);

  Future<void> saveProductPrice(ProductPriceTableData data) {
    return into(productPriceTable).insert(data);
  }

  Future<void> replaceProductPrices(List<ProductPriceTableCompanion> data) {
    return transaction(() async {
      await delete(productPriceTable).go();
      await batch((batch) {
        batch.insertAll(productPriceTable, data);
      });
    });
  }

  Future<List<ProductPriceTableData>> getAllProductPrices() {
    return select(productPriceTable).get();
  }

  Stream<List<ProductPriceTableData>> watchAllProductPrices() {
    return select(productPriceTable).watch();
  }
}
