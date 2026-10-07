import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// A customer (individual or company) attached to a completed sale. Saved on
/// the device first, then sent to the server; [syncStatus] tracks whether the
/// server has it yet.
class CustomerTable extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  /// The sale's receipt (detail) id. The server links the customer to the sale
  /// with it, so a sale has at most one customer record.
  TextColumn get salesId => text()();
  TextColumn get posId => text()();

  /// "Individual" or "Company".
  TextColumn get type => text()();

  /// Company name. Empty for an individual.
  TextColumn get company => text().withDefault(const Constant(''))();

  /// The individual's full name, or the company's representative.
  TextColumn get fullName => text()();

  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant('N/A'))();
  TextColumn get mobile => text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();

  /// Kept on the device with the customer. The customer API has no field for
  /// it, so it is not sent.
  TextColumn get purchaseOrder => text().withDefault(const Constant(''))();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();

  /// PENDING until the server has accepted it, then SYNCED.
  TextColumn get syncStatus => text().withDefault(const Constant('PENDING'))();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  /// How many sends have failed, and why the last one did.
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {salesId},
  ];
}