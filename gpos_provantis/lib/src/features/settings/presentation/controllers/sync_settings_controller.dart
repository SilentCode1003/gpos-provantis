import 'package:riverpod/riverpod.dart';

import 'package:gpos_provantis/src/core/database/providers/settings_dao_provider.dart';
import 'package:gpos_provantis/src/services/check_health_service.dart';
import 'package:gpos_provantis/src/services/sync/catalog_sync.dart';
import 'package:gpos_provantis/src/services/sync/controller/catalog_sync_controller.dart';
import 'package:gpos_provantis/src/shared/widgets/toast_emitter.dart';

class SyncJobState {
  const SyncJobState({this.syncing = false});

  /// True while "Sync now" is running.
  final bool syncing;
}

/// Manual provider (no build_runner pass), not auto-dispose, so a sync started
/// here still finishes and reports back if the cashier leaves the screen.
final syncSettingsControllerProvider =
    NotifierProvider<SyncSettingsController, SyncJobState>(
      SyncSettingsController.new,
    );

class SyncSettingsController extends Notifier<SyncJobState> {
  @override
  SyncJobState build() => const SyncJobState();

  // ---- saved straight to the local settings --------------------------------

  Future<void> setAutoSyncAfterTransaction(bool value) =>
      ref.read(settingsDaoProvider).setAutoSyncAfterTransaction(value);

  Future<void> setAutoDeleteSyncedDataOnLogout(bool value) =>
      ref.read(settingsDaoProvider).setAutoDeleteSyncedDataOnLogout(value);

  /// 0 = off.
  Future<void> setAutoSyncIntervalMinutes(int minutes) =>
      ref.read(settingsDaoProvider).setAutoSyncIntervalMinutes(minutes);

  // ---- Sync now -------------------------------------------------------------

  /// The same full sync the login runs (and the dashboard's SYNC DATA): sends
  /// what is waiting, then pulls the catalog. It goes through
  /// [catalogSyncControllerProvider], so it shows the same progress the rest
  /// of the app shows for a manual sync.
  Future<void> syncNow() async {
    if (state.syncing) return;

    // Everything from `ref` is read before the first await.
    final sync = ref.read(catalogSyncControllerProvider.notifier);
    final service = ref.read(catalogSyncServiceProvider);
    final health = ref.read(serverHealthControllerProvider.notifier);
    final toast = ref.read(toastEmitterProvider);

    state = const SyncJobState(syncing: true);
    try {
      if (!await health.checkNow()) {
        toast.error(
          'Can\'t reach the server. Check the connection and try again.',
        );
        return;
      }
      await sync.runSync(service);
    } catch (e) {
      toast.error(
        'Sync failed. ${e.toString().replaceFirst('Exception: ', '')}',
      );
    } finally {
      if (ref.mounted) state = const SyncJobState();
    }
  }
}
