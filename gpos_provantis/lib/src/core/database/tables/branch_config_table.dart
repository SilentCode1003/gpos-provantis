import 'package:drift/drift.dart';

class BranchConfigTable extends Table {
  TextColumn get id => text().withDefault(const Constant('branch_config'))();
  TextColumn get branchId =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get branchName =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get tin => text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get address =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get logo => text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get status => text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get createdBy =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get createdDate =>
      text().withDefault(const Constant('UNREGISTERED'))();

  @override
  Set<Column> get primaryKey => {id};
}
