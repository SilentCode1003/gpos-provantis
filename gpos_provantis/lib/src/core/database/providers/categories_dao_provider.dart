import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpos_provantis/src/core/database/daos/categories_dao.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';

part 'categories_dao_provider.g.dart';

@Riverpod(keepAlive: true)
CategoriesDao categoriesDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return CategoriesDao(db);
}

final categoriesProvider =
    StreamNotifierProvider<CategoriesNotifier, List<CategoriesTableData>>(
      CategoriesNotifier.new,
    );

class CategoriesNotifier extends StreamNotifier<List<CategoriesTableData>> {
  @override
  Stream<List<CategoriesTableData>> build() {
    final dao = ref.watch(categoriesDaoProvider);
    return dao.watchAllCategories();
  }
}
