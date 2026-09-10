import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class PrintersTable extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text().withDefault(const Constant('DEFAULT'))();
  TextColumn get connectionType => text().withDefault(const Constant('WIFI'))();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get paperSize => text().withDefault(const Constant('mm80'))();

  @override
  Set<Column> get primaryKey => {id};
}
