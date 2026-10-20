import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/product_image_table.dart';

part 'product_image_dao.g.dart';

@DriftAccessor(tables: [ProductImageTable])
class ProductImageDao extends DatabaseAccessor<AppDatabase>
    with _$ProductImageDaoMixin {
  ProductImageDao(super.db);

  // Inserts or updates the image record of one product. Columns left absent in
  // [row] keep their current value.
  Future<void> upsert(ProductImageTableCompanion row) {
    return into(productImageTable).insertOnConflictUpdate(row);
  }

  // Reads the image record of one product, or null if never fetched.
  Future<ProductImageTableData?> getByProductId(int productId) {
    return (select(
      productImageTable,
    )..where((t) => t.productId.equals(productId))).getSingleOrNull();
  }

  // Reads every image record.
  Future<List<ProductImageTableData>> getAll() {
    return select(productImageTable).get();
  }

  // Watches every image record.
  Stream<List<ProductImageTableData>> watchAll() {
    return select(productImageTable).watch();
  }

  // Watches one product's record (null until it has one).
  Stream<ProductImageTableData?> watchByProductId(int productId) {
    return (select(
      productImageTable,
    )..where((t) => t.productId.equals(productId))).watchSingleOrNull();
  }

  // Watches productId -> file path for every downloaded image. This is what
  // the UI reads to show pictures.
  Stream<Map<int, String>> watchDownloadedPaths() {
    final query = select(productImageTable)
      ..where(
        (t) => t.status.equals('downloaded') & t.filePath.isNotNull(),
      );
    return query.watch().map(
      (rows) => {for (final r in rows) r.productId: r.filePath!},
    );
  }

  // Removes one product's record.
  Future<int> deleteByProductId(int productId) {
    return (delete(
      productImageTable,
    )..where((t) => t.productId.equals(productId))).go();
  }

  // Removes every record.
  Future<int> deleteAll() => delete(productImageTable).go();
}