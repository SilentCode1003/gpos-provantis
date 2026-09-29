import 'package:drift/drift.dart';

class POSConfigTable extends Table {
  TextColumn get id => text().withDefault(const Constant('pos_config'))();
  IntColumn get posId => integer().withDefault(const Constant(0))();
  TextColumn get posName => text().withDefault(const Constant('MAIN_POS'))();
  TextColumn get serial => text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get min => text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get ptu => text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get status =>
      text().withDefault(const Constant('PENDING_SETUP'))();
  TextColumn get createdBy =>
      text().withDefault(const Constant('SYSTEM_INITIALIZER'))();
  DateTimeColumn get createdDate =>
      dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}
  