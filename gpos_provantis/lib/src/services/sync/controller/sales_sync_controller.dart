// Location: src/services/sync/sales_sync_controller.dart
//
// Background sales-upload service — runs for as long as the app process
// is alive, on a fixed timer, independent of any screen or user action.
// Unlike CatalogSyncController (see catalog_sync_controller.dart), which
// only runs when something explicitly calls runSync(...), this
// controller starts itself the moment it's first read and keeps going
// on its own: every tick it asks SalesRepository to push whatever sales
// are sitting locally with isSync == '0'. If the device is offline,
// that push simply fails fast (SalesRepository catches the network
// error and reports it as SaleUploadOutcome.failure per-sale) and the
// next tick tries again — there's no separate "am I online?" check
// before attempting, since a failed HTTP call is already the cheapest
// possible way to find that out and this project has no connectivity
// package as a dependency (see pubspec.yaml) to ask instead.
//
// No screen owns this: it's read once from GposProvantisApp.build() (see
// app.dart) purely to force the provider to initialize and start its
// timer, exactly the same "read it once at the app root so it starts
// itself" pattern CatalogSyncOverlay uses to stay mounted above every
// route.
import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';
// TODO: confirm this against sales_repository.dart's real location —
// inferred from that file's own `import '../domain/sales_dto.dart';`,
// which puts it one level above a domain/ folder (the same shape
// pos_detail_id_repository.dart uses). Update this import if the real
// path differs; `salesRepositoryProvider` itself is generated inline in
// that file via `part 'sales_repository.g.dart'`, not a separate
// providers/sales_repository_provider.dart file.
import 'package:gpos_provantis/src/core/database/repository/sales_repository.dart';

part 'sales_sync_controller.g.dart';

/// How often the background service attempts an upload pass. Arbitrary
/// — there was no stated requirement for this number, so it's kept as
/// one named constant rather than scattered through the file, to make
/// it obvious where to change it.
const salesSyncInterval = Duration(seconds: 30);

enum SalesSyncStatus { idle, syncing, failed }

class SalesSyncState {
  const SalesSyncState({
    this.status = SalesSyncStatus.idle,
    this.lastError,
    this.lastRunAt,
    this.lastSyncedCount = 0,
  });

  final SalesSyncStatus status;

  /// Set when the most recent tick's upload pass threw or otherwise
  /// couldn't run at all (see the catch in `_runOnce`) — distinct from
  /// an individual sale being rejected by the server, which
  /// `SalesRepository.uploadSales` already handles internally and
  /// simply reports via its returned count. This field is about the
  /// sync *pass itself* failing to complete, not about any one sale.
  final String? lastError;

  /// When the most recent tick started, successful or not — mainly
  /// useful for a settings/debug screen wanting to show "last synced
  /// at ...". Nothing in this controller reads it itself.
  final DateTime? lastRunAt;

  /// How many sales `SalesRepository.uploadSales` confirmed synced on
  /// the most recent tick. 0 either means nothing was pending or the
  /// first pending sale failed — those two cases aren't distinguished
  /// here since `uploadSales` itself already logs which one happened.
  final int lastSyncedCount;

  SalesSyncState copyWith({
    SalesSyncStatus? status,
    String? lastError,
    bool clearError = false,
    DateTime? lastRunAt,
    int? lastSyncedCount,
  }) {
    return SalesSyncState(
      status: status ?? this.status,
      lastError: clearError ? null : (lastError ?? this.lastError),
      lastRunAt: lastRunAt ?? this.lastRunAt,
      lastSyncedCount: lastSyncedCount ?? this.lastSyncedCount,
    );
  }
}

@Riverpod(keepAlive: true)
class SalesSyncController extends _$SalesSyncController {
  Timer? _timer;

  @override
  SalesSyncState build() {
    // Loud on purpose: this is the one line that proves the service
    // actually initialized in a given app run. If a sale sits unsynced
    // with no _runOnce/uploadSales logs at all and this line never
    // printed either, the service never started this session — that's
    // a different bug (something before/around this ref.watch call in
    // app.dart) than the timer just not having ticked yet.
    debugPrint('SalesSyncController: starting (interval=$salesSyncInterval)');

    // keepAlive providers aren't auto-disposed, but they ARE rebuilt if
    // something they ref.watch changes — this controller doesn't watch
    // anything, so build() only actually runs once per app process.
    // ref.onDispose still guards the (practically unreachable, but
    // cheap to handle) case of the provider container itself being torn
    // down, e.g. in a test.
    ref.onDispose(() {
      debugPrint('SalesSyncController: disposed, timer cancelled');
      _timer?.cancel();
    });

    _timer = Timer.periodic(salesSyncInterval, (_) {
      debugPrint('SalesSyncController: timer tick');
      _runOnce();
    });

    // Fire an immediate first pass on startup rather than waiting a
    // full interval for the first attempt — otherwise a sale created
    // right after app launch would sit unsynced for up to
    // salesSyncInterval before this ever tried it.
    //
    // Deferred via Future.microtask rather than called directly: build()
    // hasn't returned yet at this point, so `state` isn't live — a
    // notifier's state can only be read/written once its initial build()
    // has completed. _runOnce's very first line touches `state`, so
    // calling it inline here throws "Tried to read the state of an
    // uninitialized provider." Future.microtask runs its callback on the
    // next microtask turn, strictly after this build() call has
    // returned and Riverpod has installed the initial state — same
    // effect (an immediate first pass, not waiting for the first timer
    // tick) without touching state before it exists.
    Future.microtask(_runOnce);

    return const SalesSyncState();
  }

  /// One upload pass. Never throws outward — this runs unattended on a
  /// timer with nothing to catch a rejected Future, so any error here
  /// must be caught and folded into state instead.
  Future<void> _runOnce() async {
    if (state.status == SalesSyncStatus.syncing) {
      debugPrint('SalesSyncController: skipped — a pass is already running');
      // Guards against a slow pass still being in flight when the next
      // tick fires (e.g. a very slow/degraded connection taking longer
      // than salesSyncInterval to time out) — never run two passes
      // concurrently, since SalesRepository.uploadSales already assumes
      // it's the only thing reading/marking isSync at a time.
      return;
    }

    state = state.copyWith(
      status: SalesSyncStatus.syncing,
      clearError: true,
      lastRunAt: DateTime.now(),
    );

    try {
      final syncedCount = await ref.read(salesRepositoryProvider).uploadSales();
      state = state.copyWith(
        status: SalesSyncStatus.idle,
        lastSyncedCount: syncedCount,
      );
    } catch (error) {
      // SalesRepository.uploadSales is designed not to throw for a
      // per-sale failure (see its own doc comment) — reaching this catch
      // means something broke outside that per-sale handling, e.g. the
      // local database itself being unreadable. Recorded so it's
      // visible somewhere, but the timer keeps running regardless; the
      // next tick tries again on its own.
      state = state.copyWith(
        status: SalesSyncStatus.failed,
        lastError: error.toString(),
      );
    }
  }

  /// Triggers an upload pass immediately rather than waiting for the
  /// next tick — for a manual "Sync now" action, if one is ever added.
  /// No-ops (returns without doing anything) if a pass is already in
  /// flight, same as the timer-driven path.
  Future<void> syncNow() => _runOnce();
}
