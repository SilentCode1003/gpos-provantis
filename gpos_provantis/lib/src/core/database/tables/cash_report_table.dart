import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// Cash reports pulled from the server, one row per shift per day, kept as a
/// local copy so a day can still be viewed offline.
class CashReportTable extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  TextColumn get branchId => text()();
  TextColumn get posId => text()();
  IntColumn get shift => integer()();

  /// `yyyy-MM-dd`.
  TextColumn get shiftDate => text()();

  RealColumn get cashFloat => real().withDefault(const Constant(0.0))();
  RealColumn get totalCash => real().withDefault(const Constant(0.0))();

  /// JSON array of `{id, value, quantity}` for every active denomination,
  /// including ones counted as zero.
  TextColumn get denominationJson =>
      text().withDefault(const Constant('[]'))();

  /// When this copy was pulled.
  DateTimeColumn get fetchedAt =>
      dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};

  /// One report per shift per POS per day.
  @override
  List<Set<Column>> get uniqueKeys => [
    {branchId, posId, shiftDate, shift},
  ];
}