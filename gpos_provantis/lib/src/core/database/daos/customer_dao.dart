import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/customer_table.dart';

part 'customer_dao.g.dart';

@DriftAccessor(tables: [CustomerTable])
class CustomerDao extends DatabaseAccessor<AppDatabase>
    with _$CustomerDaoMixin {
  CustomerDao(super.db);

  /// Saves the customer for a sale. If one already exists for that sale it is
  /// replaced and goes back to PENDING, so a sale never ends up with two.
  Future<void> upsertForSale(CustomerTableCompanion data) {
    return transaction(() async {
      final existing = await (select(
        customerTable,
      )..where((t) => t.salesId.equals(data.salesId.value))).getSingleOrNull();

      if (existing == null) {
        await into(customerTable).insert(data);
        return;
      }

      await (update(
        customerTable,
      )..where((t) => t.id.equals(existing.id))).write(
        CustomerTableCompanion(
          posId: data.posId,
          type: data.type,
          company: data.company,
          fullName: data.fullName,
          email: data.email,
          phone: data.phone,
          mobile: data.mobile,
          address: data.address,
          purchaseOrder: data.purchaseOrder,
          createdAt: data.createdAt,
          syncStatus: const Value('PENDING'),
          syncedAt: const Value(null),
          attempts: const Value(0),
          lastError: const Value(null),
        ),
      );
    });
  }

  Future<CustomerTableData?> getById(String id) {
    return (select(
      customerTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<CustomerTableData?> getBySalesId(String salesId) {
    return (select(
      customerTable,
    )..where((t) => t.salesId.equals(salesId))).getSingleOrNull();
  }

  /// Newest first.
  Future<List<CustomerTableData>> getAllCustomers() {
    return (select(
      customerTable,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  /// Customers the server hasn't accepted yet, oldest first.
  Future<List<CustomerTableData>> getPending() {
    return (select(customerTable)
          ..where((t) => t.syncStatus.equals('PENDING'))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  Future<void> markSynced(String id, DateTime syncedAt) {
    return (update(customerTable)..where((t) => t.id.equals(id))).write(
      CustomerTableCompanion(
        syncStatus: const Value('SYNCED'),
        syncedAt: Value(syncedAt),
        lastError: const Value(null),
      ),
    );
  }

  /// Counts a failed send and remembers why. The customer stays PENDING.
  Future<void> markAttemptFailed(String id, String error) async {
    final row = await getById(id);
    if (row == null) return;
    await (update(customerTable)..where((t) => t.id.equals(id))).write(
      CustomerTableCompanion(
        attempts: Value(row.attempts + 1),
        lastError: Value(error),
      ),
    );
  }
}
