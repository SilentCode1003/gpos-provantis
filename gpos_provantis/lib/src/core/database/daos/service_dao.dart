import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/service_table.dart';

part 'service_dao.g.dart';

@DriftAccessor(tables: [ServiceTable])
class ServiceDao extends DatabaseAccessor<AppDatabase> with _$ServiceDaoMixin {
  ServiceDao(super.db);

  /// Replaces the whole stored list with [rows] in one transaction, so a
  /// service that is no longer active on the server disappears locally too.
  // Replaces the cached service list with the latest remote snapshot.
  // Keeps inactive or removed services from lingering in local storage.
  Future<void> replaceServices(List<ServiceTableCompanion> rows) {
    return transaction(() async {
      await delete(serviceTable).go();
      if (rows.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(serviceTable, rows);
        });
      }
    });
  }

  // Reads a single service by its local database ID.
  // Returns null when no matching service record exists.
  Future<ServiceTableData?> getServiceById(int id) {
    return (select(
      serviceTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // Reads all services in ascending name order.
  // Helps keep the service catalog sorted and easy to scan.
  Future<List<ServiceTableData>> getAllServices() {
    return (select(
      serviceTable,
    )..orderBy([(t) => OrderingTerm.asc(t.name)])).get();
  }

  // Watches the service list for live updates.
  // Useful for screens that need the current catalog as it changes.
  Stream<List<ServiceTableData>> watchAllServices() {
    return (select(
      serviceTable,
    )..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();
  }
}
