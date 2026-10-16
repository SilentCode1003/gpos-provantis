import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/addon_table.dart';

part 'addon_dao.g.dart';

@DriftAccessor(tables: [AddonTable])
class AddonDao extends DatabaseAccessor<AppDatabase> with _$AddonDaoMixin {
  AddonDao(super.db);

  /// Replaces the whole stored list with [rows] in one transaction, so an
  /// addon that is no longer active on the server disappears locally too.
  // Replaces the cached addon list with the most recent server snapshot.
  // Keeps inactive or removed addons from lingering in local storage.
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

  // Reads a single addon by its local database ID.
  // Returns null when the addon is not present in storage.
  Future<AddonTableData?> getAddonById(int id) {
    return (select(
      addonTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // Reads all addons in ascending name order.
  // Helps keep the UI sorted and easy to scan.
  Future<List<AddonTableData>> getAllAddons() {
    return (select(
      addonTable,
    )..orderBy([(t) => OrderingTerm.asc(t.name)])).get();
  }

  // Watches the addon list for live updates.
  // Useful for screens that need the current catalog instantly.
  Stream<List<AddonTableData>> watchAllAddons() {
    return (select(
      addonTable,
    )..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();
  }
}
