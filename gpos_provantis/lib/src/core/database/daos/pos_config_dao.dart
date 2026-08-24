import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/pos_config_table.dart';

part 'pos_config_dao.g.dart';

@DriftAccessor(tables: [POSConfigTable])
class PosConfigDao extends DatabaseAccessor<AppDatabase>
    with _$PosConfigDaoMixin {
  PosConfigDao(super.db);

  /// Saves (inserts or overwrites) the single pos config row.
  /// `id` uses the table's fixed default ('pos_config'), so this is
  /// always an upsert against that one row (this device only ever
  /// represents one POS terminal).
  Future<void> savePos(POSConfigTableCompanion pos) {
    return into(pOSConfigTable).insertOnConflictUpdate(pos);
  }

  Future<POSConfigTableData?> getPos() {
    return select(pOSConfigTable).getSingleOrNull();
  }

  Stream<POSConfigTableData?> watchPos() {
    return select(pOSConfigTable).watchSingleOrNull();
  }
}
