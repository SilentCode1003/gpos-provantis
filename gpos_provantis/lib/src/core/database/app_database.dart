import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'schema/schema_migrator.dart';
import 'schema/schema_seeder.dart';

import 'tables/pos_config_table.dart';
import 'tables/branch_config_table.dart';
import 'tables/domain_config_table.dart';
import 'tables/user_data_table.dart';

import 'tables/categories_table.dart';
import 'tables/denominations_table.dart';
import 'tables/discounts_table.dart';
import 'tables/employees_table.dart';
import 'tables/payments_table.dart';
import 'tables/pos_detail_id_table.dart';
import 'tables/pos_shift_table.dart';
import 'tables/product_price_table.dart';
import 'tables/promo_table.dart';
import 'tables/printers_table.dart';
import 'tables/settings_table.dart';
import 'tables/sales_table.dart';
import 'tables/end_shift_table.dart';
import 'tables/sold_items_table.dart';
import 'tables/cash_drawer_table.dart';
import 'tables/sold_items_report_table.dart';
import 'tables/payment_summary_report_table.dart';
import 'tables/staff_sales_report_table.dart';
import 'tables/sold_services_report_table.dart';
import 'tables/sold_packages_report_table.dart';
import 'tables/service_table.dart';
import 'tables/service_package_table.dart';
import 'tables/addon_table.dart';
import 'tables/shift_report_table.dart';
import 'tables/receipt_history_table.dart';
import 'tables/cash_drop_table.dart';
import 'tables/send_cash_report_table.dart';

import 'daos/domain_config_dao.dart';
import 'daos/branch_config_dao.dart';
import 'daos/pos_config_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    POSConfigTable,
    UserDataTable,
    BranchConfigTable,
    DomainConfigTable,
    CategoriesTable,
    DenominationsTable,
    DiscountsTable,
    EmployeesTable,
    PaymentsTable,
    PosDetailIdTable,
    PosShiftTable,
    ProductPriceTable,
    PromoTable,
    PrintersTable,
    SettingsTable,
    SalesTable,
    EndShiftTable,
    SoldItemsTable,
    CashDrawerTable,
    SoldItemsReportTable,
    PaymentSummaryReportTable,
    StaffSalesReportTable,
    SoldServicesReportTable,
    SoldPackagesReportTable,
    ServiceTable,
    ServicePackageTable,
    AddonTable,
    ShiftReportTable,
    ReceiptHistoryTable,
    CashDropTable,
    SendCashReportTable,
  ],
  daos: [DomainConfigDao, BranchConfigDao, PosConfigDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      await SchemaMigrator(db: this, m: m).upgrade(from, to);
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');

      if (details.wasCreated) {
        await SchemaSeeder(this).seedInitialData();
      }
    },
  );

  Stream<UserDataTableData?> watchCurrentUser() {
    return select(userDataTable).watchSingleOrNull();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();

    final file = File(p.join(dbFolder.path, 'gpos_provantis_local.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();

  ref.onDispose(() => db.close());

  return db;
}
