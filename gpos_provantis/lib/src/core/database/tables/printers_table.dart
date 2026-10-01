import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class PrintersTable extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v4())();
  TextColumn get name => text().withDefault(const Constant('DEFAULT'))();
  TextColumn get connectionType => text().withDefault(const Constant('WIFI'))();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get paperSize => text().withDefault(const Constant('mm80'))();

  /// Lets the user switch a printer off without deleting it.
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();

  /// True when a cash drawer is plugged into this printer.
  BoolColumn get hasCashDrawer =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
