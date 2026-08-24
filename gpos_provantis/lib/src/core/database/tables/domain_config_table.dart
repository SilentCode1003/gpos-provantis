import 'package:drift/drift.dart';

class DomainConfigTable extends Table {
  TextColumn get id => text().withDefault(const Constant('domain_config'))();
  TextColumn get domain =>
      text().withDefault(const Constant('http://please.setup.domain.com/'))();

  @override
  Set<Column> get primaryKey => {id};
}
