import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/discounts_table.dart';

part 'discounts_dao.g.dart';

@DriftAccessor(tables: [DiscountsTable])
class DiscountsDao extends DatabaseAccessor<AppDatabase>
    with _$DiscountsDaoMixin {
  DiscountsDao(super.db);

  // Saves a discount record in local storage.
  // Keeps the pricing rules available for the next checkout read.
  Future<void> saveDiscount(DiscountsTableCompanion discount) {
    return into(discountsTable).insert(discount);
  }

  // Replaces the cached discount list with a fresh snapshot.
  // Used to refresh the local pricing rules after a sync.
  Future<void> replaceDiscounts(List<DiscountsTableCompanion> discounts) {
    return transaction(() async {
      await delete(discountsTable).go();
      await batch((batch) {
        batch.insertAll(discountsTable, discounts);
      });
    });
  }

  // Reads all discounts from local storage.
  // Returns the current pricing rules cached on the device.
  Future<List<DiscountsTableData>> getAllDiscounts() {
    return select(discountsTable).get();
  }

  // Watches the discount table for live updates.
  // Useful for screens that need the latest pricing changes immediately.
  Stream<List<DiscountsTableData>> watchAllDiscounts() {
    return select(discountsTable).watch();
  }
}
