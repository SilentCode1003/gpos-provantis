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
  // Replaces the cached service package list with the latest remote snapshot.
  // Keeps inactive or removed packages from lingering in local storage.
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

  // Reads a single service package by its local database ID.
  // Returns null when no matching package exists in storage.
  Future<ServicePackageTableData?> getServicePackageById(int id) {
    return (select(
      servicePackageTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // Reads all service packages in ascending name order.
  // Helps keep the package catalog sorted and easy to scan.
  Future<List<ServicePackageTableData>> getAllServicePackages() {
    return (select(
      servicePackageTable,
    )..orderBy([(t) => OrderingTerm.asc(t.name)])).get();
  }

  // Watches the service package list for live updates.
  // Useful for screens that need the current catalog as it changes.
  Stream<List<ServicePackageTableData>> watchAllServicePackages() {
    return (select(
      servicePackageTable,
    )..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();
  }
}
