import 'package:drift/drift.dart';

class DiscountTable extends Table {
  IntColumn get discountId => integer().withDefault(const Constant(0))();
  TextColumn get name => text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get description =>
      text().withDefault(const Constant('UNREGISTERED'))();
  IntColumn get rate => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get createdBy =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get createdDate =>
      text().withDefault(const Constant('UNREGISTERED'))();

  @override
  Set<Column> get primaryKey => {discountId};
}
