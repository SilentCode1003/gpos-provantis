import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/discounts_table.dart';

part 'discounts_dao.g.dart';

@DriftAccessor(tables: [DiscountsTable])
class DiscountsDao extends DatabaseAccessor<AppDatabase>
    with _$DiscountsDaoMixin {
  DiscountsDao(super.db);

  Future<void> saveDiscount(DiscountsTableCompanion discount) {
    return into(discountsTable).insert(discount);
  }

  Future<void> replaceDiscounts(List<DiscountsTableCompanion> discounts) {
    return transaction(() async {
      await delete(discountsTable).go();
      await batch((batch) {
        batch.insertAll(discountsTable, discounts);
      });
    });
  }

  Future<List<DiscountsTableData>> getAllDiscounts() {
    return select(discountsTable).get();
  }

  Stream<List<DiscountsTableData>> watchAllDiscounts() {
    return select(discountsTable).watch();
  }
}
