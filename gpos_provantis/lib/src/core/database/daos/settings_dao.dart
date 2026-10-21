import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/settings_table.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [SettingsTable])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  // Saves the application settings row in local storage.
  // Keeps the initial configuration ready for the next read.
  Future<void> saveSettings(SettingsTableCompanion data) {
    return into(settingsTable).insert(data);
  }

  // Upserts the settings row to keep the values current.
  // Prevents duplicates while preserving the latest configuration.
  Future<void> upsertSettings(SettingsTableCompanion data) {
    return into(settingsTable).insertOnConflictUpdate(data);
  }

  // Reads all stored settings from local storage.
  // Returns the current configuration set for the app.
  Future<List<SettingsTableData>> getSettings() {
    return select(settingsTable).get();
  }

  // ---- Product image settings ----------------------------------------------
  // Each of these changes ONLY its own column, so they can never disturb the
  // printer / receipt settings, and the server-settings sync (which doesn't
  // write these columns) can never reset them.

  Future<void> setShowProductImages(bool value) => _updateOwnSettings(
    SettingsTableCompanion(showProductImages: Value(value)),
  );

  Future<void> setAutoFetchProductImages(bool value) => _updateOwnSettings(
    SettingsTableCompanion(autoFetchProductImages: Value(value)),
  );

  /// 0 turns the schedule off.
  Future<void> setProductImageRefetchDays(int days) => _updateOwnSettings(
    SettingsTableCompanion(productImageRefetchDays: Value(days < 0 ? 0 : days)),
  );

  Future<void> markProductImagesRefetched(DateTime when) => _updateOwnSettings(
    SettingsTableCompanion(productImagesLastRefetchedAt: Value(when)),
  );

  // ---- Sync settings -------------------------------------------------------

  Future<void> setAutoSyncAfterTransaction(bool value) => _updateOwnSettings(
    SettingsTableCompanion(autoSyncAfterTransaction: Value(value)),
  );

  Future<void> setAutoDeleteSyncedDataOnLogout(bool value) =>
      _updateOwnSettings(
        SettingsTableCompanion(autoDeleteSyncedDataOnLogout: Value(value)),
      );

  /// 0 turns the scheduled sync off.
  Future<void> setAutoSyncIntervalMinutes(int minutes) => _updateOwnSettings(
    SettingsTableCompanion(
      autoSyncIntervalMinutes: Value(minutes < 0 ? 0 : minutes),
    ),
  );

  Future<void> markCatalogSynced(DateTime when) => _updateOwnSettings(
    SettingsTableCompanion(lastCatalogSyncAt: Value(when)),
  );

  Future<void> clearCatalogSyncedAt() => _updateOwnSettings(
    const SettingsTableCompanion(lastCatalogSyncAt: Value(null)),
  );

  // Updates the existing settings row; if there is none yet, creates it (every
  // other column takes its default).
  Future<void> _updateOwnSettings(SettingsTableCompanion changes) async {
    final updated = await update(settingsTable).write(changes);
    if (updated == 0) await into(settingsTable).insert(changes);
  }

  // Watches the settings table for live updates.
  // Useful for screens that react to configuration changes.
  Stream<List<SettingsTableData>> watchSettings() {
    return select(settingsTable).watch();
  }
}
