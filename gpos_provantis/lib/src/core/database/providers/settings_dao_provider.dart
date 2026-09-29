import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/settings_dao.dart';

part 'settings_dao_provider.g.dart';

@Riverpod(keepAlive: true)
SettingsDao settingsDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return SettingsDao(db);
}

final settingsProvider =
    StreamNotifierProvider<SettingsNotifier, List<SettingsTableData>>(
      SettingsNotifier.new,
    );

class SettingsNotifier extends StreamNotifier<List<SettingsTableData>> {
  @override
  Stream<List<SettingsTableData>> build() {
    final dao = ref.watch(settingsDaoProvider);
    return dao.watchSettings();
  }
}
