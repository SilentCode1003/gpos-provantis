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
  // Upserts the customer record for a sale while resetting its sync state.
  // Keeps one customer row mapped to each sale detail.
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

  // Reads a customer record by its local database ID.
  // Returns null when no matching customer exists.
  Future<CustomerTableData?> getById(String id) {
    return (select(
      customerTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // Reads a customer record by the sale ID it is linked to.
  // Useful when a customer belongs to a single receipt flow.
  Future<CustomerTableData?> getBySalesId(String salesId) {
    return (select(
      customerTable,
    )..where((t) => t.salesId.equals(salesId))).getSingleOrNull();
  }

  /// Newest first.
  // Reads all customers ordered by newest record first.
  // Helps the UI show the most recent customer entries first.
  Future<List<CustomerTableData>> getAllCustomers() {
    return (select(
      customerTable,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  /// Customers the server hasn't accepted yet, oldest first.
  // Reads pending customer rows in oldest-first order.
  // Keeps the sync queue stable and easier to retry in sequence.
  Future<List<CustomerTableData>> getPending() {
    return (select(customerTable)
          ..where((t) => t.syncStatus.equals('PENDING'))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  // Marks a customer record as synced and records the timestamp.
  // Prevents the same customer from being uploaded again.
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
  // Increments the retry counter and stores the latest failure reason.
  // Keeps the customer in the pending queue without losing the error signal.
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
