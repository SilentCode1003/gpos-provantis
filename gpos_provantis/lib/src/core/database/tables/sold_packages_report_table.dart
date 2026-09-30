import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class SoldPackagesReportTable extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  TextColumn get item => text().withDefault(const Constant('UNREGISTERED'))();
  IntColumn get quantity => integer().withDefault(const Constant(0))();
  RealColumn get total => real().withDefault(const Constant(0.0))();

  /// The receipt range these rows belong to. Together they identify the shift,
  /// so a reprint can never pick up another shift's packages.
  IntColumn get receiptBeginning => integer().withDefault(const Constant(0))();
  IntColumn get receiptEnding => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}