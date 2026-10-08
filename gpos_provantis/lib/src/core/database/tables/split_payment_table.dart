import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// A sale paid with two payments (e.g. GCASH + BANK TRANSFER). Saved on the
/// device first, then sent to the server; [syncStatus] tracks whether the
/// server has it yet. Each column mirrors a field of the request body.
class SplitPaymentTable extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  /// The sale's receipt (detail) id. The server rejects a repeat of it, so a
  /// sale has at most one row here.
  TextColumn get detailId => text()();

  /// `yyyy-MM-dd HH:mm`.
  TextColumn get date => text()();
  TextColumn get posId => text()();
  TextColumn get shift => text()();

  /// The sale's items, as the JSON string the server stores.
  TextColumn get items => text()();

  /// The cashier's name.
  TextColumn get staff => text()();
  TextColumn get branchId => text()();

  TextColumn get firstPaymentType => text()();
  RealColumn get firstPayment => real()();
  TextColumn get firstPaymentReference =>
      text().withDefault(const Constant(''))();

  TextColumn get secondPaymentType => text()();
  RealColumn get secondPayment => real()();
  TextColumn get secondPaymentReference =>
      text().withDefault(const Constant(''))();

  /// JSON array; "[]" when there is no discount.
  TextColumn get discountDetails => text().withDefault(const Constant('[]'))();

  RealColumn get total => real()();

  /// "E2E" for two e-payments.
  TextColumn get paymentType => text().withDefault(const Constant('E2E'))();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();

  /// PENDING until the server has the sale, then SYNCED.
  TextColumn get syncStatus => text().withDefault(const Constant('PENDING'))();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  /// How many sends have failed, and why the last one did.
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {detailId},
  ];
}
