import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod/riverpod.dart';

import 'package:gpos_provantis/src/core/database/domain/settings_dto.dart';
import 'package:gpos_provantis/src/core/database/providers/settings_dao_provider.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:gpos_provantis/src/services/check_health_service.dart';
import 'package:gpos_provantis/src/services/sync/catalog_sync.dart';

/// Watched once in app.dart (like the health check). Re-creates its timer
/// whenever the schedule in Settings > Sync changes.
final autoSyncSchedulerProvider = Provider<AutoSyncScheduler>((ref) {
  final scheduler = AutoSyncScheduler(ref);
  ref.onDispose(scheduler.dispose);
  ref.listen<int>(
    syncSettingsProvider.select((a) => a.value?.autoSyncIntervalMinutes ?? 0),
    (_, minutes) => scheduler.reschedule(minutes),
    fireImmediately: true,
  );
  return scheduler;
});

/// Runs a full catalog sync every N minutes while the app is open.
///
/// It is SILENT on purpose (it calls [CatalogSyncService.syncCatalog] directly,
/// not the controller that drives the progress overlay), because it fires
/// while the till is in use. It also stays out of the cashier's way:
///  - nothing runs until a catalog has been synced at least once;
///  - it skips a tick while the server is unreachable;
///  - it waits while there are items in the cart, and tries again a little
///    later (up to [_maxPostpones] times, then waits for the next tick).
class AutoSyncScheduler {
  AutoSyncScheduler(this._ref);

  final Ref _ref;

  static const _retryDelay = Duration(minutes: 2);
  static const _maxPostpones = 10;

  Timer? _timer;
  Timer? _retryTimer;
  bool _syncing = false;
  bool _disposed = false;
  int _postponed = 0;

  void reschedule(int minutes) {
    _timer?.cancel();
    _retryTimer?.cancel();
    _timer = null;
    _postponed = 0;
    if (_disposed || minutes <= 0) return;
    _timer = Timer.periodic(Duration(minutes: minutes), (_) => _tick());
  }

  Future<void> _tick() async {
    if (_disposed || _syncing) return;

    // A user has to have synced a catalog already (login does the first one).
    final rows = await _ref.read(settingsDaoProvider).getSettings();
    if (_disposed) return;
    final settings = rows.isEmpty
        ? const SyncSettings()
        : SyncSettings.fromTableData(rows.first);
    if (settings.lastCatalogSyncAt == null) return;

    if (_ref.read(serverHealthControllerProvider) ==
        ServerHealthStatus.offline) {
      debugPrint('AutoSync: server offline, skipping this round.');
      return;
    }

    // Never replace the catalog under a sale that is being rung up.
    if (_ref.read(dashboardControllerProvider).cartLines.isNotEmpty) {
      if (_postponed < _maxPostpones) {
        _postponed++;
        _retryTimer?.cancel();
        _retryTimer = Timer(_retryDelay, _tick);
      }
      return;
    }
    _postponed = 0;

    _syncing = true;
    try {
      final result = await _ref.read(catalogSyncServiceProvider).syncCatalog();
      debugPrint(
        result.success
            ? 'AutoSync: done.'
            : 'AutoSync: failed: ${result.errorMessage}',
      );
    } catch (e) {
      debugPrint('AutoSync: error: $e');
    } finally {
      _syncing = false;
    }
  }

  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _retryTimer?.cancel();
  }
}
