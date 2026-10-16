import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/product_price_table.dart';

part 'product_price_dao.g.dart';

@DriftAccessor(tables: [ProductPriceTable])
class ProductPriceDao extends DatabaseAccessor<AppDatabase>
    with _$ProductPriceDaoMixin {
  ProductPriceDao(super.db);

  // Saves a product price row in local storage.
  // Keeps the current pricing data ready for retail reads.
  Future<void> saveProductPrice(ProductPriceTableData data) {
    return into(productPriceTable).insert(data);
  }

  // Replaces the cached product price list with a fresh snapshot.
  // Used to refresh the local pricing catalog after sync.
  Future<void> replaceProductPrices(List<ProductPriceTableCompanion> data) {
    return transaction(() async {
      await delete(productPriceTable).go();
      await batch((batch) {
        batch.insertAll(productPriceTable, data);
      });
    });
  }

  // Reads all product prices from local storage.
  // Returns the current pricing cache for the device.
  Future<List<ProductPriceTableData>> getAllProductPrices() {
    return select(productPriceTable).get();
  }

  // Watches the product price list for live updates.
  // Useful for screens that need current pricing values immediately.
  Stream<List<ProductPriceTableData>> watchAllProductPrices() {
    return select(productPriceTable).watch();
  }
}
