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
import 'package:gpos_provantis/src/core/database/providers/service_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/service_package_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/addon_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/tables/sales_table.dart';
import 'package:gpos_provantis/src/core/database/daos/pos_detail_id_dao.dart';
import 'package:gpos_provantis/src/core/database/daos/duplicate_detail_id_exception.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_detail_id_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_config_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_shift_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/printer_dao_provider.dart'
    show printerDaoProvider;
import 'package:gpos_provantis/src/core/database/providers/branch_config_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/user_data_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/repository/pos_shift_repository.dart';
import 'package:gpos_provantis/src/core/database/domain/cash_drawer_dto.dart'
    show DenominationCountLine;
import 'payments_controller.dart';
import 'package:gpos_provantis/src/services/end_shift_service.dart';
import 'package:gpos_provantis/src/services/cash_drawer_service.dart';
import 'package:gpos_provantis/src/services/customer_service.dart';
import 'package:gpos_provantis/src/services/split_payment_service.dart';
import 'package:gpos_provantis/src/core/database/domain/split_payment_dto.dart'
    show SplitPaymentLeg;
import 'package:gpos_provantis/src/core/database/domain/send_cash_report_dto.dart';
import 'package:gpos_provantis/src/core/printutil/receipt_generator.dart'
    show
        ReceiptGenerator,
        ReceiptPrintException,
        ReceiptSaleData,
        ReceiptLineItem,
        receiptGeneratorProvider;
import 'package:gpos_provantis/src/shared/widgets/toast_emitter.dart';
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

/// Reserved category id for the virtual "Services" category. Real category
/// ids are numeric codes, so this can never collide with one.
const servicesCategoryId = 'services';

/// Reserved category id for the virtual "Service Packages" category.
const servicePackagesCategoryId = 'service-packages';

/// Reserved category id for the virtual "Add-ons" category.
const addonsCategoryId = 'addons';

/// True for any of the virtual service categories (no stock, always
/// sellable, sent to the server with the "Srv" marker).
bool isServiceCategoryId(String? id) =>
    id == servicesCategoryId ||
    id == servicePackagesCategoryId ||
    id == addonsCategoryId;

/// Service rows get this prefix on their cart id so they can't merge with a
/// product that happens to share the same numeric id.
const _serviceIdPrefix = 'svc-';
const _servicePackageIdPrefix = 'spkg-';
const _addonIdPrefix = 'addon-';

/// The server skips sale lines whose name contains this marker (no inventory
/// lookup or deduction). A line without it is treated as a product, and the
/// server crashes looking it up, which would block every later sale upload.
const _serverServiceMarker = 'Srv';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.stock,
    this.isService = false,
  });

  final String id;
  final String name;
  final String categoryId;
  final double price;

  final int stock;

  /// Services have no stock and are always sellable.
  final bool isService;

  bool get isAvailable => isService || stock > 0;
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
/// The drawer count is now collected INSIDE toggleShift (via the
/// `requestDrawerCount` callback), BEFORE the shift is started or ended, and
/// recorded by toggleShift itself. The UI no longer shows the sheet or calls
/// [DashboardController.recordShiftDrawerCount] after this returns.
class ToggleShiftResult {
  const ToggleShiftResult({
    required this.wasEnding,
    this.printError,
    this.shiftKey,
    this.cancelled = false,
    this.drawerCountError,
    this.unrecordedCount,
  });

  /// True if this call ended a shift; false if it started one.
  final bool wasEnding;

  /// Set only when the shift ended fine but the Z-reading did not print.
  final Object? printError;

  /// The shift this call opened or closed. Null on the double-tap guard path,
  /// when [cancelled], and if the controller was disposed mid-start.
  final ShiftKey? shiftKey;

  /// True when the cashier backed out of the required drawer count. Nothing
  /// was started or ended: the shift is exactly as it was before the tap.
  final bool cancelled;

  /// Set only when the shift changed but queueing the drawer count locally
  /// failed (a local DB problem, not a network one).
  final Object? drawerCountError;

  /// A count that was collected but could not be recorded because the
  /// controller was disposed while the shift was starting. Null otherwise.
  /// The UI should log/warn if this is non-null.
  final DenominationCountResult? unrecordedCount;

  bool get reportPrinted => wasEnding && printError == null && !cancelled;
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

String _cashierFromName(String? fullName) {
  if (fullName == null || fullName.isEmpty || fullName == 'INVALID USER') {
    throw const PosIdentityUnavailableException(
      'No user is logged in — cannot resolve a cashier name for this sale.',
    );
  }
  return fullName;
}

Future<String> _resolveCashier(Ref ref) async {
  final userDao = ref.read(userDataDaoProvider);
  final user = await userDao.getUser();
  return _cashierFromName(user?.fullName);
}

String _branchFromId(String? branchId) {
  if (branchId == null || branchId.isEmpty || branchId == 'UNREGISTERED') {
    throw const PosIdentityUnavailableException(
      'No branch is configured — cannot create a sale until branch '
      'setup has run.',
    );
  }
  return branchId;
}

Future<String> _resolveBranch(Ref ref) async {
  final branchDao = ref.read(branchConfigDaoProvider);
  final branch = await branchDao.getBranch();
  return _branchFromId(branch?.branchId);
}

class PosIdentityUnavailableException implements Exception {
  const PosIdentityUnavailableException(this.message);
  final String message;

  @override
  String toString() => 'PosIdentityUnavailableException: $message';
}

/// Thrown when a sale is requested while another one is still being saved.
class SaleAlreadyInProgressException implements Exception {
  const SaleAlreadyInProgressException();

  String get message => 'A payment is already being processed.';

  @override
  String toString() => 'SaleAlreadyInProgressException: $message';
}

/// Thrown when a sale is requested with an empty cart. After a successful
/// sale the cart is cleared, so this is also what stops a second tap from
/// recording a second (zero-peso) sale.
class EmptyCartException implements Exception {
  const EmptyCartException();

  String get message =>
      'The cart is empty. If you just confirmed a payment, the sale may '
      'already be recorded.';

  @override
  String toString() => 'EmptyCartException: $message';
}

class _PosIdentity {
  const _PosIdentity({required this.posId, required this.shift});

  final String posId;
  final String shift;

  static _PosIdentity fromRows({
    required int? configPosId,
    required PosShiftTableData? shiftRow,
  }) {
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

  static Future<_PosIdentity> resolve(Ref ref) async {
    // Both ref.read calls happen before the first await, so a provider
    // rebuild during the awaits below can't leave us reading a dead Ref.
    final posConfigDao = ref.read(posConfigDaoProvider);
    final posShiftDao = ref.read(posShiftDaoProvider);

    final config = await posConfigDao.getPos();
    final shiftRows = await posShiftDao.getAllPosShifts();
    return fromRows(
      configPosId: config?.posId,
      shiftRow: shiftRows.isNotEmpty ? shiftRows.first : null,
    );
  }
}

/// Resolves everything [ShiftKey] needs in one call: POS/shift identity,
/// cashier, branch, and today's business date. Used wherever the cash-drawer
/// or shift-report APIs need a full identity, so those four separate
/// resolves aren't repeated at every call site.
Future<ShiftKey> _resolveShiftKey(Ref ref) async {
  // Every ref.read happens HERE, synchronously, before the first await.
  // toggleShift() calls this right after fetchAndSavePosShifts(), which
  // updates pos_shift and makes DashboardController rebuild (build() watches
  // posShiftProvider). That rebuild can land during any await below and
  // dispose this Ref, so nothing after this block may touch `ref`.
  final posConfigDao = ref.read(posConfigDaoProvider);
  final posShiftDao = ref.read(posShiftDaoProvider);
  final userDao = ref.read(userDataDaoProvider);
  final branchDao = ref.read(branchConfigDaoProvider);

  final config = await posConfigDao.getPos();
  final shiftRows = await posShiftDao.getAllPosShifts();
  final identity = _PosIdentity.fromRows(
    configPosId: config?.posId,
    shiftRow: shiftRows.isNotEmpty ? shiftRows.first : null,
  );

  final user = await userDao.getUser();
  final cashier = _cashierFromName(user?.fullName);

  final branch = await branchDao.getBranch();
  final branchId = _branchFromId(branch?.branchId);

  return ShiftKey(
    posId: identity.posId,
    shift: identity.shift,
    cashier: cashier,
    branchId: branchId,
    businessDate: _formatBusinessDate(DateTime.now()),
  );
}

/// Name sent to the server. Services are guaranteed to carry the server's
/// "Srv" marker; the on-screen and receipt name is unchanged.
String _serverItemName(Product product) {
  if (!product.isService) return product.name;
  return product.name.contains(_serverServiceMarker)
      ? product.name
      : '$_serverServiceMarker - ${product.name}';
}

Map<String, dynamic> _cartLineToItemJson(CartLine line) {
  final product = line.product;
  return {
    'id': product.id,
    'name': _serverItemName(product),
    'price': product.price,
    'quantity': line.quantity,
    'stocks': product.isService ? 1 : product.stock,
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
  // Only for a sale paid with two e-payments (E2E): the second payment.
  String secondPaymentName = '',
  String secondReferenceId = '',
  double secondAmount = 0,
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
    secondPaymentName: secondPaymentName,
    secondReferenceId: secondReferenceId,
    secondAmount: secondAmount,
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

/// Plain-language reason for the cashier. Exception classes in this app carry
/// a `message`; anything else falls back to its text.
String _describeError(Object e) {
  if (e is PosIdentityUnavailableException) return e.message;
  if (e is ReceiptPrintException) return e.message;
  final text = e.toString().replaceFirst('Exception: ', '').trim();
  return text.isEmpty ? 'Unknown error.' : text;
}

/// [_describeError], guaranteed to end in a full stop so more text can follow.
String _describeErrorSentence(Object e) {
  final text = _describeError(e);
  return RegExp(r'[.!?]$').hasMatch(text) ? text : '$text.';
}

/// A sale that did not go through. Every throw out of a sale flow means the
/// sale was NOT recorded: the steps after the local save (customer, cash
/// drawer, receipt print) are all caught and reported separately.
String _describeSaleFailure(Object e) {
  final detail = _describeErrorSentence(e);
  return 'Payment failed and the sale was not recorded. $detail';
}

enum BarcodeScanStatus { added, notFound, outOfStock, notReady }

class BarcodeScanResult {
  const BarcodeScanResult(this.status, [this.product]);

  final BarcodeScanStatus status;
  final Product? product;
}

@riverpod
class DashboardController extends _$DashboardController {
  AsyncValue<List<CategoriesTableData>> _categoriesAsync() =>
      ref.watch(categoriesProvider);

  AsyncValue<List<ProductPriceTableData>> _productsAsync() =>
      ref.watch(productPriceProvider);

  AsyncValue<List<ServiceTableData>> _servicesAsync() =>
      ref.watch(servicesProvider);

  List<ServiceTableData> _watchServices() => _servicesAsync().maybeWhen(
    data: (items) => items,
    orElse: () => const <ServiceTableData>[],
  );

  AsyncValue<List<ServicePackageTableData>> _servicePackagesAsync() =>
      ref.watch(servicePackagesProvider);

  List<ServicePackageTableData> _watchServicePackages() =>
      _servicePackagesAsync().maybeWhen(
        data: (items) => items,
        orElse: () => const <ServicePackageTableData>[],
      );

  AsyncValue<List<AddonTableData>> _addonsAsync() => ref.watch(addonsProvider);

  List<AddonTableData> _watchAddons() => _addonsAsync().maybeWhen(
    data: (items) => items,
    orElse: () => const <AddonTableData>[],
  );

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

    // Same idea for the end-of-shift "send cash report": sends any left over
    // from a session where the device was offline when the shift ended.
    // Harmless to call repeatedly (an in-flight run or an empty outbox returns
    // straight away).
    unawaited(ref.read(endShiftServiceProvider).syncPendingCashReports());

    // And customers attached to sales made while the server was unreachable.
    unawaited(ref.read(customerServiceProvider).syncPending());

    // And split-payment sales that were saved while the server was unreachable.
    unawaited(ref.read(splitPaymentServiceProvider).syncPending());

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

  /// Load status of whatever the open catalog sheet is showing: services for
  /// the Services category, products for everything else.
  CatalogLoadStatus get productsStatus {
    final categoryId = state.catalogSheetCategoryId;
    final AsyncValue<Object?> async = switch (categoryId) {
      servicesCategoryId => _servicesAsync(),
      servicePackagesCategoryId => _servicePackagesAsync(),
      addonsCategoryId => _addonsAsync(),
      _ => _productsAsync(),
    };
    return async.when(
      data: (_) => CatalogLoadStatus.data,
      error: (_, __) => CatalogLoadStatus.error,
      loading: () => CatalogLoadStatus.loading,
    );
  }

  ShiftStatus get shiftStatus {
    final rows = _watchPosShifts();
    final hasOpenShift = rows.any((row) => row.status == 'START');
    return hasOpenShift ? ShiftStatus.open : ShiftStatus.closed;
  }

  List<Category> get categories {
    final rows = _watchCategories();
    final list = rows
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

    // Only show Services when there is at least one active service.
    if (_watchServices().isNotEmpty) {
      list.add(
        const Category(
          id: servicesCategoryId,
          name: 'Services',
          icon: 'services_rounded', // mapped in catalog_panel.dart
        ),
      );
    }
    if (_watchServicePackages().isNotEmpty) {
      list.add(
        const Category(
          id: servicePackagesCategoryId,
          name: 'Service Packages',
          icon: 'service_package_rounded', // mapped in catalog_panel.dart
        ),
      );
    }
    if (_watchAddons().isNotEmpty) {
      list.add(
        const Category(
          id: addonsCategoryId,
          name: 'Add-ons',
          icon: 'addon_rounded', // mapped in catalog_panel.dart
        ),
      );
    }
    return list;
  }

  List<OtherAction> get otherActions => _placeholderOtherActions;

  List<Product> productsForCatalogSheet() {
    final categoryId = state.catalogSheetCategoryId;
    if (categoryId == null) return const [];

    final query = state.catalogSearchQuery.trim().toLowerCase();

    if (categoryId == servicesCategoryId) {
      return _watchServices()
          .where(
            (row) =>
                row.name.trim().isNotEmpty &&
                (query.isEmpty || row.name.toLowerCase().contains(query)),
          )
          .map(
            (row) => Product(
              id: '$_serviceIdPrefix${row.id}',
              name: row.name,
              categoryId: servicesCategoryId,
              price: row.price,
              stock: 0,
              isService: true,
            ),
          )
          .toList();
    }

    if (categoryId == servicePackagesCategoryId) {
      return _watchServicePackages()
          .where(
            (row) =>
                row.name.trim().isNotEmpty &&
                (query.isEmpty || row.name.toLowerCase().contains(query)),
          )
          .map(
            (row) => Product(
              id: '$_servicePackageIdPrefix${row.id}',
              name: row.name,
              categoryId: servicePackagesCategoryId,
              price: row.price,
              stock: 0,
              isService: true,
            ),
          )
          .toList();
    }

    if (categoryId == addonsCategoryId) {
      return _watchAddons()
          .where(
            (row) =>
                row.name.trim().isNotEmpty &&
                (query.isEmpty || row.name.toLowerCase().contains(query)),
          )
          .map(
            (row) => Product(
              id: '$_addonIdPrefix${row.id}',
              name: row.name,
              categoryId: addonsCategoryId,
              price: row.price,
              stock: 0,
              isService: true,
            ),
          )
          .toList();
    }

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

  /// Plain field (not state) so it can block a second tap while the drawer
  /// lookup / count sheet is pending, without the state change that
  /// isTogglingShift would cause before the sheet opens.
  bool _toggleInFlight = false;

  /// True when at least one enabled printer has a cash drawer attached. When
  /// false, shifts start/end without asking for a drawer count: there is no
  /// physical drawer to count.
  ///
  /// Reads the DAO's Drift stream directly (first emission) instead of
  /// `ref.read(printerProvider.future)`: that provider has no listener on the
  /// dashboard, so its first value may never arrive and the shift button
  /// would hang silently. A timeout makes any future hang a visible error.
  Future<bool> isCashDrawerEnabled() async {
    // ref.read happens before the await (see _resolveShiftKey for why).
    final dao = ref.read(printerDaoProvider);
    final printers = await dao.watchAllPrinters().first.timeout(
      const Duration(seconds: 5),
    );
    final enabled = printers.any((p) => p.isEnabled && p.hasCashDrawer);
    debugPrint(
      '[CashDrawer] isCashDrawerEnabled=$enabled '
      '(${printers.length} printer(s) in settings)',
    );
    return enabled;
  }

  /// Starts or ends the shift, but ONLY after a drawer count was entered
  /// (when a cash drawer is enabled in the printer settings).
  ///
  /// [requestDrawerCount] shows the denomination sheet and returns the count,
  /// or null if the cashier dismissed it. Null means nothing happens: the
  /// shift is neither started nor ended, so closing the sheet can no longer
  /// be used to skip the count.
  Future<ToggleShiftResult> toggleShift({
    required Future<DenominationCountResult?> Function(bool isStartOfShift)
    requestDrawerCount,
  }) async {
    // The emitter outlives this controller, so it is safe to use after awaits.
    final toast = ref.read(toastEmitterProvider);
    final action = shiftStatus == ShiftStatus.open ? 'end' : 'start';

    try {
      final result = await _toggleShift(requestDrawerCount: requestDrawerCount);
      _announceShiftResult(toast, result);
      return result;
    } catch (e, st) {
      debugPrint('toggleShift: failed to $action the shift: $e\n$st');
      toast.error('Could not $action the shift. ${_describeErrorSentence(e)}');
      rethrow;
    }
  }

  /// Tells the cashier how the shift change went. Says nothing when nothing
  /// happened (cashier backed out of the count, or a double-tap was ignored).
  void _announceShiftResult(ToastEmitter toast, ToggleShiftResult r) {
    if (r.cancelled) return;

    if (r.unrecordedCount != null) {
      toast.warning(
        'Shift started, but the drawer count could not be recorded. '
        'Count the drawer again.',
      );
      return;
    }

    // Double-tap guard path: no shift was opened or closed.
    if (r.shiftKey == null) return;

    final done = r.wasEnding ? 'ended' : 'started';
    final problems = <String>[
      if (r.drawerCountError != null) 'the drawer count could not be saved',
      if (r.printError != null) 'the end-of-shift report did not print',
    ];

    if (problems.isEmpty) {
      toast.success('Shift $done.');
    } else {
      toast.warning('Shift $done, but ${problems.join(' and ')}.');
    }
  }

  Future<ToggleShiftResult> _toggleShift({
    required Future<DenominationCountResult?> Function(bool isStartOfShift)
    requestDrawerCount,
  }) async {
    if (state.isTogglingShift || _toggleInFlight) {
      // guard against double-tap
      return const ToggleShiftResult(wasEnding: false);
    }
    _toggleInFlight = true;

    // Every ref.read happens HERE, before the first await, so the drawer
    // count can still be recorded even if this controller is rebuilt (and
    // its Ref disposed) while the shift is starting/ending.
    final repository = ref.read(posShiftRepositoryProvider);
    final cashDrawerService = ref.read(cashDrawerServiceProvider);
    final endShiftService = ref.read(endShiftServiceProvider);
    final userDao = ref.read(userDataDaoProvider);
    Future<String?> getEmployeeId() async =>
        (await userDao.getUser())?.employeeId;

    final wasOpen = shiftStatus == ShiftStatus.open;

    debugPrint('[CashDrawer] toggleShift: starting, wasOpen=$wasOpen');
    // isTogglingShift is NOT set yet: the count sheet must open with no
    // pending state change (a state change right before showing a sheet can
    // race the build that change triggers). The sheet is modal, so the shift
    // button can't be tapped again while the cashier is counting.
    var markedToggling = false;
    try {
      // STEP 0: the drawer count comes FIRST, before anything is written.
      DenominationCountResult? count;
      if (await isCashDrawerEnabled()) {
        count = await requestDrawerCount(!wasOpen);
        if (count == null || !ref.mounted) {
          debugPrint(
            '[CashDrawer] toggleShift: no drawer count entered, '
            'shift left untouched',
          );
          return ToggleShiftResult(wasEnding: wasOpen, cancelled: true);
        }
      }

      // The count is in (or no drawer is installed): now it is safe to lock
      // out double-taps and touch the shift.
      state = state.copyWith(isTogglingShift: true);
      markedToggling = true;

      if (!wasOpen) {
        await repository.startShift();
        debugPrint(
          '[CashDrawer] toggleShift: startShift done, ref.mounted=${ref.mounted}',
        );
        // See the ref.mounted notes in the original design: an await can let
        // this controller be rebuilt before execution resumes. The shift DID
        // start, but the new shift number is not known until pos_shift is
        // refreshed, so the count is handed back instead of silently lost.
        if (!ref.mounted) {
          debugPrint(
            '[CashDrawer] toggleShift: ref no longer mounted after '
            'startShift(), bailing out (shift did start on the server)',
          );
          return ToggleShiftResult(wasEnding: false, unrecordedCount: count);
        }

        await repository.fetchAndSavePosShifts();
        if (!ref.mounted) {
          debugPrint(
            '[CashDrawer] toggleShift: ref no longer mounted after '
            'fetchAndSavePosShifts(), bailing out',
          );
          return ToggleShiftResult(wasEnding: false, unrecordedCount: count);
        }

        // Resolved AFTER the refresh, on purpose: this is the identity of the
        // shift that was just opened.
        final shiftKey = await _resolveShiftKey(ref);

        Object? drawerError;
        if (count != null) {
          try {
            await _recordDrawerCountWith(
              service: cashDrawerService,
              endShiftService: endShiftService,
              getEmployeeId: getEmployeeId,
              shiftKey: shiftKey,
              isStartOfShift: true,
              count: count,
            );
          } catch (e, st) {
            debugPrint('[CashDrawer] start-of-shift count not queued: $e\n$st');
            drawerError = e;
          }
        }
        return ToggleShiftResult(
          wasEnding: false,
          shiftKey: shiftKey,
          drawerCountError: drawerError,
        );
      }

      // Capture which POS/shift/date we are closing BEFORE ending it:
      // fetchAndSavePosShifts() below refreshes pos_shift. Resolving first
      // also means that if the identity is unavailable we fail before
      // touching the server.
      final shiftKey = await _resolveShiftKey(ref);
      final posId = int.parse(shiftKey.posId);
      final shiftId = int.parse(shiftKey.shift);

      await repository.endShift();
      debugPrint(
        '[CashDrawer] toggleShift: endShift done, ref.mounted=${ref.mounted}',
      );

      // Record the count IMMEDIATELY after the shift closes, before any
      // ref.mounted bail-out below, so it can't be skipped. Uses only the
      // services read before the first await, so a disposed Ref is fine.
      Object? drawerError;
      if (count != null) {
        try {
          await _recordDrawerCountWith(
            service: cashDrawerService,
            endShiftService: endShiftService,
            getEmployeeId: getEmployeeId,
            shiftKey: shiftKey,
            isStartOfShift: false,
            count: count,
          );
        } catch (e, st) {
          debugPrint('[CashDrawer] end-of-shift count not queued: $e\n$st');
          drawerError = e;
        }
      }

      if (!ref.mounted) {
        debugPrint(
          '[CashDrawer] toggleShift: ref no longer mounted after endShift(), '
          'bailing out (shift ended and the count was recorded; Z-reading '
          'print was skipped this call)',
        );
        return ToggleShiftResult(
          wasEnding: true,
          shiftKey: shiftKey,
          drawerCountError: drawerError,
        );
      }

      // The shift is now closed on the server. pos_shift must be refreshed no
      // matter what happens next, or the UI keeps showing an open shift.
      await repository.fetchAndSavePosShifts();
      if (!ref.mounted) {
        debugPrint(
          '[CashDrawer] toggleShift: ref no longer mounted after '
          'fetchAndSavePosShifts() (end-shift), bailing out',
        );
        return ToggleShiftResult(
          wasEnding: true,
          shiftKey: shiftKey,
          drawerCountError: drawerError,
        );
      }

      // Fetch + save + print the Z-reading. A failure here must not look like
      // the shift failed to end, so it is captured and returned.
      try {
        await ref
            .read(endShiftServiceProvider)
            .printEndShiftReport(
              date: shiftKey.businessDate,
              posId: posId,
              shiftId: shiftId,
            );
        return ToggleShiftResult(
          wasEnding: true,
          shiftKey: shiftKey,
          drawerCountError: drawerError,
        );
      } catch (e, st) {
        debugPrint('toggleShift: shift ended but report failed: $e\n$st');
        return ToggleShiftResult(
          wasEnding: true,
          printError: e,
          shiftKey: shiftKey,
          drawerCountError: drawerError,
        );
      }
    } finally {
      _toggleInFlight = false;
      if (ref.mounted) {
        if (markedToggling) state = state.copyWith(isTogglingShift: false);
      } else {
        debugPrint(
          '[CashDrawer] toggleShift: ref unmounted by the time finally ran, '
          'skipping state reset (a newer controller instance already exists)',
        );
      }
    }
  }

  /// Records a drawer count (start- or end-of-shift) taken via
  /// [DenominationCountSheet] and queues it for sending.
  ///
  /// [toggleShift] now calls this flow itself, so the UI normally does NOT
  /// need to. It stays public for the rare [ToggleShiftResult.unrecordedCount]
  /// case, using a [ShiftKey] resolved for the right shift.
  Future<void> recordShiftDrawerCount({
    required ShiftKey shiftKey,
    required bool isStartOfShift,
    required DenominationCountResult count,
  }) {
    // Everything needed from `ref` is read here, before the first await.
    final userDao = ref.read(userDataDaoProvider);
    return _recordDrawerCountWith(
      service: ref.read(cashDrawerServiceProvider),
      endShiftService: ref.read(endShiftServiceProvider),
      getEmployeeId: () async => (await userDao.getUser())?.employeeId,
      shiftKey: shiftKey,
      isStartOfShift: isStartOfShift,
      count: count,
    );
  }

  /// The actual recording. Takes its dependencies as arguments (no `ref`) so
  /// it keeps working after this controller has been disposed.
  Future<void> _recordDrawerCountWith({
    required CashDrawerService service,
    required EndShiftService endShiftService,
    required Future<String?> Function() getEmployeeId,
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

    // Closing a shift also sends the cash report to the server: saved on the
    // device first, then uploaded. Separate from the drawer count above and
    // must never undo it: that count is already queued.
    if (!isStartOfShift) {
      try {
        // The server wants the cashier's employee id, not their name.
        final employeeId = await getEmployeeId();
        if (employeeId == null || employeeId.isEmpty) {
          debugPrint(
            '[SendCashReport] no employee id for the logged-in user, '
            'report not recorded',
          );
          return;
        }

        final result = await endShiftService.sendCashReport(
          branchId: shiftKey.branchId,
          posId: shiftKey.posId,
          shift: shiftKey.shift,
          shiftDate: shiftKey.businessDate,
          cashierId: employeeId,
          lines: [
            for (final entry in count.allActiveLines)
              SendCashReportLineDto(
                denominationId: entry.denominationId,
                value: entry.value,
                quantity: entry.quantity,
              ),
          ],
        );
        debugPrint(
          result.sent
              ? '[SendCashReport] saved and sent to the server'
              : '[SendCashReport] saved on this device, will send when the '
                    'server is reachable (${result.error ?? 'not sent yet'})',
        );
      } catch (e, st) {
        debugPrint('[SendCashReport] could not record the report: $e\n$st');
      }
    }
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

  /// Looks up [rawBarcode] in the local product table and adds the match to
  /// the cart. Reads the already-loaded Drift stream, so it is instant and
  /// works offline.
  BarcodeScanResult addToCartByBarcode(String rawBarcode) {
    final code = rawBarcode.trim().toLowerCase();
    final productsAsync = ref.read(productPriceProvider);
    if (!productsAsync.hasValue) {
      return const BarcodeScanResult(BarcodeScanStatus.notReady);
    }

    ProductPriceTableData? match;
    for (final row in productsAsync.requireValue) {
      final barcode = row.barcode.trim().toLowerCase();
      if (barcode.isNotEmpty && barcode == code) {
        match = row;
        break;
      }
    }
    if (match == null) {
      return const BarcodeScanResult(BarcodeScanStatus.notFound);
    }

    // Same mapping as productsForCatalogSheet(), so the cart line merges
    // with one added by tapping the grid.
    final product = Product(
      id: match.productId.toString(),
      name: match.description,
      categoryId: match.category.toString(),
      price: _parseMoney(match.price),
      stock: match.quantity,
    );

    if (!product.isAvailable) {
      return BarcodeScanResult(BarcodeScanStatus.outOfStock, product);
    }

    addToCart(product);
    return BarcodeScanResult(BarcodeScanStatus.added, product);
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

  /// Attaches the customer entered before payment (if any) to the sale that
  /// was just saved: the customer service stores it on the device against this
  /// receipt number and then uploads it. Caught, not rethrown: the sale itself
  /// already succeeded and must not be blocked from printing over a customer
  /// problem. An unreachable server is not an error here at all, the customer
  /// just stays pending and is sent later.
  Future<void> _recordCustomerForSale({
    required String detailId,
    required String posId,
  }) async {
    try {
      final result = await ref
          .read(customerServiceProvider)
          .recordForSale(salesId: detailId, posId: posId);
      if (result == null) return;
      debugPrint(
        result.sent
            ? '[Customer] saved and sent for sale $detailId'
            : '[Customer] saved for sale $detailId, will send when the '
                  'server is reachable (${result.error ?? 'not sent yet'})',
      );
    } catch (e, st) {
      debugPrint(
        '[Customer] could not record the customer for sale $detailId: '
        '$e\n$st',
      );
    }
  }

  // ---- Idempotency guards -------------------------------------------------

  /// True while a sale is being saved. Checked and set synchronously (no await
  /// in between), so two taps in the same frame can never both get through.
  bool _saleInFlight = false;

  /// The receipt (detail) number reserved for the sale being checked out.
  /// Reserved once and reused if the save has to be retried, so a retry can
  /// never produce a second receipt number for the same sale. Cleared as soon
  /// as the sale is saved.
  String? _reservedDetailId;

  Future<String> _reserveDetailId() async {
    return _reservedDetailId ??= await ref
        .read(posDetailIdDaoProvider)
        .consumeAndIncrementDetailId();
  }

  void _releaseDetailId() {
    _reservedDetailId = null;
  }

  /// Runs [saveSale] at most once at a time, and only for a non-empty cart.
  ///
  /// Also the one place a failed sale is announced, so every payment method
  /// reports failure the same way. (Success is announced by
  /// [_printReceiptAndAnnounce], because only that step knows whether the
  /// receipt printed.) The exception is still rethrown so the payment modal
  /// can release its lock and stay open for a retry.
  Future<void> _runSaleOnce(Future<void> Function() saveSale) async {
    final toast = ref.read(toastEmitterProvider);

    if (_saleInFlight) {
      const e = SaleAlreadyInProgressException();
      toast.warning(e.message);
      throw e;
    }
    if (state.cartLines.isEmpty) {
      const e = EmptyCartException();
      toast.warning(e.message);
      throw e;
    }
    _saleInFlight = true;
    try {
      await saveSale();
    } on DuplicateDetailIdException {
      // The reserved receipt number belongs to another sale: drop it so the
      // next attempt takes a fresh one.
      _releaseDetailId();
      toast.error(
        'That receipt number was already used, so the sale was not recorded. '
        'Please try the payment again.',
      );
      rethrow;
    } catch (e, st) {
      debugPrint('Sale failed: $e\n$st');
      toast.error(_describeSaleFailure(e));
      rethrow;
    } finally {
      _saleInFlight = false;
    }
  }

  /// Prints the receipt of a sale that is ALREADY saved, then tells the
  /// cashier how it went.
  ///
  /// A print problem is reported here instead of thrown: the sale is done and
  /// the cart is cleared, so surfacing it as a failed payment would invite the
  /// cashier to ring the same sale up twice.
  Future<void> _printReceiptAndAnnounce({
    required ToastEmitter toast,
    required String detailId,
    required double total,
    required Future<void> Function() printReceipt,
  }) async {
    final label = 'Sale #$detailId (₱${total.toStringAsFixed(2)})';
    try {
      await printReceipt();
      toast.success('$label completed.');
    } catch (e, st) {
      debugPrint('Sale $detailId saved but the receipt did not print: $e\n$st');
      toast.warning(
        '$label was recorded, but the receipt did not print: '
        '${_describeErrorSentence(e)} Do not ring it up again; use RE-PRINT.',
      );
    }
  }

  Future<void> createSaleFromCash() => _runSaleOnce(_createSaleFromCash);

  Future<void> _createSaleFromCash() async {
    final toast = ref.read(toastEmitterProvider);
    final identity = await _PosIdentity.resolve(ref);
    final cashier = await _resolveCashier(ref);
    final branch = await _resolveBranch(ref);
    final detailId = await _reserveDetailId();

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
    _releaseDetailId();

    // The sale is complete: attach the customer entered before payment.
    await _recordCustomerForSale(detailId: detailId, posId: identity.posId);

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

    final receipt = _receiptDataFromCheckout(
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
    );

    await _printReceiptAndAnnounce(
      toast: toast,
      detailId: detailId,
      total: total,
      printReceipt: () =>
          ref.read(receiptGeneratorProvider).printForSale(receipt),
    );
  }

  Future<void> createSaleFromEPayment(PaymentState paymentState) =>
      _runSaleOnce(() => _createSaleFromEPayment(paymentState));

  Future<void> _createSaleFromEPayment(PaymentState paymentState) async {
    final method = paymentState.selectedMethod;
    if (method == null) {
      throw StateError(
        'createSaleFromEPayment called with no selectedMethod set',
      );
    }

    final toast = ref.read(toastEmitterProvider);
    final identity = await _PosIdentity.resolve(ref);
    final cashier = await _resolveCashier(ref);
    final branch = await _resolveBranch(ref);
    final detailId = await _reserveDetailId();

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
    _releaseDetailId();

    // The sale is complete: attach the customer entered before payment.
    await _recordCustomerForSale(detailId: detailId, posId: identity.posId);

    // No cash-drawer send here: this sale has zero cash tendered (fully
    // e-payment), and the cash-drawer API only records cash amounts — see
    // CashDrawerActivityPayload.transaction. Nothing to report.

    clearCart();
    clearDiscount();

    final receipt = _receiptDataFromCheckout(
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
    );

    await _printReceiptAndAnnounce(
      toast: toast,
      detailId: detailId,
      total: total,
      printReceipt: () =>
          ref.read(receiptGeneratorProvider).printForSale(receipt),
    );
  }

  Future<void> createSaleFromCashEPaymentSplit(PaymentState paymentState) =>
      _runSaleOnce(() => _createSaleFromCashEPaymentSplit(paymentState));

  Future<void> _createSaleFromCashEPaymentSplit(
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

    final toast = ref.read(toastEmitterProvider);
    final identity = await _PosIdentity.resolve(ref);
    final cashier = await _resolveCashier(ref);
    final branch = await _resolveBranch(ref);
    final detailId = await _reserveDetailId();

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
    _releaseDetailId();

    // The sale is complete: attach the customer entered before payment.
    await _recordCustomerForSale(detailId: detailId, posId: identity.posId);

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

    final receipt = _receiptDataFromCheckout(
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
    );

    await _printReceiptAndAnnounce(
      toast: toast,
      detailId: detailId,
      total: total,
      printReceipt: () =>
          ref.read(receiptGeneratorProvider).printForSale(receipt),
    );
  }

  /// A sale paid with two e-payments (e.g. GCASH + BANK TRANSFER).
  ///
  /// Recorded by [SplitPaymentService]: the sale is saved on the device first
  /// and then uploaded to the server, and kept for a retry if the server can't
  /// be reached. Unlike the other flows it is not written to the local `sales`
  /// table, because that table has one payment name and one reference per sale.
  Future<void> createSaleFromEPaymentSplit(PaymentState paymentState) =>
      _runSaleOnce(() => _createSaleFromEPaymentSplit(paymentState));

  Future<void> _createSaleFromEPaymentSplit(PaymentState paymentState) async {
    assert(
      paymentState.splitKind == SplitKind.ePaymentAndEPayment,
      'createSaleFromEPaymentSplit called with the wrong split kind',
    );
    if (paymentState.splitKind != SplitKind.ePaymentAndEPayment) {
      throw StateError(
        'createSaleFromEPaymentSplit requires '
        'SplitKind.ePaymentAndEPayment, got ${paymentState.splitKind}',
      );
    }

    final firstSlot = paymentState.splitSlots[0];
    final secondSlot = paymentState.splitSlots[1];
    final firstMethod = firstSlot.method;
    final secondMethod = secondSlot.method;
    if (firstMethod == null || secondMethod == null) {
      throw StateError(
        'createSaleFromEPaymentSplit requires an e-payment method on both '
        'slots',
      );
    }

    final toast = ref.read(toastEmitterProvider);
    final identity = await _PosIdentity.resolve(ref);
    final cashier = await _resolveCashier(ref);
    final branch = await _resolveBranch(ref);
    final detailId = await _reserveDetailId();

    final total = state.total;

    final saleState = state;
    final firstAmount = firstSlot.amount ?? 0;
    final secondAmount = secondSlot.amount ?? 0;
    final firstReference = firstSlot.referenceId ?? '';
    final secondReference = secondSlot.referenceId ?? '';

    // Saves the sale on the device, then uploads it. It only throws if the
    // local save itself fails; an unreachable server just leaves it pending.
    await ref
        .read(splitPaymentServiceProvider)
        .recordSplitPayment(
          detailId: detailId,
          date: _formatSaleDate(DateTime.now()),
          posId: identity.posId,
          shift: identity.shift,
          items: _buildItemsJson(state),
          staff: cashier,
          branchId: branch,
          discountDetails: _buildDiscountDetailJson(state, detailId),
          total: total,
          first: SplitPaymentLeg(
            type: firstMethod.label,
            amount: firstAmount,
            reference: firstReference,
          ),
          second: SplitPaymentLeg(
            type: secondMethod.label,
            amount: secondAmount,
            reference: secondReference,
          ),
        );

    _releaseDetailId();

    // The sale is complete: attach the customer entered before payment. Done
    // after the split payment is sent so the sale exists on the server first.
    await _recordCustomerForSale(detailId: detailId, posId: identity.posId);

    // No cash-drawer entry: both payments are e-payments, so no cash moved.

    clearCart();
    clearDiscount();

    final receipt = _receiptDataFromCheckout(
      state: saleState,
      detailId: detailId,
      posId: identity.posId,
      shift: identity.shift,
      cashier: cashier,
      branchId: branch,
      paymentType: 'E2E',
      cash: 0,
      ecash: firstAmount,
      referenceId: firstReference,
      paymentName: firstMethod.label,
      secondPaymentName: secondMethod.label,
      secondReferenceId: secondReference,
      secondAmount: secondAmount,
    );

    await _printReceiptAndAnnounce(
      toast: toast,
      detailId: detailId,
      total: total,
      printReceipt: () =>
          ref.read(receiptGeneratorProvider).printForSale(receipt),
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
