import 'package:drift/drift.dart';

/// Where a product's image is in its life cycle.
class ProductImageStatus {
  ProductImageStatus._();

  /// Image saved on the device; [ProductImageTable.filePath] points to it.
  static const downloaded = 'downloaded';

  /// The server was asked and has no image for this product. Remembered so we
  /// don't ask again on every sync.
  static const none = 'none';

  /// The last attempt failed (bad data, server error). Retried next time.
  static const failed = 'failed';
}

/// One row per product. Holds only METADATA: the image itself lives as a file
/// on disk, so there is no base64 in the database and nothing to decode when
/// the UI loads it.
class ProductImageTable extends Table {
  IntColumn get productId => integer()();
  TextColumn get filePath => text().nullable()();
  TextColumn get status =>
      text().withDefault(const Constant(ProductImageStatus.failed))();
  DateTimeColumn get fetchedAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column> get primaryKey => {productId};
}