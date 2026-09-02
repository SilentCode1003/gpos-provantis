import 'package:drift/drift.dart';

class PaymentsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get paymentName =>
      text().withDefault(const Constant('UNREGISTERED'))();

  @override
  Set<Column> get primaryKey => {id};
}
