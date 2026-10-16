import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/denominations_table.dart';

part 'denominations_dao.g.dart';

@DriftAccessor(tables: [DenominationsTable])
class DenominationsDao extends DatabaseAccessor<AppDatabase>
    with _$DenominationsDaoMixin {
  DenominationsDao(super.db);

  // Saves a denomination record in local storage.
  // Keeps the cash drawer configuration ready for the next read.
  Future<void> saveDenomination(DenominationsTableCompanion denomination) {
    return into(denominationsTable).insert(denomination);
  }

  // Replaces the cached denomination list with a fresh dataset.
  // Helps keep the local cash values aligned with the current setup.
  Future<void> replaceDenominations(
    List<DenominationsTableCompanion> denominations,
  ) {
    return transaction(() async {
      await delete(denominationsTable).go();
      await batch((batch) {
        batch.insertAll(denominationsTable, denominations);
      });
    });
  }

  // Reads all denominations from local storage.
  // Returns the full available denomination list for cashier flows.
  Future<List<DenominationsTableData>> getAllDenominations() {
    return select(denominationsTable).get();
  }

  // Watches the denomination list for live updates.
  // Useful for screens that react to changes in the cash setup.
  Stream<List<DenominationsTableData>> watchAllDenominations() {
    return select(denominationsTable).watch();
  }
}
