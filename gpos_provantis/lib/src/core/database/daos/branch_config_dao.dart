import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/branch_config_table.dart';

part 'branch_config_dao.g.dart';

@DriftAccessor(tables: [BranchConfigTable])
class BranchConfigDao extends DatabaseAccessor<AppDatabase>
    with _$BranchConfigDaoMixin {
  BranchConfigDao(super.db);

  Future<void> saveBranch(BranchConfigTableCompanion branch) {
    return into(branchConfigTable).insertOnConflictUpdate(branch);
  }

  Future<BranchConfigTableData?> getBranch() {
    return select(branchConfigTable).getSingleOrNull();
  }

  Stream<BranchConfigTableData?> watchBranch() {
    return select(branchConfigTable).watchSingleOrNull();
  }
}
