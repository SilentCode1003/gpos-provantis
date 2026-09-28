import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class EndShiftTable extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get date => text()();
  IntColumn get pos => integer()();
  IntColumn get shift => integer()();
  TextColumn get cashier => text()();
  TextColumn get floating => text().nullable()();
  TextColumn get cashfloat => text().nullable()();
  RealColumn get salesBeginning => real()();
  RealColumn get salesEnding => real()();
  RealColumn get totalSales => real()();
  IntColumn get receiptBeginning => integer()();
  IntColumn get receiptEnding => integer()();
  TextColumn get status => text()();
  TextColumn get approvedBy => text().nullable()();
  TextColumn get approvedDate => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  /// One report per (date, pos, shift). Lets the DAO upsert on re-fetch
  /// instead of piling up duplicate rows.
  @override
  List<Set<Column>> get uniqueKeys => [
    {date, pos, shift},
  ];
}
