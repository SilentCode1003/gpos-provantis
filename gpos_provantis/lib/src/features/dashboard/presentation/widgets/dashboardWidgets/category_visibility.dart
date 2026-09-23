// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/category_visibility.dart
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';

// The dashboard widgets only need to import this one file: it hands them
// the hidden-category settings along with the filtering helpers below.
export 'package:gpos_provantis/src/features/settings/presentation/controllers/app_settings_controller.dart'
    show appSettingsProvider, hiddenCategoryCodesProvider;

/// =========================================================================
/// CATEGORY VISIBILITY — applies Settings > Counter Display to the
/// dashboard.
///
/// The settings screen stores the category codes the user turned OFF (see
/// `CounterDisplayCodec`). Hiding a category hides everything under it: its
/// tile in the category grid, its chip in the sheet's category strip, and —
/// since products are only reachable through their category — its products.
/// =========================================================================

/// True when [categoryId] belongs to a category the user has hidden.
///
/// ASSUMPTION (the only one in this feature): `Category.id` is the category
/// code written as text, e.g. code 12 -> '12'. If the dashboard controller
/// builds its ids some other way, this is the one place to change.
bool isCategoryIdHidden(String? categoryId, Set<int> hiddenCodes) {
  if (categoryId == null || hiddenCodes.isEmpty) return false;
  final code = int.tryParse(categoryId);
  return code != null && hiddenCodes.contains(code);
}

/// [all] without the hidden categories, original order kept.
List<Category> filterVisibleCategories(
  List<Category> all,
  Set<int> hiddenCodes,
) {
  if (hiddenCodes.isEmpty) return all;
  return all.where((c) => !isCategoryIdHidden(c.id, hiddenCodes)).toList();
}
