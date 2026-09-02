import 'package:drift/drift.dart';

class ProductPriceTable extends Table {
  IntColumn get productId => integer().withDefault(const Constant(0))();
  TextColumn get description =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get barcode =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get price => text().withDefault(const Constant('UNREGISTERED'))();
  IntColumn get category => integer().withDefault(const Constant(0))();
  IntColumn get quantity => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {productId};
}
