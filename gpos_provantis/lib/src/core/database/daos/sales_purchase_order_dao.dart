import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sales_purchase_order_table.dart';

part 'sales_purchase_order_dao.g.dart';

@DriftAccessor(tables: [SalesPurchaseOrderTable])
class SalesPurchaseOrderDao extends DatabaseAccessor<AppDatabase>
    with _$SalesPurchaseOrderDaoMixin {
  SalesPurchaseOrderDao(super.db);

  /// Saves the purchase order for a sale, once per receipt number, and returns
  /// the stored row.
  ///
  /// Saving the same purchase order again leaves the stored row untouched (a
  /// SYNCED one stays SYNCED). A different purchase order for the same sale
  /// replaces the old one and goes back to PENDING, so a correction is sent.
  Future<SalesPurchaseOrderTableData> saveOnce(
    SalesPurchaseOrderTableCompanion data,
  ) {
    return transaction(() async {
      final salesId = data.salesId.value;
      final existing = await getBySalesId(salesId);

      if (existing == null) {
        await into(salesPurchaseOrderTable).insert(data);
      } else if (existing.purchaseOrderId != data.purchaseOrderId.value) {
        await (update(
          salesPurchaseOrderTable,
        )..where((t) => t.id.equals(existing.id))).write(
          SalesPurchaseOrderTableCompanion(
            purchaseOrderId: data.purchaseOrderId,
            createdAt: data.createdAt,
            syncStatus: const Value('PENDING'),
            syncedAt: const Value(null),
            attempts: const Value(0),
            lastError: const Value(null),
          ),
        );
      }

      final saved = await getBySalesId(salesId);
      if (saved == null) {
        throw StateError('Purchase order was not found after saving.');
      }
      return saved;
    });
  }

  Future<SalesPurchaseOrderTableData?> getById(String id) {
    return (select(
      salesPurchaseOrderTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<SalesPurchaseOrderTableData?> getBySalesId(String salesId) {
    return (select(
      salesPurchaseOrderTable,
    )..where((t) => t.salesId.equals(salesId))).getSingleOrNull();
  }

  /// Newest first.
  Future<List<SalesPurchaseOrderTableData>> getAllSalesPurchaseOrders() {
    return (select(
      salesPurchaseOrderTable,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  /// Purchase orders the server doesn't have yet, oldest first.
  Future<List<SalesPurchaseOrderTableData>> getPending() {
    return (select(salesPurchaseOrderTable)
          ..where((t) => t.syncStatus.equals('PENDING'))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// Deletes purchase orders the server already has that were created before
  /// [cutoff]. PENDING ones are never touched. Returns how many were removed.
  Future<int> deleteSyncedOlderThan(DateTime cutoff) {
    return (delete(salesPurchaseOrderTable)..where(
          (t) =>
              t.syncStatus.equals('SYNCED') &
              t.createdAt.isSmallerThanValue(cutoff),
        ))
        .go();
  }

  Future<void> markSynced(String id, DateTime syncedAt) {
    return (update(
      salesPurchaseOrderTable,
    )..where((t) => t.id.equals(id))).write(
      SalesPurchaseOrderTableCompanion(
        syncStatus: const Value('SYNCED'),
        syncedAt: Value(syncedAt),
        lastError: const Value(null),
      ),
    );
  }

  /// Counts a failed send and remembers why. The purchase order stays PENDING.
  Future<void> markAttemptFailed(String id, String error) async {
    final row = await getById(id);
    if (row == null) return;
    await (update(
      salesPurchaseOrderTable,
    )..where((t) => t.id.equals(id))).write(
      SalesPurchaseOrderTableCompanion(
        attempts: Value(row.attempts + 1),
        lastError: Value(error),
      ),
    );
  }
}
