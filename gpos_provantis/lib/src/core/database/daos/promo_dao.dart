import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/promo_table.dart';

part 'promo_dao.g.dart';

@DriftAccessor(tables: [PromoTable])
class PromoDao extends DatabaseAccessor<AppDatabase> with _$PromoDaoMixin {
  PromoDao(super.db);

  Future<void> savePromo(PromoTableData data) {
    return into(promoTable).insert(data);
  }

  Future<void> replacePromos(List<PromoTableCompanion> data) {
    return transaction(() async {
      await delete(promoTable).go();
      await batch((batch) {
        batch.insertAll(promoTable, data);
      });
    });
  }

  Future<List<PromoTableData>> getAllPromos() {
    return select(promoTable).get();
  }

  Stream<List<PromoTableData>> watchAllPromos() {
    return select(promoTable).watch();
  }
}
