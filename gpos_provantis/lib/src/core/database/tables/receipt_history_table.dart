import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// Receipts pulled from the server, kept as a local cache so older receipts can
/// be previewed and reprinted. Isolated from the live sales table on purpose.
class ReceiptHistoryTable extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  TextColumn get detailId => text()();
  IntColumn get posId => integer()();
  IntColumn get shift => integer().withDefault(const Constant(0))();

  /// `yyyy-MM-dd`, for looking a day up directly.
  TextColumn get receiptDate => text()();
  DateTimeColumn get createdAt => dateTime()();

  TextColumn get paymentType => text().withDefault(const Constant(''))();

  /// Raw JSON array of the receipt's items.
  TextColumn get description => text().withDefault(const Constant('[]'))();
  RealColumn get total => real().withDefault(const Constant(0.0))();
  TextColumn get cashier => text().withDefault(const Constant(''))();
  TextColumn get status => text().withDefault(const Constant(''))();
  TextColumn get ePaymentType => text().withDefault(const Constant(''))();
  TextColumn get referenceId => text().withDefault(const Constant(''))();

  /// JSON array of `{type, amount}`, one per payment taken.
  TextColumn get tendersJson => text().withDefault(const Constant('[]'))();

  /// When this copy was pulled; the cache is pruned by this.
  DateTimeColumn get fetchedAt =>
      dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {detailId, posId},
  ];
}
