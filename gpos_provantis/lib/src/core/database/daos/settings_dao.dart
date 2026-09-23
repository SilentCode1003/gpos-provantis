import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/settings_table.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [SettingsTable])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  Future<void> saveSettings(SettingsTableCompanion data) {
    return into(settingsTable).insert(data);
  }

  Future<void> upsertSettings(SettingsTableCompanion data) {
    return into(settingsTable).insertOnConflictUpdate(data);
  }

  Future<List<SettingsTableData>> getSettings() {
    return select(settingsTable).get();
  }

  Stream<List<SettingsTableData>> watchSettings() {
    return select(settingsTable).watch();
  }
}
