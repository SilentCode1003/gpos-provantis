import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/end_shift_table.dart';

part 'end_shift_report_dao.g.dart';

@DriftAccessor(tables: [EndShiftTable])
class EndShiftDao extends DatabaseAccessor<AppDatabase>
    with _$EndShiftDaoMixin {
  EndShiftDao(super.db);

  /// Saves a shift report, replacing any existing row for the same
  /// (date, pos, shift). History for other shifts is preserved, so old
  /// reports can be reprinted offline.
  // Upserts the end-of-shift report for one date, POS, and shift.
  // Keeps that shift scoped and preserves older reports for offline reprint.
  Future<void> upsertEndShift(EndShiftTableCompanion report) {
    return transaction(() async {
      await (delete(endShiftTable)..where(
            (t) =>
                t.date.equals(report.date.value) &
                t.pos.equals(report.pos.value) &
                t.shift.equals(report.shift.value),
          ))
          .go();
      await into(endShiftTable).insert(report);
    });
  }

  /// Returns the locally stored report for this shift, or null if we've never
  /// fetched it. This is what makes offline reprints possible.
  // Reads the end-of-shift report for one date, POS, and shift.
  // Returns null when the report has not been cached locally yet.
  Future<EndShiftTableData?> getEndShift({
    required String date,
    required int pos,
    required int shift,
  }) {
    return (select(endShiftTable)..where(
          (t) =>
              t.date.equals(date) & t.pos.equals(pos) & t.shift.equals(shift),
        ))
        .getSingleOrNull();
  }

  // Reads all end-of-shift report rows from local storage.
  // Returns the full cached shift report history for the device.
  Future<List<EndShiftTableData>> getAllEndShift() {
    return select(endShiftTable).get();
  }

  // Watches all end-of-shift report rows for live updates.
  // Useful for screens that need the current shift report feed.
  Stream<List<EndShiftTableData>> watchAllEndShift() {
    return select(endShiftTable).watch();
  }
}
