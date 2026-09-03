import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/categories_table.dart';

part 'categories_dao.g.dart';

@DriftAccessor(tables: [CategoriesTable])
class CategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriesDaoMixin {
  CategoriesDao(super.db);

  Future<void> saveCategory(CategoriesTableCompanion category) {
    return into(categoriesTable).insertOnConflictUpdate(category);
  }

  Future<void> replaceCategories(List<CategoriesTableCompanion> categories) {
    return transaction(() async {
      await delete(categoriesTable).go();
      await batch((batch) {
        batch.insertAll(categoriesTable, categories);
      });
    });
  }

  Future<List<CategoriesTableData>> getAllCategories() {
    return select(categoriesTable).get();
  }

  Stream<List<CategoriesTableData>> watchAllCategories() {
    return select(categoriesTable).watch();
  }
}
