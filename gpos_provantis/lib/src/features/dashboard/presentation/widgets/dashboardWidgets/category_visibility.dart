import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';

export 'package:gpos_provantis/src/features/settings/presentation/controllers/app_settings_controller.dart'
    show appSettingsProvider, hiddenCategoryCodesProvider;

bool isCategoryIdHidden(String? categoryId, Set<int> hiddenCodes) {
  if (categoryId == null || hiddenCodes.isEmpty) return false;
  final code = int.tryParse(categoryId);
  return code != null && hiddenCodes.contains(code);
}

List<Category> filterVisibleCategories(
  List<Category> all,
  Set<int> hiddenCodes,
) {
  if (hiddenCodes.isEmpty) return all;
  return all.where((c) => !isCategoryIdHidden(c.id, hiddenCodes)).toList();
}
