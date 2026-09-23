import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class SalesTable extends Table {
  TextColumn get id => text().clientDefault(
    () => Uuid().v4(),
  )(); //Uuid generated for primary key
  DateTimeColumn get createdAt => dateTime().withDefault(
    currentDateAndTime,
  )(); //DateTime generated for referencing when the row was created during sync for sequencial upload.
  TextColumn get detailId => text().withDefault(
    const Constant('UNREGISTERED'),
  )(); //ID used by the server
  TextColumn get date => text().withDefault(
    const Constant('UNREGISTERED'),
  )(); // Date used by the server
  TextColumn get posid => text().withDefault(
    const Constant('UNREGISTERED'),
  )(); // POS ID used by the server
  TextColumn get shift => text().withDefault(
    const Constant('UNREGISTERED'),
  )(); // Shift used by the server
  TextColumn get paymentType => text().withDefault(
    const Constant('UNREGISTERED'),
  )(); // Payment type used by the server
  TextColumn get referenceId => text().withDefault(
    const Constant('UNREGISTERED'),
  )(); // Reference ID used by the server
  TextColumn get paymentName => text().withDefault(
    const Constant('UNREGISTERED'),
  )(); // Payment Name used by the server
  TextColumn get items => text().withDefault(
    const Constant('UNREGISTERED'),
  )(); // Items used by the server
  TextColumn get total => text().withDefault(
    const Constant('UNREGISTERED'),
  )(); // Total used by the server
  TextColumn get cashier => text().withDefault(
    const Constant('UNREGISTERED'),
  )(); // Cashier used by the server
  TextColumn get cash => text().withDefault(
    const Constant('UNREGISTERED'),
  )(); // Cash used by the server
  TextColumn get ecash => text().withDefault(
    const Constant('UNREGISTERED'),
  )(); // ECash used by the server
  TextColumn get branch => text().withDefault(
    const Constant('UNREGISTERED'),
  )(); // Branch used by the server
  TextColumn get discountDetail => text().withDefault(
    const Constant('UNREGISTERED'),
  )(); // Discount detail used by the server
  TextColumn get isSync => text().withDefault(
    const Constant('UNREGISTERED'),
  )(); // Is sync used by the server

  @override
  Set<Column> get primaryKey => {id};
}
