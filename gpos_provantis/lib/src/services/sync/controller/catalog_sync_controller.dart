// Location: src/services/sync/catalog_sync_controller.dart
//
// Global, app-wide catalog sync state — deliberately separate from
// LoginController. Login's own isSubmitting reflects the login API call
// only; this controller is triggered *after* a successful login (or from
// anywhere else, e.g. a manual "Sync" button) and drives a global overlay
// widget (see CatalogSyncOverlay) that ca`n show on top of any screen,
// not just the login form.
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/services/sync/catalog_sync.dart';

part 'catalog_sync_controller.g.dart';

enum CatalogSyncStatus { idle, syncing, failed }

class CatalogSyncState {
  const CatalogSyncState({
    this.status = CatalogSyncStatus.idle,
    this.errorMessage,
    this.stepLog = const [],
  });

  final CatalogSyncStatus status;
  final String? errorMessage;

  /// Every step label CatalogSyncService has announced so far, oldest
  /// first. The overlay renders this as a scrolling CLI-style log
  /// rather than swapping a single "current step" line, so each new
  /// label is appended rather than replacing the previous one. Reset
  /// to empty whenever a fresh sync starts.
  final List<String> stepLog;

  bool get isSyncing => status == CatalogSyncStatus.syncing;

  CatalogSyncState copyWith({
    CatalogSyncStatus? status,
    String? errorMessage,
    List<String>? stepLog,
    bool clearError = false,
  }) {
    return CatalogSyncState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      stepLog: stepLog ?? this.stepLog,
    );
  }
}

@Riverpod(keepAlive: true)
class CatalogSyncController extends _$CatalogSyncController {
  @override
  CatalogSyncState build() => const CatalogSyncState();

  /// Runs a catalog sync and updates state for the global overlay to
  /// react to. Safe to call from anywhere (post-login, a manual sync
  /// button, etc). No-ops if a sync is already in progress, so callers
  /// don't need to guard this themselves.
  Future<CatalogSyncResult> runSync(CatalogSyncService service) async {
    if (state.isSyncing) {
      return const CatalogSyncResult.failure(null);
    }

    state = state.copyWith(
      status: CatalogSyncStatus.syncing,
      clearError: true,
      stepLog: const [],
    );

    final result = await service.syncCatalog(
      onStep: (label) {
        // Guard against a step callback landing after the overlay has
        // already moved on (e.g. a stale future finishing late) — only
        // append while still actually in the syncing state.
        if (state.isSyncing) {
          state = state.copyWith(stepLog: [...state.stepLog, label]);
        }
      },
    );

    if (result.success) {
      state = state.copyWith(status: CatalogSyncStatus.idle);
    } else if (result.errorMessage != null) {
      // Real failure — surface it. A null errorMessage means the service
      // itself detected and silently absorbed a duplicate request, so
      // treat that as returning to idle rather than an error.
      state = state.copyWith(
        status: CatalogSyncStatus.failed,
        errorMessage: result.errorMessage,
      );
    } else {
      state = state.copyWith(status: CatalogSyncStatus.idle);
    }

    return result;
  }

  void dismissError() {
    state = state.copyWith(status: CatalogSyncStatus.idle, clearError: true);
  }
}
