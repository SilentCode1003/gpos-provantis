import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/pos_shift_table.dart';

part 'pos_shift_dao.g.dart';

@DriftAccessor(tables: [PosShiftTable])
class PosShiftDao extends DatabaseAccessor<AppDatabase>
    with _$PosShiftDaoMixin {
  PosShiftDao(super.db);

  // Saves a POS shift row in local storage.
  // Keeps the current shift state available for operational reads.
  Future<void> savePosShift(PosShiftTableData data) {
    return into(posShiftTable).insert(data);
  }

  // Replaces the cached shift list with a fresh snapshot.
  // Used to refresh local shift records after a sync or reload.
  Future<void> replacePosShifts(List<PosShiftTableCompanion> data) {
    return transaction(() async {
      await delete(posShiftTable).go();
      await batch((batch) {
        batch.insertAll(posShiftTable, data);
      });
    });
  }

  // Reads all POS shifts from local storage.
  // Returns the shift history currently cached on the device.
  Future<List<PosShiftTableData>> getAllPosShifts() {
    return select(posShiftTable).get();
  }

  // Watches the POS shift list for live updates.
  // Useful for screens that need the latest shift state immediately.
  Stream<List<PosShiftTableData>> watchAllPosShifts() {
    return select(posShiftTable).watch();
  }
}
