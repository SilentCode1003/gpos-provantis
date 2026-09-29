import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/pos_shift_table.dart';

part 'pos_shift_dao.g.dart';

@DriftAccessor(tables: [PosShiftTable])
class PosShiftDao extends DatabaseAccessor<AppDatabase>
    with _$PosShiftDaoMixin {
  PosShiftDao(super.db);

  Future<void> savePosShift(PosShiftTableData data) {
    return into(posShiftTable).insert(data);
  }

  Future<void> replacePosShifts(List<PosShiftTableCompanion> data) {
    return transaction(() async {
      await delete(posShiftTable).go();
      await batch((batch) {
        batch.insertAll(posShiftTable, data);
      });
    });
  }

  Future<List<PosShiftTableData>> getAllPosShifts() {
    return select(posShiftTable).get();
  }

  Stream<List<PosShiftTableData>> watchAllPosShifts() {
    return select(posShiftTable).watch();
  }
}
