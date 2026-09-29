import 'dart:async' show unawaited;
import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart' show debugPrint;
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
import 'package:gpos_provantis/src/core/database/repository/pos_shift_repository.dart';
import 'package:gpos_provantis/src/core/database/domain/cash_drawer_dto.dart'
    show DenominationCountLine;
import 'payments_controller.dart';
import 'package:gpos_provantis/src/services/end_shift_service.dart';
import 'package:gpos_provantis/src/services/cash_drawer_service.dart';
import 'package:gpos_provantis/src/core/printutil/receipt_generator.dart'
    show
        ReceiptGenerator,
        ReceiptSaleData,
        ReceiptLineItem,
        receiptGeneratorProvider;
import 'package:gpos_provantis/src/features/dashboard/presentation/widgets/dashboardWidgets/others_sheet/denomination_count_sheet.dart'
    show DenominationCountResult;

part 'dashboard_controller.g.dart';

class DiscountCustomerInfo {
  const DiscountCustomerInfo({required this.id, required this.fullName});

  final String id;
  final String fullName;
}

bool _discountRequiresCustomerInfo(DiscountsTableData discount) {
  final normalized = discount.name.toLowerCase().replaceAll("'", '');

  final isSenior = normalized.contains('senior');

  final isPwd =
      normalized.contains('pwd') ||
      (normalized.contains('person') && normalized.contains('disab'));

  return isSenior || isPwd;
}

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

  final int stock;
}

class Category {
  const Category({required this.id, required this.name, required this.icon});

  final String id;
  final String name;

  final String icon;
}

class CartLine {
  const CartLine({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  double get lineTotal => product.price * quantity;

  CartLine copyWith({int? quantity}) =>
      CartLine(product: product, quantity: quantity ?? this.quantity);
}

enum ShiftStatus { closed, open }

/// Outcome of [DashboardController.toggleShift].
///
/// Ending a shift is two steps: closing it on the server, then printing the
/// Z-reading. The shift being closed is what matters, so a printing problem is
/// reported here instead of thrown, letting the UI say "Shift ended, but the
/// report could not be printed" rather than a misleading failure.
///
/// This also carries the identity of the shift that was just opened or
/// closed ([shiftKey]), because the caller needs it a second time right
/// after this returns: to show the drawer-count sheet and pass the result to
/// [DashboardController.recordShiftDrawerCount]. Re-resolving identity at
/// that point instead of reusing this would be wrong for an ending shift —
/// toggleShift() has already refreshed pos_shift by the time it returns, so a
/// fresh resolve would find the NEXT shift's identity, not the one that was
/// just closed.
class ToggleShiftResult {
  const ToggleShiftResult({
    required this.wasEnding,
    this.printError,
    this.shiftKey,
  });

  /// True if this call ended a shift; false if it started one.
  final bool wasEnding;

  /// Set only when the shift ended fine but the Z-reading did not print.
  final Object? printError;

  /// The shift this call opened or closed. Null only on the double-tap guard
  /// path, which does nothing and returns immediately.
  final ShiftKey? shiftKey;

  bool get reportPrinted => wasEnding && printError == null;
}

/// Identifies one shift for cash-drawer reporting: which POS, which shift
/// number, whose shift, and what business date it falls under.
class ShiftKey {
  const ShiftKey({
    required this.posId,
    required this.shift,
    required this.cashier,
    required this.branchId,
    required this.businessDate,
  });

  final String posId;
  final String shift;
  final String cashier;
  final String branchId;

  /// "yyyy-MM-dd", matching what the cash-drawer and shift-report APIs want.
  final String businessDate;
}

enum CatalogLoadStatus { loading, error, data }

class OtherAction {
  const OtherAction({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;

  final String icon;
}

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

  final String? catalogSheetCategoryId;

  final String catalogSearchQuery;

  bool get isCatalogSheetOpen => catalogSheetCategoryId != null;

  final DiscountsTableData? selectedDiscount;

  bool get hasDiscount => selectedDiscount != null;

  final DiscountCustomerInfo? selectedDiscountCustomerInfo;

  final ShiftStatus shiftStatus;

  final bool isTogglingShift;

  double get subtotal => cartLines.fold(0, (sum, line) => sum + line.lineTotal);

  double get preDiscountTotal => subtotal;

  double get discountRate =>
      selectedDiscount == null ? 0 : selectedDiscount!.rate / 100;

  double get discountAmount => preDiscountTotal * discountRate;

  double get total => preDiscountTotal - discountAmount;

  int get itemCount => cartLines.fold(0, (sum, line) => sum + line.quantity);

  DashboardState copyWith({
    String? selectedCategoryId,
    List<CartLine>? cartLines,

    Object? selectedDiscount = _unset,
    Object? selectedDiscountCustomerInfo = _unset,
    ShiftStatus? shiftStatus,
    bool? isTogglingShift,

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

const Object _unset = Object();

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

class PosIdentityUnavailableException implements Exception {
  const PosIdentityUnavailableException(this.message);
  final String message;

  @override
  String toString() => 'PosIdentityUnavailableException: $message';
}

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

/// Resolves everything [ShiftKey] needs in one call: POS/shift identity,
/// cashier, branch, and today's business date. Used wherever the cash-drawer
/// or shift-report APIs need a full identity, so those four separate
/// resolves aren't repeated at every call site.
Future<ShiftKey> _resolveShiftKey(Ref ref) async {
  final identity = await _PosIdentity.resolve(ref);
  final cashier = await _resolveCashier(ref);
  final branch = await _resolveBranch(ref);
  return ShiftKey(
    posId: identity.posId,
    shift: identity.shift,
    cashier: cashier,
    branchId: branch,
    businessDate: _formatBusinessDate(DateTime.now()),
  );
}

Map<String, dynamic> _cartLineToItemJson(CartLine line) {
  return {
    'id': line.product.id,
    'name': line.product.name,
    'price': line.product.price,
    'quantity': line.quantity,
    'stocks': line.product.stock,
  };
}

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

String _formatMoney(double value) => value.toString();

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

  List<CategoriesTableData> _watchCategories() => _categoriesAsync().maybeWhen(
    data: (items) => items,
    orElse: () => const <CategoriesTableData>[],
  );

  List<ProductPriceTableData> _watchProducts() => _productsAsync().maybeWhen(
    data: (items) => items,
    orElse: () => const <ProductPriceTableData>[],
  );

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

    // Retries anything left in the cash-drawer outbox from a previous
    // session (e.g. the device was offline when a shift ended, or the app
    // was killed mid-send). Fire-and-forget: build() is synchronous and
    // runs on every rebuild of this provider, not just once per app launch,
    // so this is a proxy for "app start", not the real thing — a drain
    // that's already in flight or a fully-synced outbox both return quickly,
    // so calling this more than once per session is harmless, just not
    // needed. If a genuine single "app started" or "connectivity restored"
    // hook exists elsewhere (main.dart, a connectivity listener), retrying
    // from there instead would be more precise than this.
    unawaited(ref.read(cashDrawerServiceProvider).retryPending());

    return DashboardState(
      selectedCategoryId: firstCategoryId,
      cartLines: const [],
    );
  }

  CatalogLoadStatus get categoriesStatus => _categoriesAsync().when(
    data: (_) => CatalogLoadStatus.data,
    error: (_, __) => CatalogLoadStatus.error,
    loading: () => CatalogLoadStatus.loading,
  );

  CatalogLoadStatus get productsStatus => _productsAsync().when(
    data: (_) => CatalogLoadStatus.data,
    error: (_, __) => CatalogLoadStatus.error,
    loading: () => CatalogLoadStatus.loading,
  );

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

  void selectCategory(String categoryId) {
    state = state.copyWith(
      selectedCategoryId: categoryId,
      catalogSheetCategoryId: categoryId,
    );
  }

  void closeCatalogSheet() {
    state = state.copyWith(
      catalogSheetCategoryId: null,
      catalogSearchQuery: '',
    );
  }

  void setCatalogSearchQuery(String query) {
    state = state.copyWith(catalogSearchQuery: query);
  }

  Future<ToggleShiftResult> toggleShift() async {
    if (state.isTogglingShift) {
      // guard against double-tap
      return const ToggleShiftResult(wasEnding: false);
    }

    final repository = ref.read(posShiftRepositoryProvider);
    final wasOpen = shiftStatus == ShiftStatus.open;

    state = state.copyWith(isTogglingShift: true);
    try {
      if (!wasOpen) {
        await repository.startShift();
        await repository.fetchAndSavePosShifts();

        // Resolved AFTER the refresh above, on purpose: starting a shift
        // means this now IS the identity we want (the shift that was just
        // opened), unlike the ending branch below.
        final shiftKey = await _resolveShiftKey(ref);
        return ToggleShiftResult(wasEnding: false, shiftKey: shiftKey);
      }

      // Capture which POS/shift/date we are closing BEFORE ending it:
      // fetchAndSavePosShifts() below refreshes pos_shift and would otherwise
      // change what _PosIdentity.resolve() returns. Resolving first also means
      // that if the identity is unavailable we fail before touching the server.
      final shiftKey = await _resolveShiftKey(ref);
      final posId = int.parse(shiftKey.posId);
      final shiftId = int.parse(shiftKey.shift);

      await repository.endShift();

      // The shift is now closed on the server. pos_shift must be refreshed no
      // matter what happens next, or the UI keeps showing an open shift.
      await repository.fetchAndSavePosShifts();

      // Fetch + save + print the Z-reading. A failure here (printer offline,
      // no saved copy while offline, ...) must not look like the shift failed
      // to end, so it is captured and returned instead of thrown.
      try {
        await ref
            .read(endShiftServiceProvider)
            .printEndShiftReport(
              date: shiftKey.businessDate,
              posId: posId,
              shiftId: shiftId,
            );
        return ToggleShiftResult(wasEnding: true, shiftKey: shiftKey);
      } catch (e, st) {
        debugPrint('toggleShift: shift ended but report failed: $e\n$st');
        return ToggleShiftResult(
          wasEnding: true,
          printError: e,
          shiftKey: shiftKey,
        );
      }
    } finally {
      state = state.copyWith(isTogglingShift: false);
    }
  }

  /// Records a drawer count (start- or end-of-shift) taken via
  /// [DenominationCountSheet] and queues it for sending.
  ///
  /// Called by the UI right after showing the sheet, using the [shiftKey]
  /// from the [ToggleShiftResult] that [toggleShift] just returned — NOT a
  /// freshly resolved identity, since by the time the sheet closes,
  /// pos_shift may already reflect a different shift.
  ///
  /// This is a one-line adapter between two deliberately separate types:
  /// [DenominationCountResult] (what the sheet returns, with UI-facing
  /// fields like `label`) and [DenominationCountLine] (what the cash-drawer
  /// API payload needs). [allActiveLines] is used rather than [lines]
  /// because the server's sample payload lists every active denomination,
  /// including ones counted as zero — not just the nonzero ones.
  ///
  /// Queuing happens offline-first (see [CashDrawerService]), so this
  /// completes even with no connectivity; the actual send is retried
  /// automatically later.
  Future<void> recordShiftDrawerCount({
    required ShiftKey shiftKey,
    required bool isStartOfShift,
    required DenominationCountResult count,
  }) async {
    final lines = [
      for (final entry in count.allActiveLines)
        DenominationCountLine(
          denominationId: entry.denominationId,
          value: entry.value,
          quantity: entry.quantity,
        ),
    ];

    final service = ref.read(cashDrawerServiceProvider);
    final record = isStartOfShift
        ? service.recordStartShiftCount
        : service.recordEndShiftCount;

    await record(
      shift: shiftKey.shift,
      cashier: shiftKey.cashier,
      shiftDate: shiftKey.businessDate,
      branchId: shiftKey.branchId,
      posId: shiftKey.posId,
      lines: lines,
    );
  }

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

  void clearDiscount() {
    state = state.copyWith(
      selectedDiscount: null,
      selectedDiscountCustomerInfo: null,
    );
  }

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

  Future<void> createSaleFromCash() async {
    final identity = await _PosIdentity.resolve(ref);
    final cashier = await _resolveCashier(ref);
    final branch = await _resolveBranch(ref);
    final detailId = await ref
        .read(posDetailIdDaoProvider)
        .consumeAndIncrementDetailId();

    final total = state.total;

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

    // Records the cash tendered for this sale to the cash-drawer outbox.
    // Awaited (not fire-and-forget) so a failure to even QUEUE it locally is
    // visible in the log, rather than silently lost — but caught, not
    // rethrown, since the sale itself already succeeded and must not be
    // rolled back or blocked from printing over a cash-drawer reporting
    // problem. Network failures never reach here at all: CashDrawerService
    // queues to the local DB first and treats connectivity failures as
    // "retry later", not as errors.
    try {
      await ref
          .read(cashDrawerServiceProvider)
          .recordTransaction(
            shift: identity.shift,
            cashier: cashier,
            shiftDate: _formatBusinessDate(DateTime.now()),
            branchId: branch,
            posId: identity.posId,
            detailId: detailId,
            cash: total,
            total: total,
          );
    } catch (e, st) {
      debugPrint(
        'createSaleFromCash: could not queue cash-drawer entry: $e\n$st',
      );
    }

    clearCart();
    clearDiscount();

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

    // No cash-drawer send here: this sale has zero cash tendered (fully
    // e-payment), and the cash-drawer API only records cash amounts — see
    // CashDrawerActivityPayload.transaction. Nothing to report.

    clearCart();
    clearDiscount();

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

    // Records only the CASH portion of this split sale to the cash-drawer
    // outbox — the e-payment portion never touches the physical drawer.
    // Skipped entirely if the cash slot was zero, matching createSaleFromEPayment.
    // See createSaleFromCash for why this is awaited-but-caught.
    if (cashAmount > 0) {
      try {
        await ref
            .read(cashDrawerServiceProvider)
            .recordTransaction(
              shift: identity.shift,
              cashier: cashier,
              shiftDate: _formatBusinessDate(DateTime.now()),
              branchId: branch,
              posId: identity.posId,
              detailId: detailId,
              cash: cashAmount,
              total: total,
            );
      } catch (e, st) {
        debugPrint(
          'createSaleFromCashEPaymentSplit: could not queue cash-drawer '
          'entry: $e\n$st',
        );
      }
    }

    clearCart();
    clearDiscount();

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

/// The shift report's `date` is date-only ("yyyy-MM-dd", e.g. "2026-09-24"),
/// unlike [_formatSaleDate] which appends the time.
String _formatBusinessDate(DateTime dateTime) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  return '${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)}';
}

String _formatSaleDate(DateTime dateTime) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  return '${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)} '
      '${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}';
}
