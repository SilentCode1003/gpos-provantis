import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sales_table.dart';
import 'duplicate_detail_id_exception.dart';

part 'sales_dao.g.dart';

@DriftAccessor(tables: [SalesTable])
class SalesDao extends DatabaseAccessor<AppDatabase> with _$SalesDaoMixin {
  SalesDao(super.db);

  /// Saves a sale, once per receipt (detail) id.
  ///
  /// Returns true if the sale was saved, or false if this exact sale was
  /// already saved (a repeat of the same save, so nothing is written).
  /// Throws [DuplicateDetailIdException] if the id belongs to a different sale.
  ///
  /// The `id` column is a random UUID, so the old `insertOnConflictUpdate`
  /// never actually conflicted and saved a second row for the same receipt.
  // Saves a sale record while guarding against duplicate detail IDs.
  // Keeps one receipt mapped to a single stored sale entry.
  Future<bool> saveSale(SalesTableCompanion sale) {
    return transaction(() async {
      // A caller that sets the row id on purpose is updating that row.
      if (sale.id.present) {
        // A row that is already synced must never go back to unsynced, or it
        // would be sent again (and rejected by the server as "exist").
        final current = await (select(
          salesTable,
        )..where((row) => row.id.equals(sale.id.value))).getSingleOrNull();
        await into(salesTable).insertOnConflictUpdate(
          current?.isSync == '1'
              ? sale.copyWith(isSync: const Value.absent())
              : sale,
        );
        return true;
      }

      if (sale.detailId.present) {
        final existing = await getSaleByDetailId(sale.detailId.value);
        if (existing != null) {
          if (_isSameSale(existing, sale)) return false;
          throw DuplicateDetailIdException(sale.detailId.value);
        }
      }

      await into(salesTable).insert(sale);
      return true;
    });
  }

  /// Same sale = same money, same payment, same items. (The date is left out:
  /// a repeat of the save can land in a later minute.)
  // Checks whether the incoming sale matches an existing saved row.
  // This prevents duplicate writes for the same receipt payload.
  bool _isSameSale(SalesTableData existing, SalesTableCompanion sale) {
    bool same(Value<String> incoming, String stored) =>
        !incoming.present || incoming.value == stored;

    return same(sale.posid, existing.posid) &&
        same(sale.paymentType, existing.paymentType) &&
        same(sale.referenceId, existing.referenceId) &&
        same(sale.paymentName, existing.paymentName) &&
        same(sale.items, existing.items) &&
        same(sale.total, existing.total) &&
        same(sale.cash, existing.cash) &&
        same(sale.ecash, existing.ecash);
  }

  /// Two stored rows hold the same sale (same items, money and payment).
  bool _sameContent(SalesTableData a, SalesTableData b) {
    return a.items == b.items &&
        a.total == b.total &&
        a.paymentType == b.paymentType &&
        a.cash == b.cash &&
        a.ecash == b.ecash;
  }

  /// Removes extra local rows that hold the SAME sale under the same receipt
  /// id (left over from the old `insertOnConflictUpdate` bug, which saved a
  /// second row per receipt). The row kept is the one already synced, else the
  /// oldest. Rows that share a receipt id but hold a DIFFERENT sale are never
  /// deleted. Returns how many rows were removed.
  Future<int> removeDuplicateDetailIds() {
    return transaction(() async {
      final table = salesTable.actualTableName;
      final column = salesTable.detailId.name;

      final dupes = await customSelect(
        'SELECT $column AS dup_id FROM $table '
        "WHERE $column != 'UNREGISTERED' "
        'GROUP BY $column HAVING COUNT(*) > 1',
        readsFrom: {salesTable},
      ).get();

      var removed = 0;
      for (final dupe in dupes) {
        final detailId = dupe.read<String>('dup_id');
        final rows = await (select(
          salesTable,
        )..where((row) => row.detailId.equals(detailId))).get();

        // Synced first, then oldest, then id (so the choice is stable).
        rows.sort((a, b) {
          final aSynced = a.isSync == '1' ? 0 : 1;
          final bSynced = b.isSync == '1' ? 0 : 1;
          if (aSynced != bSynced) return aSynced.compareTo(bSynced);
          final byDate = a.createdAt.compareTo(b.createdAt);
          if (byDate != 0) return byDate;
          return a.id.compareTo(b.id);
        });

        final keeper = rows.first;
        for (final extra in rows.skip(1)) {
          if (!_sameContent(keeper, extra)) continue;
          removed += await (delete(
            salesTable,
          )..where((row) => row.id.equals(extra.id))).go();
        }
      }
      return removed;
    });
  }

  /// One local row per receipt id from now on. `UNREGISTERED` (the column
  /// default) is left out so rows without a receipt id never clash. Safe to
  /// call every launch. Throws if rows with the same receipt id but different
  /// content still exist, because those need a human look.
  Future<void> ensureUniqueDetailIdIndex() {
    final table = salesTable.actualTableName;
    final column = salesTable.detailId.name;
    return attachedDatabase.customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_${table}_$column '
      "ON $table($column) WHERE $column != 'UNREGISTERED'",
    );
  }

  /// True if this receipt id is already stored here as a SYNCED sale with
  /// DIFFERENT content. When the server says "exist" for such a row, the id was
  /// taken by another sale, so this one must not be marked synced.
  Future<bool> hasDifferentSyncedSale(SalesTableData sale) async {
    final others =
        await (select(salesTable)..where(
              (row) =>
                  row.detailId.equals(sale.detailId) &
                  row.isSync.equals('1') &
                  row.id.isNotValue(sale.id),
            ))
            .get();
    return others.any((other) => !_sameContent(other, sale));
  }

  // Replaces the cached sales rows with a fresh dataset.
  // Used when the local cache is refreshed from a broader sync.
  Future<void> replaceSales(List<SalesTableCompanion> sales) {
    return transaction(() async {
      await delete(salesTable).go();
      await batch((batch) {
        batch.insertAll(salesTable, sales, mode: InsertMode.insertOrIgnore);
      });
    });
  }

  // Reads all sales records from local storage.
  // Returns the full cached sale history for the app.
  Future<List<SalesTableData>> getAllSales() {
    return select(salesTable).get();
  }

  // Watches the sales table for live updates.
  // Useful for screens that react to newly saved receipts.
  Stream<List<SalesTableData>> watchAllSales() {
    return select(salesTable).watch();
  }

  // Reads a single sale using the receipt detail ID.
  // Returns null when no matching sale exists locally.
  Future<SalesTableData?> getSaleByDetailId(String detailId) {
    return (select(salesTable)
          ..where((row) => row.detailId.equals(detailId))
          ..limit(1))
        .getSingleOrNull();
  }

  // Reads unsynced sales in ascending created time order.
  // This keeps the upload queue deterministic and oldest-first.
  Future<List<SalesTableData>> getUnsyncedSales() {
    return (select(salesTable)
          ..where((row) => row.isSync.equals('0'))
          ..orderBy([
            (row) =>
                OrderingTerm(expression: row.createdAt, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Deletes sales the server already has that were created before [cutoff].
  /// Unsynced sales are never touched. Returns how many rows were removed.
  // Deletes synced sales older than the retention cutoff.
  // Helps keep local storage trimmed without removing active unsynced data.
  Future<int> deleteSyncedOlderThan(DateTime cutoff) {
    return (delete(salesTable)..where(
          (row) =>
              row.isSync.equals('1') & row.createdAt.isSmallerThanValue(cutoff),
        ))
        .go();
  }

  // Marks a sale as synced in local storage.
  // Prevents it from being sent again on the next batch upload.
  Future<void> markSynced(String id) {
    return (update(salesTable)..where((row) => row.id.equals(id))).write(
      const SalesTableCompanion(isSync: Value('1')),
    );
  }
}
