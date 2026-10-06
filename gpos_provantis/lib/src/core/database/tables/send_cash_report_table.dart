import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// The end-of-shift cash count that is sent to the server as the "send cash report".
/// Saved on the device first, then sent; [syncStatus] tracks whether the
/// server has it yet.
class SendCashReportTable extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  TextColumn get branchId => text()();
  TextColumn get posId => text()();
  TextColumn get shift => text()();

  /// `yyyy-MM-dd`.
  TextColumn get shiftDate => text()();

  /// Employee id of the cashier (what the server expects as `cashier`).
  TextColumn get cashierId => text()();

  RealColumn get amount => real()();

  /// JSON array of `{id, value, quantity}` for every active denomination,
  /// including ones counted as zero.
  TextColumn get linesJson => text().withDefault(const Constant('[]'))();

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

  /// One send cash report per shift.
  @override
  List<Set<Column>> get uniqueKeys => [
    {branchId, posId, shiftDate, shift},
  ];
}