import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/branch_config_dao.dart';

part 'branch_config_dao_provider.g.dart';

@Riverpod(keepAlive: true)
BranchConfigDao branchConfigDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return BranchConfigDao(db);
}

/// Streams the currently configured branch from the local database.
/// Value is null before setup has ever run.
/// Manually written (not @riverpod) to avoid a known riverpod_generator
/// bug resolving Drift-generated types — see rrousselGit/riverpod#4370.
final branchConfigProvider =
    StreamNotifierProvider<BranchConfigNotifier, BranchConfigTableData?>(
      BranchConfigNotifier.new,
    );

class BranchConfigNotifier extends StreamNotifier<BranchConfigTableData?> {
  @override
  Stream<BranchConfigTableData?> build() {
    final dao = ref.watch(branchConfigDaoProvider);
    return dao.watchBranch();
  }
}
