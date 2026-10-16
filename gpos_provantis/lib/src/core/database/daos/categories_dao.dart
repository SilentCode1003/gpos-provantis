import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/categories_table.dart';

part 'categories_dao.g.dart';

@DriftAccessor(tables: [CategoriesTable])
class CategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriesDaoMixin {
  CategoriesDao(super.db);

  // Saves a category row with conflict handling.
  // Keeps the app catalog current after a sync or update.
  Future<void> saveCategory(CategoriesTableCompanion category) {
    return into(categoriesTable).insertOnConflictUpdate(category);
  }

  // Replaces the cached category list with a fresh dataset.
  // Used to refresh the local product classification catalog.
  Future<void> replaceCategories(List<CategoriesTableCompanion> categories) {
    return transaction(() async {
      await delete(categoriesTable).go();
      await batch((batch) {
        batch.insertAll(categoriesTable, categories);
      });
    });
  }

  // Reads all categories from local storage.
  // Returns the full category catalog currently cached on device.
  Future<List<CategoriesTableData>> getAllCategories() {
    return select(categoriesTable).get();
  }

  // Watches the category list for live updates.
  // Useful for screens that react to catalog changes immediately.
  Stream<List<CategoriesTableData>> watchAllCategories() {
    return select(categoriesTable).watch();
  }
}
