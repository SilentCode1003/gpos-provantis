import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/pos_config_table.dart';

part 'pos_config_dao.g.dart';

@DriftAccessor(tables: [POSConfigTable])
class PosConfigDao extends DatabaseAccessor<AppDatabase>
    with _$PosConfigDaoMixin {
  PosConfigDao(super.db);

  // Saves the local POS configuration with conflict-safe upsert logic.
  // Keeps the current terminal settings ready for later reads.
  Future<void> savePos(POSConfigTableCompanion pos) {
    return into(pOSConfigTable).insertOnConflictUpdate(pos);
  }

  // Reads the stored POS configuration from local storage.
  // Returns null when the terminal has not been configured yet.
  Future<POSConfigTableData?> getPos() {
    return select(pOSConfigTable).getSingleOrNull();
  }

  // Watches the POS config for live updates.
  // Useful for screens that depend on the current terminal settings.
  Stream<POSConfigTableData?> watchPos() {
    return select(pOSConfigTable).watchSingleOrNull();
  }
}
