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

  Future<void> setShowProductImages(bool value) => _updateImageSettings(
    SettingsTableCompanion(showProductImages: Value(value)),
  );

  Future<void> setAutoFetchProductImages(bool value) => _updateImageSettings(
    SettingsTableCompanion(autoFetchProductImages: Value(value)),
  );

  /// 0 turns the schedule off.
  Future<void> setProductImageRefetchDays(int days) => _updateImageSettings(
    SettingsTableCompanion(productImageRefetchDays: Value(days < 0 ? 0 : days)),
  );

  Future<void> markProductImagesRefetched(DateTime when) =>
      _updateImageSettings(
        SettingsTableCompanion(productImagesLastRefetchedAt: Value(when)),
      );

  // Updates the existing settings row; if there is none yet, creates it (every
  // other column takes its default).
  Future<void> _updateImageSettings(SettingsTableCompanion changes) async {
    final updated = await update(settingsTable).write(changes);
    if (updated == 0) await into(settingsTable).insert(changes);
  }

  // Watches the settings table for live updates.
  // Useful for screens that react to configuration changes.
  Stream<List<SettingsTableData>> watchSettings() {
    return select(settingsTable).watch();
  }
}
