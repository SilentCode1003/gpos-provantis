import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/denomination_table.dart';

part 'denomination_dao.g.dart';

@DriftAccessor(tables: [DenominationTable])
class DenominationDao extends DatabaseAccessor<AppDatabase>
    with _$DenominationDaoMixin {
  DenominationDao(super.db);

  Future<void> saveDenomination(DenominationTableData denomination) {
    return into(denominationTable).insert(denomination);
  }

  Future<List<DenominationTableData>> getAllDenominations() {
    return select(denominationTable).get();
  }

  Stream<List<DenominationTableData>> watchAllDenominations() {
    return select(denominationTable).watch();
  }
}
