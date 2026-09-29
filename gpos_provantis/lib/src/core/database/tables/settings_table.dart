import 'package:drift/drift.dart';

class SettingsTable extends Table {
  TextColumn get id => text().withDefault(const Constant('settings_config'))();
  TextColumn get mainPrinter =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get subPrinter =>
      text().withDefault(const Constant('UNREGISTERED'))();
  BoolColumn get showVatOnReceipt =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get showOfficialReceiptMessageAtTheBottom =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get birAccredited =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get showReceiptPreview =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get addCustomerToTransaction =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get addPurchaseOrderToTransaction =>
      boolean().withDefault(const Constant(false))();

  TextColumn get counterDisplay =>
      text().withDefault(const Constant('UNREGISTERED'))();

  TextColumn get companyName =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get address =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get accreditationNo =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get validUntil =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get vatReg => text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get permitToUse =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get machineIdentificationNumber =>
      text().withDefault(const Constant('UNREGISTERED'))();

  @override
  Set<Column> get primaryKey => {id};
}
