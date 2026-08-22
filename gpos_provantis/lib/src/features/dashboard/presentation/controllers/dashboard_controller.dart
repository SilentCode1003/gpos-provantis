// Location: src/features/dashboard/controllers/dashboard_controller.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_controller.g.dart';

/// =========================================================================
/// DASHBOARD CONTROLLER — POS main screen state.
///
/// PLACEHOLDER DATA: `_placeholderCatalog` below is hardcoded sample
/// inventory (fake names/prices/stock) so the screen has something real
/// to render. Swap `_placeholderCatalog` for an actual inventory
/// repository call once product data exists — the shape (`Category` +
/// `Product`) is meant to survive that swap; only the source changes.
///
/// Cart lives here (not in the widget tree) since it needs to persist
/// across category switches — switching categories only changes which
/// products are visible in the grid, it must never touch the cart.
/// =========================================================================

/// One purchasable item. Placeholder data — see class doc comment above.
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

  /// Units currently in stock. Placeholder — a real inventory feed would
  /// drive this instead of a fixed number.
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

/// One tile inside the "Others" panel — secondary/less-frequent actions
/// that don't need to live in the always-visible top bar. Placeholder
/// action set — see `_placeholderOtherActions` below.
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
  });

  final String selectedCategoryId;
  final List<CartLine> cartLines;

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
  }) {
    return DashboardState(
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      cartLines: cartLines ?? this.cartLines,
      isSaleHeld: isSaleHeld ?? this.isSaleHeld,
      shiftStatus: shiftStatus ?? this.shiftStatus,
    );
  }
}

// ---------------------------------------------------------------------
// PLACEHOLDER CATALOG — fake categories/products for an outdoor stone +
// water-feature store (fountains, statuary, boulders, stone furniture,
// garden decor, paint/sealants). Replace with a real repository later.
// ---------------------------------------------------------------------

const _placeholderCategories = [
  Category(id: 'fountains', name: 'Fountains', icon: 'water_drop_rounded'),
  Category(id: 'statuary', name: 'Statuary', icon: 'account_balance_rounded'),
  Category(id: 'rocks', name: 'Rocks & Boulders', icon: 'landscape_rounded'),
  Category(id: 'furniture', name: 'Stone Furniture', icon: 'chair_rounded'),
  Category(id: 'planters', name: 'Planters & Urns', icon: 'yard_rounded'),
  Category(id: 'decor', name: 'Garden Decor', icon: 'park_rounded'),
  Category(id: 'paint', name: 'Paint & Sealants', icon: 'format_paint_rounded'),
];

const _placeholderProducts = [
  // Fountains
  Product(
    id: 'p1',
    name: 'Cascading Tier Fountain',
    categoryId: 'fountains',
    price: 649.00,
    stock: 4,
  ),
  Product(
    id: 'p2',
    name: 'Wall-Mount Lion Fountain',
    categoryId: 'fountains',
    price: 389.00,
    stock: 7,
  ),
  Product(
    id: 'p3',
    name: 'Millstone Bubbler',
    categoryId: 'fountains',
    price: 275.00,
    stock: 12,
  ),
  Product(
    id: 'p4',
    name: 'Ceramic Urn Fountain',
    categoryId: 'fountains',
    price: 420.00,
    stock: 3,
  ),
  // Statuary
  Product(
    id: 'p5',
    name: 'Classical Garden Angel',
    categoryId: 'statuary',
    price: 310.00,
    stock: 6,
  ),
  Product(
    id: 'p6',
    name: 'Sitting Fox Statue',
    categoryId: 'statuary',
    price: 145.00,
    stock: 15,
  ),
  Product(
    id: 'p7',
    name: 'Large Buddha Statue',
    categoryId: 'statuary',
    price: 520.00,
    stock: 2,
  ),
  // Rocks & Boulders
  Product(
    id: 'p8',
    name: 'Decorative River Rock (per bag)',
    categoryId: 'rocks',
    price: 18.50,
    stock: 80,
  ),
  Product(
    id: 'p9',
    name: 'Landscape Boulder — Medium',
    categoryId: 'rocks',
    price: 95.00,
    stock: 20,
  ),
  Product(
    id: 'p10',
    name: 'Landscape Boulder — Large',
    categoryId: 'rocks',
    price: 210.00,
    stock: 9,
  ),
  Product(
    id: 'p11',
    name: 'Flagstone Paver (each)',
    categoryId: 'rocks',
    price: 12.00,
    stock: 150,
  ),
  // Stone Furniture
  Product(
    id: 'p12',
    name: 'Granite Bistro Table',
    categoryId: 'furniture',
    price: 780.00,
    stock: 3,
  ),
  Product(
    id: 'p13',
    name: 'Stone Garden Bench',
    categoryId: 'furniture',
    price: 340.00,
    stock: 8,
  ),
  Product(
    id: 'p14',
    name: 'Carved Stone Stool (pair)',
    categoryId: 'furniture',
    price: 190.00,
    stock: 11,
  ),
  // Planters & Urns
  Product(
    id: 'p15',
    name: 'Weathered Stone Planter',
    categoryId: 'planters',
    price: 88.00,
    stock: 25,
  ),
  Product(
    id: 'p16',
    name: 'Tall Garden Urn',
    categoryId: 'planters',
    price: 132.00,
    stock: 14,
  ),
  // Garden Decor
  Product(
    id: 'p17',
    name: 'Solar Pathway Lights (set of 4)',
    categoryId: 'decor',
    price: 42.00,
    stock: 40,
  ),
  Product(
    id: 'p18',
    name: 'Artificial Prop Tree — 6ft',
    categoryId: 'decor',
    price: 165.00,
    stock: 10,
  ),
  Product(
    id: 'p19',
    name: 'Faux Grass Turf Panel',
    categoryId: 'decor',
    price: 54.00,
    stock: 30,
  ),
  Product(
    id: 'p20',
    name: 'Wind Chime — Copper',
    categoryId: 'decor',
    price: 36.00,
    stock: 22,
  ),
  // Paint & Sealants
  Product(
    id: 'p21',
    name: 'Stone Sealant — 1 Gallon',
    categoryId: 'paint',
    price: 29.99,
    stock: 45,
  ),
  Product(
    id: 'p22',
    name: 'Concrete Statue Paint',
    categoryId: 'paint',
    price: 16.50,
    stock: 60,
  ),
  Product(
    id: 'p23',
    name: 'Waterproof Fountain Coating',
    categoryId: 'paint',
    price: 34.00,
    stock: 18,
  ),
];

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

@riverpod
class DashboardController extends _$DashboardController {
  @override
  DashboardState build() {
    return DashboardState(
      selectedCategoryId: _placeholderCategories.first.id,
      cartLines: const [],
    );
  }

  List<Category> get categories => _placeholderCategories;

  List<OtherAction> get otherActions => _placeholderOtherActions;

  List<Product> productsForSelectedCategory() {
    return _placeholderProducts
        .where((p) => p.categoryId == state.selectedCategoryId)
        .toList();
  }

  void selectCategory(String categoryId) {
    state = state.copyWith(selectedCategoryId: categoryId);
  }

  void toggleShift() {
    state = state.copyWith(
      shiftStatus: state.shiftStatus == ShiftStatus.open
          ? ShiftStatus.closed
          : ShiftStatus.open,
    );
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

  void clearCart() {
    state = state.copyWith(cartLines: const []);
  }

  void toggleHold() {
    state = state.copyWith(isSaleHeld: !state.isSaleHeld);
  }
}
