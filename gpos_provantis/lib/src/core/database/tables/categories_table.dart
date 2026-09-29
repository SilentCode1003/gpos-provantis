import 'package:drift/drift.dart';

class CategoriesTable extends Table {
  IntColumn get categoryCode => integer().withDefault(const Constant(0))();
  TextColumn get categoryName =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get status => text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get createdBy =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get createdDate =>
      text().withDefault(const Constant('UNREGISTERED'))();
  IntColumn get isDisplay => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {categoryCode};
}
