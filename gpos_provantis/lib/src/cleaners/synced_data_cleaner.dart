import 'package:drift/drift.dart' show Table, TableInfo;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod/riverpod.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/domain/settings_dto.dart';
import 'package:gpos_provantis/src/core/database/providers/settings_dao_provider.dart';

final syncedDataCleanerProvider = Provider<SyncedDataCleaner>(
  (ref) => SyncedDataCleaner(ref),
);

/// Call [clearIfEnabled] once, after a logout has completed:
///
///   await ref.read(syncedDataCleanerProvider).clearIfEnabled();
class SyncedDataCleaner {
  SyncedDataCleaner(this._ref);

  final Ref _ref;

  /// Clears the synced data only if Settings > Sync > "Delete synced data on
  /// logout" is on. Returns true if it cleared. Never throws.
  Future<bool> clearIfEnabled() async {
    try {
      final rows = await _ref.read(settingsDaoProvider).getSettings();
      final settings = rows.isEmpty
          ? const SyncSettings()
          : SyncSettings.fromTableData(rows.first);
      if (!settings.autoDeleteSyncedDataOnLogout) return false;
      await clearNow();
      return true;
    } catch (e) {
      debugPrint('SyncedDataCleaner: could not clear: $e');
      return false;
    }
  }

  /// Empties the tables that only hold a COPY of what the server has (or the
  /// saved login), all in one transaction, and forgets when the catalog was
  /// last synced.
  ///
  /// The tables are listed by their real names on [AppDatabase], so a typo or
  /// a renamed table is a compile error, not a silent skip.
  ///
  /// NOT cleared, on purpose:
  ///  - sales_table, split_payment_table: unsent sales must survive;
  ///  - customer, sales_purchase_order, cash_drawer, end_shift, send_cash_report,
  ///    cash_drop, cash_report: these hold work still waiting to be sent;
  ///  - settings, printers, email, pos_config, branch_config, domain_config:
  ///    this device's own configuration (the server address included);
  ///  - product_image: the pictures stay, they match the same products;
  ///  - sold_items, shift_report: not sure they are plain server copies.
  Future<void> clearNow() async {
    final db = _ref.read(appDatabaseProvider);

    final tables = <TableInfo<Table, dynamic>>[
      // The login. Without these the next login must reach the server.
      db.userDataTable,
      db.loginCredentialsTable,
      // The catalog (what syncCatalog downloads).
      db.categoriesTable,
      db.denominationsTable,
      db.discountsTable,
      db.employeesTable,
      db.paymentsTable,
      db.posDetailIdTable,
      db.posShiftTable,
      db.productPriceTable,
      db.promoTable,
      db.serviceTable,
      db.servicePackageTable,
      db.addonTable,
      // Report and receipt copies downloaded from the server.
      db.soldItemsReportTable,
      db.paymentSummaryReportTable,
      db.staffSalesReportTable,
      db.soldServicesReportTable,
      db.soldPackagesReportTable,
      db.receiptHistoryTable,
    ];

    // Same approach as AppDatabase.wipeAllData: foreign keys OFF around the
    // transaction (the pragma does nothing inside one). With them off, deleting
    // a row here can never cascade into a table we are keeping.
    await db.customStatement('PRAGMA foreign_keys = OFF');
    try {
      await db.transaction(() async {
        for (final table in tables) {
          await db.delete(table).go();
        }
      });
    } finally {
      await db.customStatement('PRAGMA foreign_keys = ON');
    }

    await _ref.read(settingsDaoProvider).clearCatalogSyncedAt();
    debugPrint('SyncedDataCleaner: cleared ${tables.length} tables');
  }
}
