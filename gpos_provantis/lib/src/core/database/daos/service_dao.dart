import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/service_table.dart';

part 'service_dao.g.dart';

@DriftAccessor(tables: [ServiceTable])
class ServiceDao extends DatabaseAccessor<AppDatabase> with _$ServiceDaoMixin {
  ServiceDao(super.db);

  /// Replaces the whole stored list with [rows] in one transaction, so a
  /// service that is no longer active on the server disappears locally too.
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

  Future<ServiceTableData?> getServiceById(int id) {
    return (select(serviceTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<ServiceTableData>> getAllServices() {
    return (select(serviceTable)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Stream<List<ServiceTableData>> watchAllServices() {
    return (select(serviceTable)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }
}
