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

class InitialSyncResult {
  final bool success;
  final String? errorMessage;

  const InitialSyncResult.ok() : success = true, errorMessage = null;
  const InitialSyncResult.failure(this.errorMessage) : success = false;
}

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
        return const InitialSyncResult.failure(null);
      }
      final msg = e.toString().replaceFirst('Exception: ', '');
      return InitialSyncResult.failure('Could not reach the server. $msg');
    }
  }
}
