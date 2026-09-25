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
        if (state.isSyncing) {
          state = state.copyWith(stepLog: [...state.stepLog, label]);
        }
      },
    );

    if (result.success) {
      state = state.copyWith(status: CatalogSyncStatus.idle);
    } else if (result.errorMessage != null) {
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
