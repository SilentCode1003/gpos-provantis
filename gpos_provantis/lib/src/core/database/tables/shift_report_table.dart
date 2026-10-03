import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class ShiftReportTable extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  /// `yyyy-MM-dd`.
  TextColumn get date => text()();
  IntColumn get pos => integer()();
  IntColumn get shift => integer()();

  TextColumn get cashier => text().withDefault(const Constant(''))();

  /// Kept as raw text because the server sends null here and its type isn't
  /// pinned down.
  TextColumn get floating => text().nullable()();
  RealColumn get cashFloat => real().nullable()();

  RealColumn get salesBeginning => real().withDefault(const Constant(0.0))();
  RealColumn get salesEnding => real().withDefault(const Constant(0.0))();
  RealColumn get totalSales => real().withDefault(const Constant(0.0))();

  IntColumn get receiptBeginning => integer().withDefault(const Constant(0))();
  IntColumn get receiptEnding => integer().withDefault(const Constant(0))();

  TextColumn get status => text().withDefault(const Constant(''))();
  TextColumn get approvedBy => text().nullable()();
  TextColumn get approvedDate => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  /// One row per shift per POS per day.
  @override
  List<Set<Column>> get uniqueKeys => [
    {date, pos, shift},
  ];
}
