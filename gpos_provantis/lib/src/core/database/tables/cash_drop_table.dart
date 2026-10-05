import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// Cash removed from the drawer during a shift. Saved on the device first so a
/// drop is never lost; [syncStatus] tracks whether the server has it yet.
class CashDropTable extends Table {
  /// Generated here, so the same drop can later be sent to the server safely.
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  TextColumn get branchId => text()();
  TextColumn get posId => text()();
  TextColumn get shift => text()();

  /// The shift's business date, `yyyy-MM-dd`.
  TextColumn get shiftDate => text()();

  /// Employee id of the cashier (what the server keys on).
  TextColumn get cashierId => text()();
  TextColumn get cashierName => text()();

  RealColumn get amount => real()();

  /// JSON array of `{id, label, value, quantity}`, only the denominations that
  /// were actually dropped.
  TextColumn get linesJson => text().withDefault(const Constant('[]'))();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();

  /// PENDING until the server has acknowledged it, then SYNCED.
  TextColumn get syncStatus => text().withDefault(const Constant('PENDING'))();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
