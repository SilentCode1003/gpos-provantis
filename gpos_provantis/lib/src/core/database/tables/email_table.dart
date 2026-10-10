import 'package:drift/drift.dart';

/// The mail account e-receipts are sent from. One row, like the POS config.
class EmailTable extends Table {
  TextColumn get id => text().withDefault(const Constant('email_config'))();
  TextColumn get emailAddress => text().withDefault(const Constant(''))();
  TextColumn get password => text().withDefault(const Constant(''))();
  TextColumn get smtpServer => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}