import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/shift_report_table.dart';

part 'shift_report_dao.g.dart';

@DriftAccessor(tables: [ShiftReportTable])
class ShiftReportDao extends DatabaseAccessor<AppDatabase>
    with _$ShiftReportDaoMixin {
  ShiftReportDao(super.db);

  /// Replaces the stored shifts for ONE day and POS, leaving other days
  /// untouched. An empty [rows] just clears that day.
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

  Future<List<ShiftReportTableData>> getForDate({
    required String date,
    required int pos,
  }) {
    return (select(shiftReportTable)
          ..where((t) => t.date.equals(date) & t.pos.equals(pos))
          ..orderBy([(t) => OrderingTerm.asc(t.shift)]))
        .get();
  }

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
