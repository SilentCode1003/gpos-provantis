import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/receipt_history_table.dart';

part 'receipt_history_dao.g.dart';

@DriftAccessor(tables: [ReceiptHistoryTable])
class ReceiptHistoryDao extends DatabaseAccessor<AppDatabase>
    with _$ReceiptHistoryDaoMixin {
  ReceiptHistoryDao(super.db);

  /// Replaces the stored receipts for [dateFrom]..[dateTo] (inclusive,
  /// `yyyy-MM-dd`) and [posId], leaving other days untouched. An empty [rows]
  /// just clears that range.
  Future<void> replaceForRange({
    required String dateFrom,
    required String dateTo,
    required int posId,
    required List<ReceiptHistoryTableCompanion> rows,
  }) {
    return transaction(() async {
      await (delete(receiptHistoryTable)..where(
            (t) =>
                t.posId.equals(posId) &
                t.receiptDate.isBetweenValues(dateFrom, dateTo),
          ))
          .go();
      if (rows.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(receiptHistoryTable, rows);
        });
      }
    });
  }

  /// Newest first.
  Future<List<ReceiptHistoryTableData>> getForRange({
    required String dateFrom,
    required String dateTo,
    required int posId,
  }) {
    return (select(receiptHistoryTable)
          ..where(
            (t) =>
                t.posId.equals(posId) &
                t.receiptDate.isBetweenValues(dateFrom, dateTo),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// The cached receipt with this OR number (`detail_id`), or null if it was
  /// never pulled. If several days cached the same id, the newest wins.
  Future<ReceiptHistoryTableData?> getByDetailId(String detailId) {
    return (select(receiptHistoryTable)
          ..where((t) => t.detailId.equals(detailId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Drops cached copies pulled before [cutoff]. Returns how many were removed.
  Future<int> deleteFetchedBefore(DateTime cutoff) {
    return (delete(
      receiptHistoryTable,
    )..where((t) => t.fetchedAt.isSmallerThanValue(cutoff))).go();
  }
}
