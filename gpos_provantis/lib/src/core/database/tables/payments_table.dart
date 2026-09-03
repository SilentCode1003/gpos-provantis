import 'package:drift/drift.dart';

class PaymentsTable extends Table {
  IntColumn get paymentId => integer().withDefault(const Constant(0))();
  TextColumn get paymentName =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get status => text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get createdby =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get createddate =>
      text().withDefault(const Constant('UNREGISTERED'))();

  @override
  Set<Column> get primaryKey => {paymentId};
}
