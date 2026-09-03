import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/pos_detail_id_table.dart';

part 'pos_detail_id_dao.g.dart';

@DriftAccessor(tables: [PosDetailIdTable])
class PosDetailIdDao extends DatabaseAccessor<AppDatabase>
    with _$PosDetailIdDaoMixin {
  PosDetailIdDao(super.db);

  Future<void> savePosDetailId(Insertable<PosDetailIdTableData> posDetailId) {
    return into(posDetailIdTable).insertOnConflictUpdate(posDetailId);
  }

  Future<PosDetailIdTableData?> getPosDetailId() {
    return select(posDetailIdTable).getSingleOrNull();
  }

  Stream<PosDetailIdTableData?> watchPosDetailId() {
    return select(posDetailIdTable).watchSingleOrNull();
  }
}
