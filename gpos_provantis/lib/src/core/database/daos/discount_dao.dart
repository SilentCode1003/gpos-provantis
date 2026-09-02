import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/discount_table.dart';

part 'discount_dao.g.dart';

@DriftAccessor(tables: [DiscountTable])
class DiscountDao extends DatabaseAccessor<AppDatabase>
    with _$DiscountDaoMixin {
  DiscountDao(super.db);

  Future<void> saveDiscount(DiscountTableData discount) {
    return into(discountTable).insert(discount);
  }

  Future<List<DiscountTableData>> getAllDiscounts() {
    return select(discountTable).get();
  }

  Stream<List<DiscountTableData>> watchAllDiscounts() {
    return select(discountTable).watch();
  }
}
