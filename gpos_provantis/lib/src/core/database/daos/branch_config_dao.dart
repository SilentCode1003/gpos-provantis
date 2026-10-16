import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/branch_config_table.dart';

part 'branch_config_dao.g.dart';

@DriftAccessor(tables: [BranchConfigTable])
class BranchConfigDao extends DatabaseAccessor<AppDatabase>
    with _$BranchConfigDaoMixin {
  BranchConfigDao(super.db);

  // Saves the branch record in local storage.
  // Keeps the cached branch state ready for the next read.
  Future<void> saveBranch(BranchConfigTableCompanion branch) {
    return into(branchConfigTable).insertOnConflictUpdate(branch);
  }

  // Reads the stored branch from local storage.
  // Returns null when no branch row has been created yet.
  Future<BranchConfigTableData?> getBranch() {
    return select(branchConfigTable).getSingleOrNull();
  }

  // Watches the branch stream for live updates.
  // Useful for UI listeners that react to database changes.
  Stream<BranchConfigTableData?> watchBranch() {
    return select(branchConfigTable).watchSingleOrNull();
  }
}
