// Location: src/features/dashboard/controllers/dashboard_controller.dart
import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/providers/categories_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/product_price_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/discounts_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/sales_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/tables/sales_table.dart';
import 'package:gpos_provantis/src/core/database/daos/pos_detail_id_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_detail_id_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_config_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_shift_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/branch_config_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/user_data_dao_provider.dart';
// TODO: confirm this path — inferred from pos_shift_repository.dart's own
// `import '../domain/pos_shift_dto.dart';`, which implies the repository
// file sits in a sibling folder to `domain` (e.g. `.../data/pos_shift_repository.dart`
// or `.../repositories/pos_shift_repository.dart`). Adjust to match
// wherever that file actually lives in the project.
import 'package:gpos_provantis/src/core/database/repository/pos_shift_repository.dart';
import 'payments_controller.dart';
import 'package:gpos_provantis/src/core/printutil/receipt_generator.dart'
    show
        ReceiptGenerator,
        ReceiptSaleData,
        ReceiptLineItem,
        receiptGeneratorProvider;

part 'dashboard_controller.g.dart';

/// ID + full name captured for discounts that legally require recording
/// who the discount was given to (PWD, Senior Citizen) — see
/// `_discountRequiresCustomerInfo` for how a discount is recognized as
/// one of these. Immutable and small on purpose: this only ever needs
/// to travel from the discount-picker sheet into `DashboardState` and
/// then into one JSON object in `_buildDiscountDetailJson`.
class DiscountCustomerInfo {
  const DiscountCustomerInfo({required this.id, required this.fullName});

  final String id;
  final String fullName;
}

/// Whether [discount] is the kind that legally requires an ID + full
/// name to be recorded against it (PWD, Senior Citizen) — matched by
/// keyword against `discount.name` rather than a dedicated flag column,
/// since the discounts synced from the server don't carry one and the
/// exact wording/casing of a given discount's name isn't fixed (e.g.
/// "PWD", "pwd", "Person's with Disability", "Senior", "Senior
/// Citizen" all need to match).
///
/// This is a heuristic, not a guarantee: a discount that happens to be
/// named e.g. "Non-PWD Promo" or "Senior Staff Bonus" would also match
/// and incorrectly prompt for customer info. If that ever becomes a
/// real problem, the real fix is a dedicated column on the discounts
/// table, not a smarter keyword list here.
bool _discountRequiresCustomerInfo(DiscountsTableData discount) {
  // Lowercase and drop apostrophes so "Person's" / "Persons" both
  // normalize the same way before the substring checks below.
  final normalized = discount.name.toLowerCase().replaceAll("'", '');

  final isSenior = normalized.contains('senior');

  // "pwd" as a literal acronym, OR the spelled-out form — checked as
  // two separate word-fragments ("person"/"disab") rather than one
  // fixed phrase, since "person" vs "persons" and "disability" vs
  // "disabilities"/"disabled" all need to match without enumerating
  // every combination.
  final isPwd =
      normalized.contains('pwd') ||
      (normalized.contains('person') && normalized.contains('disab'));

  return isSenior || isPwd;
}

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
/// (receipts, reports, cash management, sync, etc) that don't need to
/// live in the always-visible top bar. Still a hardcoded action set
/// (`_placeholderOtherActions` below) — unlike categories/products,
/// these aren't backed by a repository yet.
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
    this.selectedDiscount,
    this.selectedDiscountCustomerInfo,
    this.shiftStatus = ShiftStatus.closed,
    this.isTogglingShift = false,
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

  /// Whichever discount the cashier picked from the discount sheet, or
  /// null if none is applied. Kept as the full row (not just a rate)
  /// so the footer can show the discount's name alongside its amount.
  final DiscountsTableData? selectedDiscount;

  bool get hasDiscount => selectedDiscount != null;

  /// ID + full name captured for the currently-applied discount, when
  /// that discount requires it (see `_discountRequiresCustomerInfo`).
  /// Null for a regular discount, or before it's been filled in. Kept
  /// as a separate field from `selectedDiscount` rather than folded
  /// into it, since `DiscountsTableData` is a Drift-generated row type
  /// with no room for POS-only fields like this.
  final DiscountCustomerInfo? selectedDiscountCustomerInfo;

  /// Whether the cashier has clocked in ("Start shift"). Legacy/local
  /// field — `DashboardController.shiftStatus` (the getter, not this
  /// field) is the real source of truth now, derived live off
  /// `pos_shift`. This field is kept around for `copyWith` compat but
  /// the UI should read the controller's getter, not this.
  final ShiftStatus shiftStatus;

  /// True while a start-shift/end-shift API call is in flight — drives
  /// the shift button's loading spinner and disables it so a second
  /// tap can't fire a duplicate request while the first is still
  /// resolving. Set/cleared entirely by `toggleShift()`.
  final bool isTogglingShift;

  double get subtotal => cartLines.fold(0, (sum, line) => sum + line.lineTotal);

  /// The figure the discount rate multiplies against. No tax is applied
  /// — this is just the subtotal, kept as its own getter (rather than
  /// discount math reading `subtotal` directly) so nothing downstream
  /// needs to change if a pre-discount adjustment is ever reintroduced.
  double get preDiscountTotal => subtotal;

  /// Discount rate as a fraction (e.g. a stored `rate` of 20 -> 0.20).
  /// Discounts are stored as whole-number percentages in the DB, so the
  /// conversion happens here, in one place, rather than at every call
  /// site that needs the fraction.
  double get discountRate =>
      selectedDiscount == null ? 0 : selectedDiscount!.rate / 100;

  /// Peso amount knocked off by the discount — always computed off
  /// [preDiscountTotal], never off the subtotal alone and never
  /// accumulated line-by-line. Because it's derived fresh from the
  /// total every time, it doesn't matter whether the discount was
  /// picked before or after products were added, or in what order
  /// lines/quantities changed afterward — the result is identical
  /// either way.
  double get discountAmount => preDiscountTotal * discountRate;

  /// Grand total after the discount is applied. `Total * discount` is
  /// intentionally the *only* place the discount rate is used — nothing
  /// upstream (subtotal) ever sees it, so re-ordering "add product" vs
  /// "apply discount" actions can never change the result.
  double get total => preDiscountTotal - discountAmount;

  int get itemCount => cartLines.fold(0, (sum, line) => sum + line.quantity);

  DashboardState copyWith({
    String? selectedCategoryId,
    List<CartLine>? cartLines,
    // Sentinel-based so we can distinguish "leave unchanged" (default,
    // not passed) from "explicitly set to null" (clearing the
    // discount) — a plain `selectedDiscount ?? this.selectedDiscount`
    // could never null the field back out once set.
    Object? selectedDiscount = _unset,
    Object? selectedDiscountCustomerInfo = _unset,
    ShiftStatus? shiftStatus,
    bool? isTogglingShift,
    // Same sentinel trick as above, for closing the catalog sheet.
    Object? catalogSheetCategoryId = _unset,
    String? catalogSearchQuery,
  }) {
    return DashboardState(
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      cartLines: cartLines ?? this.cartLines,
      selectedDiscount: identical(selectedDiscount, _unset)
          ? this.selectedDiscount
          : selectedDiscount as DiscountsTableData?,
      selectedDiscountCustomerInfo:
          identical(selectedDiscountCustomerInfo, _unset)
          ? this.selectedDiscountCustomerInfo
          : selectedDiscountCustomerInfo as DiscountCustomerInfo?,
      shiftStatus: shiftStatus ?? this.shiftStatus,
      isTogglingShift: isTogglingShift ?? this.isTogglingShift,
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

/// =========================================================================
/// SALE CREATION — turns the current cart + a resolved payment into one
/// row in `SalesTable`, matching the flat/stringly-typed shape the sync
/// layer expects (see sales_table.dart / the sales-flow spec).
///
/// SCOPE RIGHT NOW: CASH, single E-payment, and SPLIT (Cash + one
/// E-payment) are wired up — see `createSaleFromCash`,
/// `createSaleFromEPayment`, and `createSaleFromCashEPaymentSplit`. Split
/// E-payment + E-payment is the only tender shape still unhandled.
///
/// PLACEHOLDERS: everything from local data sources is real now
/// (detailId, posId, shift, cashier, branch, and the discount line's
/// `customerinfo` — see `discount_picker_sheet.dart`). What's still not
/// wired up is the *upload/sync* half of the spec: pushing `isSync == 0`
/// rows to the server, then pulling the server's detail ID afterward and
/// prompting the user to resolve a mismatch against the local one —
/// see `PosDetailIdDao.consumeAndIncrementDetailId`'s doc comment for
/// the full spec that method only partially covers. That sync/reconcile
/// step remains a separate, not-yet-built piece of work.
/// =========================================================================

/// -- Local data-source resolvers -----------------------------------------
/// Every function in this block reads one piece of required sale context
/// from a local DAO and validates it's not still sitting at the table's
/// own empty-state default before handing it back. Called from the two
/// createSaleFrom* methods below, before anything is written or any
/// detail ID is consumed.

/// TODO: detailId itself is real (see
/// `PosDetailIdDao.consumeAndIncrementDetailId()`, called directly from
/// `createSaleFromCash`/`createSaleFromCashEPaymentSplit` below) but the
/// spec's other half — the upload/sync step that pulls the server's
/// detail ID after uploading sales and prompts the user to resolve a
/// mismatch — is still a separate, not-yet-built piece of work, not
/// something sale-creation itself does.
///
/// STATUS: posId, shift, cashier and branch are all real now — see
/// `_PosIdentity.resolve`, `_resolveCashier`, `_resolveBranch` below.

/// Resolves the cashier name from `user_data.fullName` — the logged-in
/// user on this device. Throws [PosIdentityUnavailableException] if
/// there's no row yet, or the row still holds the table's own
/// `'INVALID USER'` default (no one's actually logged in).
Future<String> _resolveCashier(Ref ref) async {
  final user = await ref.read(userDataDaoProvider).getUser();
  final fullName = user?.fullName;
  if (fullName == null || fullName.isEmpty || fullName == 'INVALID USER') {
    throw const PosIdentityUnavailableException(
      'No user is logged in — cannot resolve a cashier name for this sale.',
    );
  }
  return fullName;
}

/// Resolves the branch from `branch_config.branchId`. Throws
/// [PosIdentityUnavailableException] if there's no row yet, or the row
/// still holds the table's own `'UNREGISTERED'` default (branch setup
/// hasn't run).
Future<String> _resolveBranch(Ref ref) async {
  final branch = await ref.read(branchConfigDaoProvider).getBranch();
  final branchId = branch?.branchId;
  if (branchId == null || branchId.isEmpty || branchId == 'UNREGISTERED') {
    throw const PosIdentityUnavailableException(
      'No branch is configured — cannot create a sale until branch '
      'setup has run.',
    );
  }
  return branchId;
}

/// Thrown by [_PosIdentity.resolve] when neither `pos_config` nor
/// `pos_shift` has a usable POS ID, or `pos_shift` has no usable shift
/// — also reused by `_resolveCashier`/`_resolveBranch` for the same
/// category of failure (required sale context missing entirely).
class PosIdentityUnavailableException implements Exception {
  const PosIdentityUnavailableException(this.message);
  final String message;

  @override
  String toString() => 'PosIdentityUnavailableException: $message';
}

/// Resolved posId + shift for a sale, per the fallback rule:
///   posId  — pos_config.posId if it exists and isn't 0, else
///            pos_shift.posId if it exists and isn't 'UNREGISTERED'/blank
///   shift  — pos_shift.shift only; no fallback source exists for it
///
/// Both tables are singletons in practice (one row each) — see
/// pos_config_table.dart / pos_shift_table.dart doc context — so this
/// just takes whatever single row is there, if any.
class _PosIdentity {
  const _PosIdentity({required this.posId, required this.shift});

  final String posId;
  final String shift;

  static Future<_PosIdentity> resolve(Ref ref) async {
    final config = await ref.read(posConfigDaoProvider).getPos();
    final shiftRows = await ref.read(posShiftDaoProvider).getAllPosShifts();
    final shiftRow = shiftRows.isNotEmpty ? shiftRows.first : null;

    final configPosId = config?.posId;
    final shiftPosId = shiftRow?.posId;

    final String posId;
    if (configPosId != null && configPosId != 0) {
      posId = configPosId.toString();
    } else if (shiftPosId != null &&
        shiftPosId.isNotEmpty &&
        shiftPosId != 'UNREGISTERED') {
      posId = shiftPosId;
    } else {
      throw const PosIdentityUnavailableException(
        'No POS ID is configured — checked both pos_config and pos_shift. '
        'Cannot create a sale until POS setup has run.',
      );
    }

    final shift = shiftRow?.shift;
    if (shift == null || shift.isEmpty || shift == 'UNREGISTERED') {
      throw const PosIdentityUnavailableException(
        'No shift is set in pos_shift. Cannot create a sale until a '
        'shift has been recorded.',
      );
    }

    return _PosIdentity(posId: posId, shift: shift);
  }
}

/// One line inside the `items` JSON array — either a real cart line or
/// the synthetic discount line appended when a discount is applied.
/// Kept private: nothing outside sale-creation needs this shape.
Map<String, dynamic> _cartLineToItemJson(CartLine line) {
  return {
    'id': line.product.id,
    'name': line.product.name,
    'price': line.product.price,
    'quantity': line.quantity,
    'stocks': line.product.stock,
  };
}

/// Builds the `items` JSON string for a sale: every cart line, plus one
/// synthetic negative-price line for the discount (if any) — matching
/// the sample payload's `"Discount (5% Discount)"` line exactly. The
/// discount line's `id` is hardcoded to `1` and `stocks` to `1` to match
/// that sample; there's no real product/stock backing a discount line.
String _buildItemsJson(DashboardState state) {
  final lines = state.cartLines.map(_cartLineToItemJson).toList();

  if (state.hasDiscount) {
    final discount = state.selectedDiscount!;
    lines.add({
      'id': 1,
      'name': 'Discount (${discount.rate}% Discount)',
      'price': -state.discountAmount,
      'quantity': 1,
      'stocks': 1,
    });
  }

  return jsonEncode(lines);
}

/// Builds the `discountDetail` JSON string. Empty array when no discount
/// is applied — this field is meant to be parsed as JSON downstream, so
/// it should never fall back to the table's generic `'UNREGISTERED'`
/// default the way an un-set string column would.
///
/// `detailid` here references *this* sale's own detail ID (see the
/// sample payload, where it matches the parent transaction's
/// `detailid`). `customerinfo` is populated from
/// `DashboardState.selectedDiscountCustomerInfo` when the applied
/// discount required it (PWD/Senior — see
/// `_discountRequiresCustomerInfo`); for a regular discount that never
/// needed it, this falls back to a blank id/fullname entry, matching
/// the original sample payload's shape for a non-PWD/Senior discount.
String _buildDiscountDetailJson(DashboardState state, String detailId) {
  if (!state.hasDiscount) return jsonEncode(const []);

  final discount = state.selectedDiscount!;
  final customerInfo = state.selectedDiscountCustomerInfo;

  return jsonEncode([
    {
      'detailid': detailId,
      'discountid': discount.discountId,
      'customerinfo': [
        {
          'id': customerInfo?.id ?? '',
          'fullname': customerInfo?.fullName ?? '',
        },
      ],
      'amount': -state.discountAmount,
    },
  ]);
}

/// Formats a double the way every money-ish column in the sample payload
/// is formatted: a string of the raw double, e.g. `589.0`, not a
/// currency-rounded `589.00`.
String _formatMoney(double value) => value.toString();

/// -- Receipt adapter -------------------------------------------------
/// The only place in this file that knows `ReceiptGenerator` exists.
/// Builds a `ReceiptSaleData` (plain data — see receipt_generator.dart's
/// file-level ISOLATION note) straight from a live `DashboardState`
/// plus the tender details a `createSaleFrom*` method is about to
/// persist, so the printed ticket and the saved `SalesTable` row are
/// always built from the exact same numbers in the same call. This is
/// checkout's *own* way of producing a `ReceiptSaleData` — a reprint
/// screen has no `DashboardState` to work from and instead uses
/// `ReceiptSaleData.fromSaleRow`, reading a persisted row back out of
/// `SalesDao`. Neither path lives in receipt_generator.dart itself.
ReceiptSaleData _receiptDataFromCheckout({
  required DashboardState state,
  required String detailId,
  required String posId,
  required String shift,
  required String cashier,
  required String branchId,
  required String paymentType,
  required double cash,
  required double ecash,
  required String referenceId,
  required String paymentName,
}) {
  return ReceiptSaleData(
    detailId: detailId,
    posId: posId,
    shift: shift,
    cashier: cashier,
    branchId: branchId,
    dateTime: DateTime.now(),
    items: state.cartLines
        .map(
          (line) => ReceiptLineItem(
            name: line.product.name,
            quantity: line.quantity,
            price: line.product.price,
          ),
        )
        .toList(),
    subtotal: state.preDiscountTotal,
    discountLabel: state.hasDiscount
        ? '${state.selectedDiscount!.name} (${state.selectedDiscount!.rate}%)'
        : null,
    discountAmount: state.discountAmount,
    total: state.total,
    paymentType: paymentType,
    cash: cash,
    ecash: ecash,
    referenceId: referenceId,
    paymentName: paymentName,
  );
}

const _placeholderOtherActions = [
  OtherAction(id: 'receipt', label: 'RECEIPT', icon: 'receipt_long_rounded'),
  OtherAction(id: 'reports', label: 'REPORTS', icon: 'summarize_rounded'),
  OtherAction(
    id: 'cash_report',
    label: 'CASH REPORT',
    icon: 'account_balance_wallet_rounded',
  ),
  OtherAction(
    id: 'sold_items',
    label: 'SOLD ITEMS',
    icon: 'shopping_bag_rounded',
  ),
  OtherAction(id: 're_print', label: 'RE-PRINT', icon: 'print_rounded'),
  OtherAction(id: 'refund', label: 'REFUND', icon: 'assignment_return_rounded'),
  OtherAction(
    id: 'send_e-receipt',
    label: 'SEND E-RECEIPT',
    icon: 'forward_to_inbox_rounded',
  ),
  OtherAction(id: 'cash_drop', label: 'CASH DROP', icon: 'payments_rounded'),
  OtherAction(
    id: 'open_cashdrawer',
    label: 'OPEN CASHDRAWER',
    icon: 'inbox_rounded',
  ),
  OtherAction(id: 'sync_data', label: 'SYNC DATA', icon: 'sync_rounded'),
  OtherAction(
    id: 'restart_pos',
    label: 'RESTART POS',
    icon: 'restart_alt_rounded',
  ),
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

  AsyncValue<List<PosShiftTableData>> _posShiftsAsync() =>
      ref.watch(posShiftProvider);

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

  // Same maybeWhen fallback as the two getters above — on `loading`
  // (right after login, before pos_shift has synced/populated yet) or
  // `error`, this reads as "no shift rows", which resolves to
  // ShiftStatus.closed below. That's the safe default: a transient
  // loading/error blip should never make the UI claim a shift is open
  // when it can't actually confirm one.
  List<PosShiftTableData> _watchPosShifts() => _posShiftsAsync().maybeWhen(
    data: (items) => items,
    orElse: () => const <PosShiftTableData>[],
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

  /// Whether a shift is currently open — derived live from `pos_shift`,
  /// not from `DashboardState.shiftStatus` (that field is legacy/local
  /// only and no longer the source of truth; see the doc comment above
  /// `toggleShift()`).
  ///
  /// Rule: `open` if ANY row in `pos_shift` has `status == 'START'`.
  /// An empty table — no rows at all — reads as `closed`, i.e. no
  /// shift has been started (or the previous one already ended and
  /// was cleared), so the top bar's button should read "Start shift".
  /// This matches `replacePosShifts` fully clearing the table on each
  /// sync: a sync that comes back with `[]` correctly flips the button
  /// back to "Start shift" rather than leaving it stuck on whatever it
  /// showed before that sync.
  ShiftStatus get shiftStatus {
    final rows = _watchPosShifts();
    final hasOpenShift = rows.any((row) => row.status == 'START');
    return hasOpenShift ? ShiftStatus.open : ShiftStatus.closed;
  }

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

  /// Starts or ends the shift against the server, then re-syncs
  /// `pos_shift` from the server's own response (via
  /// `fetchAndSavePosShifts`) so `shiftStatus` above reflects what the
  /// server actually recorded — not an optimistic local flip. That
  /// matters here specifically because `startShift`/`endShift` don't
  /// return the shift row themselves (see pos_shift_repository.dart),
  /// only a bare success/failure; `fetchAndSavePosShifts` is what pulls
  /// the real row (or confirms it's gone) afterward.
  ///
  /// Sets `isTogglingShift` for the duration so the button can show a
  /// spinner and disable itself against double-taps. On failure, the
  /// flag is still cleared (via `finally`) and the error is rethrown —
  /// callers (the button's `onTap`) are expected to catch it and show
  /// a SnackBar; nothing here swallows a failed call.
  ///
  /// Raw request/response details are only in the repository's
  /// `debugPrint` calls (`startShift`/`endShift` in
  /// pos_shift_repository.dart) — check the console/logs to see
  /// exactly what the server sent back.
  Future<void> toggleShift() async {
    if (state.isTogglingShift) return; // guard against double-tap

    final repository = ref.read(posShiftRepositoryProvider);
    final wasOpen = shiftStatus == ShiftStatus.open;

    state = state.copyWith(isTogglingShift: true);
    try {
      if (wasOpen) {
        await repository.endShift();
      } else {
        await repository.startShift();
      }
      // Re-sync so `shiftStatus` (derived off `pos_shift`) reflects
      // whatever the server actually recorded for this start/end call.
      await repository.fetchAndSavePosShifts();
    } finally {
      state = state.copyWith(isTogglingShift: false);
    }
  }

  /// Applies (or switches to) a discount picked from the discount
  /// sheet. Only the row itself is stored — [DashboardState.total]
  /// derives the peso amount off the *current* total on every read, so
  /// this can be called before or after products are added/removed
  /// with no difference in the end result.
  ///
  /// [customerInfo] must be provided whenever [discount] requires it
  /// (see [discountRequiresCustomerInfo]) — this throws [StateError]
  /// otherwise, rather than silently applying a PWD/Senior discount
  /// with no customer record. The discount picker is responsible for
  /// routing those discounts through its ID + Fullname sheet first and
  /// passing the result here; a regular discount is applied with
  /// [customerInfo] left null.
  void applyDiscount(
    DiscountsTableData discount, {
    DiscountCustomerInfo? customerInfo,
  }) {
    if (_discountRequiresCustomerInfo(discount) && customerInfo == null) {
      throw StateError(
        'Discount "${discount.name}" requires customer ID + full name, '
        'but none was provided.',
      );
    }
    state = state.copyWith(
      selectedDiscount: discount,
      selectedDiscountCustomerInfo: customerInfo,
    );
  }

  /// Removes whichever discount is currently applied, along with any
  /// customer info captured for it.
  void clearDiscount() {
    state = state.copyWith(
      selectedDiscount: null,
      selectedDiscountCustomerInfo: null,
    );
  }

  /// Whether [discount] requires the ID + Fullname prompt before it can
  /// be applied — exposed for the discount picker sheet to check before
  /// deciding whether to open that prompt or apply immediately. See
  /// `_discountRequiresCustomerInfo` for the actual matching rule.
  bool discountRequiresCustomerInfo(DiscountsTableData discount) =>
      _discountRequiresCustomerInfo(discount);

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

  // --- Sale creation ---------------------------------------------------
  //
  // See the "SALE CREATION" doc comment above for scope. Both methods
  // below share the same shape: build a SalesTableCompanion from the
  // current cart + whatever the payment modal resolved, insert it via
  // SalesDao, then clear the cart and reset the payment modal's state
  // on success. Neither method touches IsSync beyond the table's own
  // default (0/unsynced) — the sync flow that flips it to 1 is a
  // separate piece of work.

  /// Creates a sale paid entirely in cash — [PaymentStep.cash] in the
  /// payment modal. Records `cash` as the charge total itself, not
  /// whatever the customer physically tendered — a tender above the
  /// total is change owed back, not part of the sale.
  ///
  /// Caller (the modal) is expected to only invoke this once
  /// `PaymentState.cashIsReadyToConfirm(total)` is true.
  ///
  /// Throws [PosDetailIdUnavailableException] if there's no usable
  /// detail ID yet (see `PosDetailIdDao.consumeAndIncrementDetailId`), or
  /// [PosIdentityUnavailableException] if posId/shift/cashier/branch
  /// can't be resolved (see `_PosIdentity.resolve`, `_resolveCashier`,
  /// `_resolveBranch`) — callers should catch both and stop the sale
  /// from being created rather than letting it fall through with bad
  /// data. All of posId/shift/cashier/branch are checked *before* the
  /// detail ID is consumed, so a failed sale never burns a detail ID it
  /// doesn't use. Nothing is written to `SalesTable` and the cart is
  /// left untouched
  /// in either failure case.
  Future<void> createSaleFromCash() async {
    final identity = await _PosIdentity.resolve(ref);
    final cashier = await _resolveCashier(ref);
    final branch = await _resolveBranch(ref);
    final detailId = await ref
        .read(posDetailIdDaoProvider)
        .consumeAndIncrementDetailId();

    final total = state.total;
    // Captured before `clearCart()` below, since the receipt needs the
    // same cart/discount snapshot that was just saved to `SalesTable`.
    final saleState = state;

    final sale = SalesTableCompanion.insert(
      detailId: Value(detailId),
      date: Value(_formatSaleDate(DateTime.now())),
      posid: Value(identity.posId),
      shift: Value(identity.shift),
      paymentType: const Value('CASH'),
      referenceId: const Value('CASH'),
      paymentName: const Value('CASH'),
      items: Value(_buildItemsJson(state)),
      total: Value(_formatMoney(total)),
      cashier: Value(cashier),
      cash: Value(_formatMoney(total)),
      ecash: const Value('0.0'),
      branch: Value(branch),
      discountDetail: Value(_buildDiscountDetailJson(state, detailId)),
      isSync: const Value('0'),
    );

    await ref.read(salesDaoProvider).saveSale(sale);

    clearCart();
    clearDiscount();

    // Printing happens after the sale is already committed and the
    // cart already cleared, and is never allowed to undo either one —
    // see `ReceiptPrintException`'s doc comment. A printer that's off,
    // unconfigured, or unsupported should surface as a failure the
    // caller can show (e.g. a snackbar), not roll back a sale that's
    // already saved.
    await ref
        .read(receiptGeneratorProvider)
        .printForSale(
          _receiptDataFromCheckout(
            state: saleState,
            detailId: detailId,
            posId: identity.posId,
            shift: identity.shift,
            cashier: cashier,
            branchId: branch,
            paymentType: 'CASH',
            cash: total,
            ecash: 0,
            referenceId: 'CASH',
            paymentName: 'CASH',
          ),
        );
  }

  /// Creates a sale paid entirely with a single E-payment tender —
  /// [PaymentStep.ePaymentConfirm] in the payment modal. Always charges
  /// the full total to that one method; there's no tendered/change
  /// concept here the way there is for cash.
  ///
  /// Caller (the modal) is expected to only invoke this once
  /// `paymentState.singleEPaymentIsReadyToConfirm` is true, which also
  /// guarantees `paymentState.selectedMethod` is non-null and
  /// `paymentState.singleEPaymentReferenceId` is non-blank.
  ///
  /// Throws [PosDetailIdUnavailableException] or
  /// [PosIdentityUnavailableException] on the same terms as
  /// `createSaleFromCash` — see that method's doc comment. Also throws
  /// a plain [StateError] if `selectedMethod` is+ null, which shouldn't
  /// happen given the caller contract above but is checked rather than
  /// silently writing a blank payment name.
  Future<void> createSaleFromEPayment(PaymentState paymentState) async {
    final method = paymentState.selectedMethod;
    if (method == null) {
      throw StateError(
        'createSaleFromEPayment called with no selectedMethod set',
      );
    }

    final identity = await _PosIdentity.resolve(ref);
    final cashier = await _resolveCashier(ref);
    final branch = await _resolveBranch(ref);
    final detailId = await ref
        .read(posDetailIdDaoProvider)
        .consumeAndIncrementDetailId();

    final total = state.total;
    // Captured before `clearCart()` below — see `createSaleFromCash`'s
    // matching comment.
    final saleState = state;
    final referenceId = paymentState.singleEPaymentReferenceId ?? '';

    final sale = SalesTableCompanion.insert(
      detailId: Value(detailId),
      date: Value(_formatSaleDate(DateTime.now())),
      posid: Value(identity.posId),
      shift: Value(identity.shift),
      paymentType: const Value('EPAYMENT'),
      referenceId: Value(referenceId),
      paymentName: Value(method.label),
      items: Value(_buildItemsJson(state)),
      total: Value(_formatMoney(total)),
      cashier: Value(cashier),
      cash: const Value('0.0'),
      ecash: Value(_formatMoney(total)),
      branch: Value(branch),
      discountDetail: Value(_buildDiscountDetailJson(state, detailId)),
      isSync: const Value('0'),
    );

    await ref.read(salesDaoProvider).saveSale(sale);

    clearCart();
    clearDiscount();

    // See `createSaleFromCash`'s matching comment: printing happens
    // after commit and never undoes the sale on failure.
    await ref
        .read(receiptGeneratorProvider)
        .printForSale(
          _receiptDataFromCheckout(
            state: saleState,
            detailId: detailId,
            posId: identity.posId,
            shift: identity.shift,
            cashier: cashier,
            branchId: branch,
            paymentType: 'EPAYMENT',
            cash: 0,
            ecash: total,
            referenceId: referenceId,
            paymentName: method.label,
          ),
        );
  }

  /// Creates a sale split across Cash + one E-payment tender —
  /// [PaymentStep.splitCashEPayment] in the payment modal, i.e.
  /// `PaymentState.splitKind == SplitKind.cashAndEPayment`.
  ///
  /// Takes the resolved `PaymentState` directly rather than re-deriving
  /// it here, since that state lives in `PaymentController`, not this
  /// controller — the two don't otherwise know about each other.
  /// Caller is expected to only invoke this once
  /// `paymentState.splitIsReadyToConfirm(total)` is true, which also
  /// guarantees both slots are complete (method + amount set, and the
  /// e-payment slot has a reference id).
  ///
  /// Throws [PosDetailIdUnavailableException] if there's no usable
  /// detail ID yet, or [PosIdentityUnavailableException] if
  /// posId/shift/cashier/branch can't be resolved — see
  /// `createSaleFromCash`'s doc comment for both. Split-kind is
  /// validated first, then posId/shift/cashier/branch, then the detail
  /// ID is consumed last — so nothing is burned or written on any
  /// earlier failure.
  Future<void> createSaleFromCashEPaymentSplit(
    PaymentState paymentState,
  ) async {
    assert(
      paymentState.splitKind == SplitKind.cashAndEPayment,
      'createSaleFromCashEPaymentSplit called with the wrong split kind',
    );
    if (paymentState.splitKind != SplitKind.cashAndEPayment) {
      throw StateError(
        'createSaleFromCashEPaymentSplit requires SplitKind.cashAndEPayment, '
        'got ${paymentState.splitKind}',
      );
    }

    final cashSlot = paymentState.splitSlots.firstWhere((slot) => slot.isCash);
    final ePaymentSlot = paymentState.splitSlots.firstWhere(
      (slot) => !slot.isCash,
    );

    final identity = await _PosIdentity.resolve(ref);
    final cashier = await _resolveCashier(ref);
    final branch = await _resolveBranch(ref);
    final detailId = await ref
        .read(posDetailIdDaoProvider)
        .consumeAndIncrementDetailId();

    final total = state.total;
    // Captured before `clearCart()` below — see `createSaleFromCash`'s
    // matching comment.
    final saleState = state;
    final cashAmount = cashSlot.amount ?? 0;
    final ePaymentAmount = ePaymentSlot.amount ?? 0;
    final referenceId = ePaymentSlot.referenceId ?? '';
    final paymentName = ePaymentSlot.method?.label ?? '';

    final sale = SalesTableCompanion.insert(
      detailId: Value(detailId),
      date: Value(_formatSaleDate(DateTime.now())),
      posid: Value(identity.posId),
      shift: Value(identity.shift),
      paymentType: const Value('SPLIT'),
      referenceId: Value(referenceId),
      paymentName: Value(paymentName),
      items: Value(_buildItemsJson(state)),
      total: Value(_formatMoney(total)),
      cashier: Value(cashier),
      cash: Value(_formatMoney(cashAmount)),
      ecash: Value(_formatMoney(ePaymentAmount)),
      branch: Value(branch),
      discountDetail: Value(_buildDiscountDetailJson(state, detailId)),
      isSync: const Value('0'),
    );

    await ref.read(salesDaoProvider).saveSale(sale);

    clearCart();
    clearDiscount();

    // See `createSaleFromCash`'s matching comment: printing happens
    // after commit and never undoes the sale on failure.
    await ref
        .read(receiptGeneratorProvider)
        .printForSale(
          _receiptDataFromCheckout(
            state: saleState,
            detailId: detailId,
            posId: identity.posId,
            shift: identity.shift,
            cashier: cashier,
            branchId: branch,
            paymentType: 'SPLIT',
            cash: cashAmount,
            ecash: ePaymentAmount,
            referenceId: referenceId,
            paymentName: paymentName,
          ),
        );
  }
}

/// Formats a `DateTime` the way the sample payload's `date` field is
/// formatted: `yyyy-MM-dd HH:mm`, no seconds, no timezone offset.
/// Written by hand rather than pulling in `intl` for one format string.
String _formatSaleDate(DateTime dateTime) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  return '${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)} '
      '${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}';
}
