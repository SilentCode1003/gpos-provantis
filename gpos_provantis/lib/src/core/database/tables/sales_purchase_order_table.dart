import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// The purchase order number a customer gave for a sale. Saved on the device
/// first, then sent to the server, but only after the sale and the customer
/// are already there. [syncStatus] tracks whether the server has it yet.
class SalesPurchaseOrderTable extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  /// The sale's receipt (OR) number. A sale has at most one purchase order.
  TextColumn get salesId => text()();

  /// What the cashier typed in the customer prompt.
  TextColumn get purchaseOrderId => text()();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();

  /// PENDING until the server has accepted it, then SYNCED.
  TextColumn get syncStatus => text().withDefault(const Constant('PENDING'))();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  /// How many sends have failed, and why the last one did. Waiting for the sale
  /// or customer to reach the server is not a failure and isn't counted.
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {salesId},
  ];
}
