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

  // Watches the settings table for live updates.
  // Useful for screens that react to configuration changes.
  Stream<List<SettingsTableData>> watchSettings() {
    return select(settingsTable).watch();
  }
}
