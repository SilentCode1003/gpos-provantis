import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/shift_report_table.dart';

part 'shift_report_dao.g.dart';

@DriftAccessor(tables: [ShiftReportTable])
class ShiftReportDao extends DatabaseAccessor<AppDatabase>
    with _$ShiftReportDaoMixin {
  ShiftReportDao(super.db);

  // Replaces the stored shifts for one date and POS only.
  // Keeps the report cache isolated to the requested day and terminal.
  Future<void> replaceForDate({
    required String date,
    required int pos,
    required List<ShiftReportTableCompanion> rows,
  }) {
    return transaction(() async {
      await (delete(
        shiftReportTable,
      )..where((t) => t.date.equals(date) & t.pos.equals(pos))).go();
      if (rows.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(shiftReportTable, rows);
        });
      }
    });
  }

  // Reads shift rows for one date and POS.
  // Returns the requested report list in shift order.
  Future<List<ShiftReportTableData>> getForDate({
    required String date,
    required int pos,
  }) {
    return (select(shiftReportTable)
          ..where((t) => t.date.equals(date) & t.pos.equals(pos))
          ..orderBy([(t) => OrderingTerm.asc(t.shift)]))
        .get();
  }

  // Watches shift rows for one date and POS.
  // Keeps the report screen updated as the local cache changes.
  Stream<List<ShiftReportTableData>> watchForDate({
    required String date,
    required int pos,
  }) {
    return (select(shiftReportTable)
          ..where((t) => t.date.equals(date) & t.pos.equals(pos))
          ..orderBy([(t) => OrderingTerm.asc(t.shift)]))
        .watch();
  }
}
