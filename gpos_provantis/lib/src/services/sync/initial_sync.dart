import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/database/repository/branch_config_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/pos_config_repository.dart';

part 'initial_sync.g.dart';

@Riverpod(keepAlive: true)
InitialSyncService initialSyncService(Ref ref) {
  final branchRepo = ref.watch(branchRepositoryProvider);
  final posRepo = ref.watch(posRepositoryProvider);
  return InitialSyncService(branchRepo, posRepo);
}

/// Result of [InitialSyncService.run]. Either both branch and pos config
/// were fetched and saved successfully, or [errorMessage] explains what
/// went wrong (network failure, duplicate-request block, missing/empty
/// server response, etc).
class InitialSyncResult {
  final bool success;
  final String? errorMessage;

  const InitialSyncResult.ok() : success = true, errorMessage = null;
  const InitialSyncResult.failure(this.errorMessage) : success = false;
}

/// Runs the first sync of the application: called right after the domain
/// has been saved during setup, before login exists. Fetches branch config
/// and pos config from the server (using only branchId/posId — no APK,
/// since login hasn't happened yet) and persists both locally.
///
/// Both calls run in parallel since they're independent of each other; if
/// either fails, the whole sync is reported as failed so setup can show an
/// error and let the user retry rather than proceeding with half-saved
/// config.
class InitialSyncService {
  final BranchRepository _branchRepo;
  final PosRepository _posRepo;

  InitialSyncService(this._branchRepo, this._posRepo);

  Future<InitialSyncResult> run({
    required String branchId,
    required String posId,
  }) async {
    try {
      await Future.wait([
        _branchRepo.fetchAndSaveBranch(branchId),
        _posRepo.fetchAndSavePos(posId),
      ]);
      return const InitialSyncResult.ok();
    } catch (e) {
      if (isDuplicateRequestError(e)) {
        // A double-tap on Proceed triggered this — the first sync attempt
        // is still in flight and will complete on its own. Treat as a
        // silent no-op rather than an error.
        return const InitialSyncResult.failure(null);
      }
      final msg = e.toString().replaceFirst('Exception: ', '');
      return InitialSyncResult.failure('Could not reach the server. $msg');
    }
  }
}
