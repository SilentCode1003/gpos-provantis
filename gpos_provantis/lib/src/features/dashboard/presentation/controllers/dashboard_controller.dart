// Location: src/features/dashboard/controllers/dashboard_controller.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/providers/categories_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/product_price_dao_provider.dart';

part 'dashboard_controller.g.dart';

/// =========================================================================
/// DASHBOARD CONTROLLER — POS main screen state.
///
/// DATA SOURCE: categories and products are streamed live from the local
/// Drift database via `categoriesProvider`/`productPriceProvider`, which
/// in turn are kept in sync by `CategoriesRepository`/
/// `ProductPriceRepository` fetching from the API on login/sync. Both
/// streams go through an explicit `loading` / `error` / `data` state
/// (`CatalogLoadStatus`) rather than being collapsed into an empty list —
/// see `categoriesStatus`/`productsStatus` below. This matters because
/// "no rows yet" (still syncing, right after login) and "synced, and
/// there really are zero categories/products" need different UI: the
/// former should show a loading state, not an empty one.
///
/// Cart lives here (not in the widget tree) since it needs to persist
/// across category switches — switching categories only changes which
/// products are visible in the grid, it must never touch the cart.
///
/// CATALOG SHEET: tapping a category no longer swaps a grid in place —
/// it opens `catalogSheetCategoryId` (the right-side sheet's "which
/// category" state, separate from nothing else since there's no more
/// always-visible grid) and the screen slides in an overlay. Search text
/// (`catalogSearchQuery`) filters within whichever category is open.
/// Both reset to closed/empty together via `closeCatalogSheet()`.
/// =========================================================================

/// One purchasable item, mapped from a synced `ProductPriceTableData` row
/// — see `DashboardController.productsForCatalogSheet()`.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.stock,
  });

  final String id;
  final String name;
  final String categoryId;
  final double price;

  /// Units currently in stock, from the synced product-price row's
  /// `quantity` field.
  final int stock;
}

/// One product category — the tiles in the right-side category rail.
class Category {
  const Category({required this.id, required this.name, required this.icon});

  final String id;
  final String name;

  /// Name of a Material icon (e.g. 'water_drop_rounded') — kept as a
  /// string here so this model file doesn't need to import
  /// flutter/material.dart; the screen maps id -> IconData.
  final String icon;
}

/// One line in the cart — a product plus the quantity added.
class CartLine {
  const CartLine({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  double get lineTotal => product.price * quantity;

  CartLine copyWith({int? quantity}) =>
      CartLine(product: product, quantity: quantity ?? this.quantity);
}

/// Whether the cashier has an open shift. Gates checkout in a real
/// implementation (no sales without an open shift) — the state is wired
/// here now; that gating rule is left for whoever builds checkout.
enum ShiftStatus { closed, open }

/// Status of a synced catalog stream (categories, or products), separate
/// from "the list happens to be empty" — `loading` covers both the very
/// first emission after login (before the initial sync has written
/// anything to Drift yet) and any later re-sync; `error` covers the
/// stream throwing; `data` means the stream has emitted at least once
/// and didn't error, regardless of how many rows came back. UI should
/// gate its loading spinner / empty state off this, not off `isEmpty`.
enum CatalogLoadStatus { loading, error, data }

/// One tile inside the "Others" panel — secondary/less-frequent actions
/// that don't need to live in the always-visible top bar. Still a
/// hardcoded action set (`_placeholderOtherActions` below) — unlike
/// categories/products, these aren't backed by a repository yet.
class OtherAction {
  const OtherAction({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;

  /// Name of a Material icon — same string-keyed approach as `Category`,
  /// so this model file stays free of a flutter/material.dart import.
  final String icon;
}

/// Full dashboard state: which category is selected, and the cart's
/// current contents.
class DashboardState {
  const DashboardState({
    required this.selectedCategoryId,
    required this.cartLines,
    this.isSaleHeld = false,
    this.shiftStatus = ShiftStatus.closed,
    this.catalogSheetCategoryId,
    this.catalogSearchQuery = '',
  });

  final String selectedCategoryId;
  final List<CartLine> cartLines;

  /// Non-null while the right-side catalog sheet is open, holding the id
  /// of whichever category it's currently showing. Null = sheet closed.
  /// Kept separate from `selectedCategoryId` (which is really "last
  /// category tapped on the rail") so closing the sheet doesn't need to
  /// touch the rail's own selection highlight.
  final String? catalogSheetCategoryId;

  /// Live search text typed into the sheet's search field. Filters the
  /// sheet's product grid by name (case-insensitive substring match).
  /// Cleared whenever the sheet closes.
  final String catalogSearchQuery;

  bool get isCatalogSheetOpen => catalogSheetCategoryId != null;

  /// True once "Hold sale" has been tapped — placeholder flag only; a
  /// real implementation would move the sale into a held-sales list.
  final bool isSaleHeld;

  /// Whether the cashier has clocked in ("Start shift"). Toggled from
  /// the top bar — see `_TopBar` in the screen file.
  final ShiftStatus shiftStatus;

  double get subtotal => cartLines.fold(0, (sum, line) => sum + line.lineTotal);

  /// Flat placeholder tax rate — not real tax logic, just enough to make
  /// the cart footer look like a real receipt breakdown.
  double get tax => subtotal * 0.0825;

  double get total => subtotal + tax;

  int get itemCount => cartLines.fold(0, (sum, line) => sum + line.quantity);

  DashboardState copyWith({
    String? selectedCategoryId,
    List<CartLine>? cartLines,
    bool? isSaleHeld,
    ShiftStatus? shiftStatus,
    // Sentinel-based so we can distinguish "leave unchanged" (default,
    // not passed) from "explicitly set to null" (closing the sheet) —
    // a plain `catalogSheetCategoryId ?? this.catalogSheetCategoryId`
    // could never null the field back out once set.
    Object? catalogSheetCategoryId = _unset,
    String? catalogSearchQuery,
  }) {
    return DashboardState(
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      cartLines: cartLines ?? this.cartLines,
      isSaleHeld: isSaleHeld ?? this.isSaleHeld,
      shiftStatus: shiftStatus ?? this.shiftStatus,
      catalogSheetCategoryId: identical(catalogSheetCategoryId, _unset)
          ? this.catalogSheetCategoryId
          : catalogSheetCategoryId as String?,
      catalogSearchQuery: catalogSearchQuery ?? this.catalogSearchQuery,
    );
  }
}

/// Sentinel for the `copyWith` nullable-field trick above — a private
/// unique value that can never collide with a real argument.
const Object _unset = Object();

const _placeholderOtherActions = [
  OtherAction(id: 'discounts', label: 'Discounts', icon: 'percent_rounded'),
  OtherAction(
    id: 'payment_methods',
    label: 'Payment Methods',
    icon: 'credit_card_rounded',
  ),
  OtherAction(id: 'void_sale', label: 'Void Sale', icon: 'block_rounded'),
  OtherAction(id: 'price_check', label: 'Price Check', icon: 'search_rounded'),
  OtherAction(id: 'open_drawer', label: 'Open Drawer', icon: 'inbox_rounded'),
  OtherAction(
    id: 'customer_lookup',
    label: 'Customer Lookup',
    icon: 'person_search_rounded',
  ),
  OtherAction(
    id: 'order_notes',
    label: 'Order Notes',
    icon: 'sticky_note_2_rounded',
  ),
  OtherAction(
    id: 'returns',
    label: 'Returns',
    icon: 'assignment_return_rounded',
  ),
  OtherAction(
    id: 'gift_cards',
    label: 'Gift Cards',
    icon: 'card_giftcard_rounded',
  ),
  OtherAction(
    id: 'tax_exempt',
    label: 'Tax Exempt',
    icon: 'receipt_long_rounded',
  ),
  OtherAction(
    id: 'print_last_receipt',
    label: 'Print Last Receipt',
    icon: 'print_rounded',
  ),
  OtherAction(
    id: 'end_of_day_report',
    label: 'End of Day Report',
    icon: 'summarize_rounded',
  ),
  OtherAction(id: 'loyalty', label: 'Loyalty', icon: 'loyalty_rounded'),
];

String _categoryIconForName(String categoryName) {
  final normalized = categoryName.toLowerCase();

  if (normalized.contains('drink') || normalized.contains('beverage')) {
    return 'local_drink_rounded';
  }
  if (normalized.contains('food') || normalized.contains('snack')) {
    return 'restaurant_rounded';
  }
  if (normalized.contains('paper') || normalized.contains('clean')) {
    return 'cleaning_services_rounded';
  }
  if (normalized.contains('promo') || normalized.contains('offer')) {
    return 'local_offer_rounded';
  }
  if (normalized.contains('fruit') || normalized.contains('veg')) {
    return 'eco_rounded';
  }
  if (normalized.contains('material')) {
    return 'construction_rounded';
  }
  return 'category_rounded';
}

double _parseMoney(String value) {
  final sanitized = value.replaceAll(RegExp(r'[^0-9.-]'), '');
  if (sanitized.isEmpty) return 0;
  return double.tryParse(sanitized) ?? 0;
}

@riverpod
class DashboardController extends _$DashboardController {
  AsyncValue<List<CategoriesTableData>> _categoriesAsync() =>
      ref.watch(categoriesProvider);

  AsyncValue<List<ProductPriceTableData>> _productsAsync() =>
      ref.watch(productPriceProvider);

  // maybeWhen (not the newer `.valueOrNull` getter) so this keeps
  // compiling against older riverpod versions too — functionally the
  // same thing: fall through to the last-known data on loading/error,
  // or an empty list if there's no data yet at all.
  List<CategoriesTableData> _watchCategories() => _categoriesAsync().maybeWhen(
    data: (items) => items,
    orElse: () => const <CategoriesTableData>[],
  );

  List<ProductPriceTableData> _watchProducts() => _productsAsync().maybeWhen(
    data: (items) => items,
    orElse: () => const <ProductPriceTableData>[],
  );

  @override
  DashboardState build() {
    final syncedCategories = _watchCategories();
    final firstCategoryId = syncedCategories.isNotEmpty
        ? syncedCategories.first.categoryCode.toString()
        : '';

    return DashboardState(
      selectedCategoryId: firstCategoryId,
      cartLines: const [],
    );
  }

  /// Status of the categories stream — see `CatalogLoadStatus` doc
  /// comment. `loading` here is what should keep the category grid
  /// showing a spinner instead of "No categories yet" right after
  /// login, before the first sync has written anything to Drift.
  CatalogLoadStatus get categoriesStatus => _categoriesAsync().when(
    data: (_) => CatalogLoadStatus.data,
    error: (_, __) => CatalogLoadStatus.error,
    loading: () => CatalogLoadStatus.loading,
  );

  /// Status of the products stream — same idea as `categoriesStatus`,
  /// but for whatever's synced into `ProductPriceTableData`.
  CatalogLoadStatus get productsStatus => _productsAsync().when(
    data: (_) => CatalogLoadStatus.data,
    error: (_, __) => CatalogLoadStatus.error,
    loading: () => CatalogLoadStatus.loading,
  );

  List<Category> get categories {
    final rows = _watchCategories();
    return rows
        .where(
          (row) =>
              row.categoryName.trim().isNotEmpty &&
              row.categoryName.toLowerCase() != 'material',
        )
        .map(
          (row) => Category(
            id: row.categoryCode.toString(),
            name: row.categoryName,
            icon: _categoryIconForName(row.categoryName),
          ),
        )
        .toList();
  }

  List<OtherAction> get otherActions => _placeholderOtherActions;

  /// Products for whichever category the catalog sheet currently has
  /// open, filtered by `catalogSearchQuery` (case-insensitive substring
  /// match on name). Returns an empty list if the sheet is closed —
  /// callers should be gated on `isCatalogSheetOpen` anyway.
  List<Product> productsForCatalogSheet() {
    final categoryId = state.catalogSheetCategoryId;
    if (categoryId == null) return const [];

    final query = state.catalogSearchQuery.trim().toLowerCase();
    final rows = _watchProducts();
    return rows
        .where(
          (row) =>
              row.category.toString() == categoryId &&
              row.description.trim().isNotEmpty &&
              (query.isEmpty || row.description.toLowerCase().contains(query)),
        )
        .map(
          (row) => Product(
            id: row.productId.toString(),
            name: row.description,
            categoryId: row.category.toString(),
            price: _parseMoney(row.price),
            stock: row.quantity,
          ),
        )
        .toList();
  }

  /// Tapping a category tile: opens the sheet on that category (or, if
  /// the sheet is already open, just swaps which category it's showing
  /// — no close/reopen transition for the rapid tap-tap-tap flow).
  void selectCategory(String categoryId) {
    state = state.copyWith(
      selectedCategoryId: categoryId,
      catalogSheetCategoryId: categoryId,
    );
  }

  /// Closes the sheet and clears search — used by the scrim tap, the
  /// drag-to-dismiss gesture, and the sheet's own close affordance.
  void closeCatalogSheet() {
    state = state.copyWith(
      catalogSheetCategoryId: null,
      catalogSearchQuery: '',
    );
  }

  void setCatalogSearchQuery(String query) {
    state = state.copyWith(catalogSearchQuery: query);
  }

  void toggleShift() {
    state = state.copyWith(
      shiftStatus: state.shiftStatus == ShiftStatus.open
          ? ShiftStatus.closed
          : ShiftStatus.open,
    );
  }

  void toggleHold() {
    state = state.copyWith(isSaleHeld: !state.isSaleHeld);
  }

  void addToCart(Product product) {
    final existingIndex = state.cartLines.indexWhere(
      (line) => line.product.id == product.id,
    );

    if (existingIndex == -1) {
      state = state.copyWith(
        cartLines: [
          ...state.cartLines,
          CartLine(product: product, quantity: 1),
        ],
      );
      return;
    }

    final updated = [...state.cartLines];
    updated[existingIndex] = updated[existingIndex].copyWith(
      quantity: updated[existingIndex].quantity + 1,
    );
    state = state.copyWith(cartLines: updated);
  }

  void incrementLine(String productId) {
    final updated = state.cartLines.map((line) {
      if (line.product.id != productId) return line;
      return line.copyWith(quantity: line.quantity + 1);
    }).toList();
    state = state.copyWith(cartLines: updated);
  }

  void decrementLine(String productId) {
    final updated = <CartLine>[];
    for (final line in state.cartLines) {
      if (line.product.id != productId) {
        updated.add(line);
        continue;
      }
      if (line.quantity > 1) {
        updated.add(line.copyWith(quantity: line.quantity - 1));
      }
      // quantity would hit 0 — drop the line entirely
    }
    state = state.copyWith(cartLines: updated);
  }

  void removeLine(String productId) {
    state = state.copyWith(
      cartLines: state.cartLines
          .where((line) => line.product.id != productId)
          .toList(),
    );
  }

  /// Empties the entire cart in one call — backs a "Remove all" action
  /// in the cart UI so the cashier isn't stuck removing lines one at a
  /// time to start a sale over. A plain `cartLines: const []` rather
  /// than looping `removeLine` for each line: same end state, without
  /// rebuilding the list once per line for no reason.
  void clearCart() {
    state = state.copyWith(cartLines: const []);
  }
}
