import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/service_package_table.dart';

part 'service_package_dao.g.dart';

@DriftAccessor(tables: [ServicePackageTable])
class ServicePackageDao extends DatabaseAccessor<AppDatabase>
    with _$ServicePackageDaoMixin {
  ServicePackageDao(super.db);

  /// Replaces the whole stored list with [rows] in one transaction, so a
  /// package that is no longer active on the server disappears locally too.
  Future<void> replaceServicePackages(List<ServicePackageTableCompanion> rows) {
    return transaction(() async {
      await delete(servicePackageTable).go();
      if (rows.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(servicePackageTable, rows);
        });
      }
    });
  }

  Future<ServicePackageTableData?> getServicePackageById(int id) {
    return (select(
      servicePackageTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<ServicePackageTableData>> getAllServicePackages() {
    return (select(
      servicePackageTable,
    )..orderBy([(t) => OrderingTerm.asc(t.name)])).get();
  }

  Stream<List<ServicePackageTableData>> watchAllServicePackages() {
    return (select(
      servicePackageTable,
    )..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();
  }
}
