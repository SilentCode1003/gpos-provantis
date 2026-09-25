import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sales_table.dart';

part 'sales_dao.g.dart';

@DriftAccessor(tables: [SalesTable])
class SalesDao extends DatabaseAccessor<AppDatabase> with _$SalesDaoMixin {
  SalesDao(super.db);

  Future<void> saveSale(SalesTableCompanion sale) {
    return into(salesTable).insertOnConflictUpdate(sale);
  }

  Future<void> replaceSales(List<SalesTableCompanion> sales) {
    return transaction(() async {
      await delete(salesTable).go();
      await batch((batch) {
        batch.insertAll(salesTable, sales);
      });
    });
  }

  Future<List<SalesTableData>> getAllSales() {
    return select(salesTable).get();
  }

  Stream<List<SalesTableData>> watchAllSales() {
    return select(salesTable).watch();
  }

  Future<List<SalesTableData>> getUnsyncedSales() {
    return (select(salesTable)
          ..where((row) => row.isSync.equals('0'))
          ..orderBy([
            (row) =>
                OrderingTerm(expression: row.createdAt, mode: OrderingMode.asc),
          ]))
        .get();
  }

  Future<void> markSynced(String id) {
    return (update(salesTable)..where((row) => row.id.equals(id))).write(
      const SalesTableCompanion(isSync: Value('1')),
    );
  }
}
