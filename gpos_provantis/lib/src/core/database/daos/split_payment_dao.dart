import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/split_payment_table.dart';
import 'duplicate_detail_id_exception.dart';

part 'split_payment_dao.g.dart';

@DriftAccessor(tables: [SplitPaymentTable])
class SplitPaymentDao extends DatabaseAccessor<AppDatabase>
    with _$SplitPaymentDaoMixin {
  SplitPaymentDao(super.db);

  /// Saves a split sale. If one already exists for that receipt id it is
  /// replaced (and goes back to PENDING), so a receipt never has two rows.
  // Upserts the split payment record for a sale detail.
  // Keeps one row per receipt while resetting pending state when needed.
  Future<void> upsertForDetail(SplitPaymentTableCompanion data) {
    return transaction(() async {
      await (delete(
        splitPaymentTable,
      )..where((t) => t.detailId.equals(data.detailId.value))).go();
      await into(splitPaymentTable).insert(data);
    });
  }

  /// Saves a split sale once per receipt id and returns the stored row.
  ///
  /// If this exact sale is already stored it is left untouched (a SYNCED sale
  /// stays SYNCED, its attempt count is kept) and the stored row is returned.
  /// Throws [DuplicateDetailIdException] if the id belongs to a different sale.
  // Saves a split payment only once per detail ID and returns the stored row.
  // Prevents duplicate records while preserving the original synced state.
  Future<SplitPaymentTableData> saveOnce(SplitPaymentTableCompanion data) {
    return transaction(() async {
      final detailId = data.detailId.value;
      final existing = await getByDetailId(detailId);
      if (existing != null) {
        if (_isSameSale(existing, data)) return existing;
        throw DuplicateDetailIdException(detailId);
      }

      await into(splitPaymentTable).insert(data);
      final saved = await getByDetailId(detailId);
      if (saved == null) {
        throw StateError('Split payment was not found after saving.');
      }
      return saved;
    });
  }

  /// Same sale = same money, same two payments, same items.
  // Checks whether the incoming split payment matches an existing saved row.
  // This prevents duplicate writes for the same receipt payload.
  bool _isSameSale(
    SplitPaymentTableData existing,
    SplitPaymentTableCompanion data,
  ) {
    bool same<T>(Value<T> incoming, T stored) =>
        !incoming.present || incoming.value == stored;

    return same(data.posId, existing.posId) &&
        same(data.items, existing.items) &&
        same(data.total, existing.total) &&
        same(data.firstPaymentType, existing.firstPaymentType) &&
        same(data.firstPayment, existing.firstPayment) &&
        same(data.firstPaymentReference, existing.firstPaymentReference) &&
        same(data.secondPaymentType, existing.secondPaymentType) &&
        same(data.secondPayment, existing.secondPayment) &&
        same(data.secondPaymentReference, existing.secondPaymentReference);
  }

  // Reads a split payment row by its local database ID.
  // Returns null when no matching record exists.
  Future<SplitPaymentTableData?> getById(String id) {
    return (select(
      splitPaymentTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // Reads a split payment row by its receipt detail ID.
  // Returns null when no matching split payment has been stored.
  Future<SplitPaymentTableData?> getByDetailId(String detailId) {
    return (select(
      splitPaymentTable,
    )..where((t) => t.detailId.equals(detailId))).getSingleOrNull();
  }

  /// Newest first.
  // Reads all split payments ordered by newest record first.
  // Helps the UI show the most recent split-sale entries first.
  Future<List<SplitPaymentTableData>> getAllSplitPayments() {
    return (select(
      splitPaymentTable,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  // Watches the split payment list for live updates.
  // Useful for screens that need the latest queue of split receipts.
  Stream<List<SplitPaymentTableData>> watchAllSplitPayments() {
    return (select(
      splitPaymentTable,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
  }

  /// Sales the server doesn't have yet, oldest first.
  // Reads pending split payments in oldest-first order.
  // Keeps the sync queue stable and easier to retry in sequence.
  Future<List<SplitPaymentTableData>> getPending() {
    return (select(splitPaymentTable)
          ..where((t) => t.syncStatus.equals('PENDING'))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// Deletes split sales the server already has that were created before
  /// [cutoff]. PENDING sales are never touched. Returns how many rows were
  /// removed.
  // Deletes synced split payments older than the retention cutoff.
  // Helps keep local storage trimmed without removing active pending rows.
  Future<int> deleteSyncedOlderThan(DateTime cutoff) {
    return (delete(splitPaymentTable)..where(
          (t) =>
              t.syncStatus.equals('SYNCED') &
              t.createdAt.isSmallerThanValue(cutoff),
        ))
        .go();
  }

  // Marks a split payment as synced and stores the server timestamp.
  // Prevents the same payment from being uploaded again.
  Future<void> markSynced(String id, DateTime syncedAt) {
    return (update(splitPaymentTable)..where((t) => t.id.equals(id))).write(
      SplitPaymentTableCompanion(
        syncStatus: const Value('SYNCED'),
        syncedAt: Value(syncedAt),
        lastError: const Value(null),
      ),
    );
  }

  /// Counts a failed send and remembers why. The sale stays PENDING.
  // Increments the retry counter and remembers the latest failure reason.
  // Keeps the split payment in the sync queue without losing the error signal.
  Future<void> markAttemptFailed(String id, String error) async {
    final row = await getById(id);
    if (row == null) return;
    await (update(splitPaymentTable)..where((t) => t.id.equals(id))).write(
      SplitPaymentTableCompanion(
        attempts: Value(row.attempts + 1),
        lastError: Value(error),
      ),
    );
  }
}
