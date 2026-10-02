import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/addon_table.dart';

part 'addon_dao.g.dart';

@DriftAccessor(tables: [AddonTable])
class AddonDao extends DatabaseAccessor<AppDatabase> with _$AddonDaoMixin {
  AddonDao(super.db);

  /// Replaces the whole stored list with [rows] in one transaction, so an
  /// addon that is no longer active on the server disappears locally too.
  Future<void> replaceAddons(List<AddonTableCompanion> rows) {
    return transaction(() async {
      await delete(addonTable).go();
      if (rows.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(addonTable, rows);
        });
      }
    });
  }

  Future<AddonTableData?> getAddonById(int id) {
    return (select(
      addonTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<AddonTableData>> getAllAddons() {
    return (select(
      addonTable,
    )..orderBy([(t) => OrderingTerm.asc(t.name)])).get();
  }

  Stream<List<AddonTableData>> watchAllAddons() {
    return (select(
      addonTable,
    )..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();
  }
}
