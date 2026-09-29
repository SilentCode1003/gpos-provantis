import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/denominations_table.dart';

part 'denominations_dao.g.dart';

@DriftAccessor(tables: [DenominationsTable])
class DenominationsDao extends DatabaseAccessor<AppDatabase>
    with _$DenominationsDaoMixin {
  DenominationsDao(super.db);

  Future<void> saveDenomination(DenominationsTableCompanion denomination) {
    return into(denominationsTable).insert(denomination);
  }

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

  Future<List<DenominationsTableData>> getAllDenominations() {
    return select(denominationsTable).get();
  }

  Stream<List<DenominationsTableData>> watchAllDenominations() {
    return select(denominationsTable).watch();
  }
}
