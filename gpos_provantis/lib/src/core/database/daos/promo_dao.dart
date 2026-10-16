import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/promo_table.dart';

part 'promo_dao.g.dart';

@DriftAccessor(tables: [PromoTable])
class PromoDao extends DatabaseAccessor<AppDatabase> with _$PromoDaoMixin {
  PromoDao(super.db);

  // Saves a promo row in local storage.
  // Keeps the current promotion set available for checkout reads.
  Future<void> savePromo(PromoTableData data) {
    return into(promoTable).insert(data);
  }

  // Replaces the cached promo list with a fresh snapshot.
  // Used to refresh the local sales promotions after a sync.
  Future<void> replacePromos(List<PromoTableCompanion> data) {
    return transaction(() async {
      await delete(promoTable).go();
      await batch((batch) {
        batch.insertAll(promoTable, data);
      });
    });
  }

  // Reads all promos from local storage.
  // Returns the currently cached promotion catalog.
  Future<List<PromoTableData>> getAllPromos() {
    return select(promoTable).get();
  }

  // Watches the promo list for live updates.
  // Useful for screens that need available offers immediately.
  Stream<List<PromoTableData>> watchAllPromos() {
    return select(promoTable).watch();
  }
}
