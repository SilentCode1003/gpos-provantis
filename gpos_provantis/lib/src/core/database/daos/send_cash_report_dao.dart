import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/send_cash_report_table.dart';

part 'send_cash_report_dao.g.dart';

@DriftAccessor(tables: [SendCashReportTable])
class SendCashReportDao extends DatabaseAccessor<AppDatabase>
    with _$SendCashReportDaoMixin {
  SendCashReportDao(super.db);

  /// Saves the report for a shift. If one already exists for that shift (same
  /// branch, POS, date and shift number) it is replaced by the new count and
  /// goes back to PENDING, so recounting never creates a second report.
  // Upserts the send-cash report for one shift and POS scope.
  // Keeps one report per shift while resetting sync state for recounts.
  Future<void> upsertForShift(SendCashReportTableCompanion data) {
    return transaction(() async {
      final existing =
          await (select(sendCashReportTable)..where(
                (t) =>
                    t.branchId.equals(data.branchId.value) &
                    t.posId.equals(data.posId.value) &
                    t.shiftDate.equals(data.shiftDate.value) &
                    t.shift.equals(data.shift.value),
              ))
              .getSingleOrNull();

      if (existing == null) {
        await into(sendCashReportTable).insert(data);
        return;
      }

      await (update(
        sendCashReportTable,
      )..where((t) => t.id.equals(existing.id))).write(
        SendCashReportTableCompanion(
          cashierId: data.cashierId,
          amount: data.amount,
          linesJson: data.linesJson,
          createdAt: data.createdAt,
          syncStatus: const Value('PENDING'),
          syncedAt: const Value(null),
          attempts: const Value(0),
          lastError: const Value(null),
        ),
      );
    });
  }

  // Reads one send-cash report by its local database ID.
  // Returns null when the report is not present in storage.
  Future<SendCashReportTableData?> getById(String id) {
    return (select(
      sendCashReportTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // Reads the send-cash report for one branch, POS, date, and shift.
  // Returns null when no matching report has been saved locally.
  Future<SendCashReportTableData?> getForShift({
    required String branchId,
    required String posId,
    required String shiftDate,
    required String shift,
  }) {
    return (select(sendCashReportTable)..where(
          (t) =>
              t.branchId.equals(branchId) &
              t.posId.equals(posId) &
              t.shiftDate.equals(shiftDate) &
              t.shift.equals(shift),
        ))
        .getSingleOrNull();
  }

  /// Newest first.
  // Reads all send-cash reports ordered by newest record first.
  // Helps the UI show the most recent shift reports upfront.
  Future<List<SendCashReportTableData>> getAllSendCashReports() {
    return (select(
      sendCashReportTable,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  // Watches the send-cash report list for live updates.
  // Useful for dashboards that need the current shift report feed.
  Stream<List<SendCashReportTableData>> watchAllSendCashReports() {
    return (select(
      sendCashReportTable,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
  }

  /// Reports the server hasn't accepted yet, oldest first.
  // Reads pending send-cash reports in oldest-first order.
  // Keeps the sync queue stable and easier to retry in sequence.
  Future<List<SendCashReportTableData>> getPending() {
    return (select(sendCashReportTable)
          ..where((t) => t.syncStatus.equals('PENDING'))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  // Marks a send-cash report as synced and stores the server timestamp.
  // Prevents the same report from being uploaded again.
  Future<void> markSynced(String id, DateTime syncedAt) {
    return (update(sendCashReportTable)..where((t) => t.id.equals(id))).write(
      SendCashReportTableCompanion(
        syncStatus: const Value('SYNCED'),
        syncedAt: Value(syncedAt),
        lastError: const Value(null),
      ),
    );
  }

  /// Counts a failed send and remembers why. The report stays PENDING.
  // Increments the retry counter and stores the latest failure reason.
  // Keeps the report in the pending queue without losing the error signal.
  Future<void> markAttemptFailed(String id, String error) async {
    final row = await getById(id);
    if (row == null) return;
    await (update(sendCashReportTable)..where((t) => t.id.equals(id))).write(
      SendCashReportTableCompanion(
        attempts: Value(row.attempts + 1),
        lastError: Value(error),
      ),
    );
  }
}
