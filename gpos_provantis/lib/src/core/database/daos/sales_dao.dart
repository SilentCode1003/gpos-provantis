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
        await into(salesTable).insertOnConflictUpdate(sale);
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
