import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/settings_dao.dart';
import 'package:gpos_provantis/src/core/database/domain/settings_dto.dart';

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

/// The product-image settings, live. Falls back to the defaults (pictures on,
/// automatic download on, no schedule) until a settings row exists.
final productImageSettingsProvider = StreamProvider<ProductImageSettings>((
  ref,
) {
  return ref
      .watch(settingsDaoProvider)
      .watchSettings()
      .map(
        (rows) => rows.isEmpty
            ? const ProductImageSettings()
            : ProductImageSettings.fromTableData(rows.first),
      )
      .distinct();
});

/// Whether pictures show on the product grid. Only changes when that one
/// setting does.
final showProductImagesProvider = Provider<bool>((ref) {
  return ref.watch(
    productImageSettingsProvider.select((a) => a.value?.show ?? true),
  );
});

/// The sync settings, live. Falls back to the defaults until a settings row
/// exists.
final syncSettingsProvider = StreamProvider<SyncSettings>((ref) {
  return ref
      .watch(settingsDaoProvider)
      .watchSettings()
      .map(
        (rows) => rows.isEmpty
            ? const SyncSettings()
            : SyncSettings.fromTableData(rows.first),
      )
      .distinct();
});
