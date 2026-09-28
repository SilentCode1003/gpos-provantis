import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sold_items_table.dart';

part 'sold_items_dao.g.dart';

/// Local cache of the sold-items report.
///
/// One snapshot per date range: every product the server returned for that
/// range, saved once. Category/product filtering happens on the device when
/// reading, so switching filters never creates another copy of the data.
///
/// Snapshot rows are stored with the table's default filter values ('ALL'),
/// which is what marks a row as part of a full snapshot.
@DriftAccessor(tables: [SoldItemsTable])
class SoldItemsDao extends DatabaseAccessor<AppDatabase>
    with _$SoldItemsDaoMixin {
  SoldItemsDao(super.db);

  static const String _all = 'ALL';

  /// Replaces the cached snapshot for [dateRange] with [rows], atomically.
  ///
  /// Everything stored for [dateRange] is removed first, whatever it was saved
  /// under, so a refresh can never leave two copies of the same product.
  /// An empty [rows] is valid (it clears the range).
  Future<void> replaceSnapshot({
    required String dateRange,
    required List<SoldItemsTableCompanion> rows,
  }) {
    return transaction(() async {
      await (delete(
        soldItemsTable,
      )..where((t) => t.dateRange.equals(dateRange))).go();

      // Cleanup of the older design, which kept one full copy of the catalog
      // per category/product filter. Those rows are never read any more.
      // Safe to delete this statement once no device still has such rows.
      await (delete(soldItemsTable)..where(
            (t) =>
                t.categoryFilter.isNotValue(_all) |
                t.productFilter.isNotValue(_all),
          ))
          .go();

      if (rows.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(soldItemsTable, rows);
        });
      }
    });
  }

  /// Live rows of the snapshot for [dateRange], ordered by category then name.
  /// Emits again whenever [replaceSnapshot] changes them, which is what
  /// refreshes the UI after a fetch.
  Stream<List<SoldItemsTableData>> watchSnapshot(String dateRange) {
    return (select(soldItemsTable)
          ..where(
            (t) =>
                t.dateRange.equals(dateRange) &
                t.categoryFilter.equals(_all) &
                t.productFilter.equals(_all),
          )
          ..orderBy([
            (t) => OrderingTerm.asc(t.category),
            (t) => OrderingTerm.asc(t.name),
          ]))
        .watch();
  }

  Future<List<SoldItemsTableData>> getSnapshot(String dateRange) {
    return (select(soldItemsTable)..where(
          (t) =>
              t.dateRange.equals(dateRange) &
              t.categoryFilter.equals(_all) &
              t.productFilter.equals(_all),
        ))
        .get();
  }

  /// Drops cached rows fetched before [olderThan]. Every row of a snapshot
  /// shares one fetch time, so this removes whole snapshots, never part of one.
  /// [SoldItemsRepository] calls it after each successful fetch with its
  /// retention window, so the cache doesn't grow forever (every distinct date
  /// range adds rows).
  Future<int> deleteOlderThan(DateTime olderThan) {
    return (delete(soldItemsTable)..where(
          (t) =>
              t.fetchedAt.isSmallerThanValue(olderThan.millisecondsSinceEpoch),
        ))
        .go();
  }

  Future<List<SoldItemsTableData>> getAllSoldItems() {
    return select(soldItemsTable).get();
  }
}
