import 'package:drift/drift.dart';

class PromoTable extends Table {
  IntColumn get promoId => integer().withDefault(const Constant(0))();
  TextColumn get name => text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get description =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get condition =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get startDate =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get endDate =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get status => text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get createdBy =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get createdDate =>
      text().withDefault(const Constant('UNREGISTERED'))();

  @override
  Set<Column> get primaryKey => {promoId};
}
