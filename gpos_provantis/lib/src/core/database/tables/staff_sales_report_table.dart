import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class StaffSalesReportTable extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  TextColumn get salesStaff =>
      text().withDefault(const Constant('UNREGISTERED'))();
  RealColumn get total => real().withDefault(const Constant(0.0))();

  /// The receipt range these rows belong to. Together they identify the shift,
  /// so a reprint can never pick up another shift's staff sales.
  IntColumn get receiptBeginning => integer().withDefault(const Constant(0))();
  IntColumn get receiptEnding => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
