import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';

// Repositories
import 'package:gpos_provantis/src/core/database/repository/categories_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/denominations_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/discounts_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/employees_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/payments_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/pos_detail_id_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/pos_shift_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/product_price_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/promo_repository.dart';

part 'catalog_sync.g.dart';

@Riverpod(keepAlive: true)
CatalogSyncService catalogSyncService(Ref ref) {
  final categoriesRepository = ref.watch(categoriesRepositoryProvider);
  final denominationsRepository = ref.watch(denominationsRepositoryProvider);
  final discountsRepository = ref.watch(discountsRepositoryProvider);
  final employeesRepository = ref.watch(employeesRepositoryProvider);
  final paymentsRepository = ref.watch(paymentsRepositoryProvider);
  final posDetailIdRepository = ref.watch(posDetailIdRepositoryProvider);
  final posShiftRepository = ref.watch(posShiftRepositoryProvider);
  final productPriceRepository = ref.watch(productPriceRepositoryProvider);
  final promoRepository = ref.watch(promoRepositoryProvider);

  return CatalogSyncService(
    categoriesRepository,
    denominationsRepository,
    discountsRepository,
    employeesRepository,
    paymentsRepository,
    posDetailIdRepository,
    posShiftRepository,
    productPriceRepository,
    promoRepository,
  );
}

class CatalogSyncResult {
  final bool success;
  final String? errorMessage;

  const CatalogSyncResult.ok() : success = true, errorMessage = null;
  const CatalogSyncResult.failure(this.errorMessage) : success = false;
}

class CatalogSyncService {
  final CategoriesRepository _categoriesRepository;
  final DenominationsRepository _denominationsRepository;
  final DiscountsRepository _discountsRepository;
  final EmployeesRepository _employeesRepository;
  final PaymentsRepository _paymentsRepository;
  final PosDetailIdRepository _posDetailIdRepository;
  final PosShiftRepository _posShiftRepository;
  final ProductPriceRepository _productPriceRepository;
  final PromoRepository _promoRepository;

  CatalogSyncService(
    this._categoriesRepository,
    this._denominationsRepository,
    this._discountsRepository,
    this._employeesRepository,
    this._paymentsRepository,
    this._posDetailIdRepository,
    this._posShiftRepository,
    this._productPriceRepository,
    this._promoRepository,
  );

  Future<CatalogSyncResult> syncCatalog() async {
    try {
      await Future.wait([
        _categoriesRepository.fetchAndSaveCategories(),
        _denominationsRepository.fetchAndSaveDenominations(),
        _discountsRepository.fetchAndSaveDiscounts(),
        _employeesRepository.fetchAndSaveEmployees(),
        _paymentsRepository.fetchAndSavePayments(),
        _posDetailIdRepository.fetchAndSavePosDetailId(),
        _posShiftRepository.fetchAndSavePosShifts(),
        _productPriceRepository.fetchAndSaveProductPrices(),
        _promoRepository.fetchAndSavePromos(),
      ]);
      return const CatalogSyncResult.ok();
    } catch (e) {
      if (isDuplicateRequestError(e)) {
        // A double-tap on Proceed triggered this — the first sync attempt
        // is still in flight and will complete on its own. Treat as a
        // silent no-op rather than an error.
        return const CatalogSyncResult.failure(null);
      }
      final msg = e.toString().replaceFirst('Exception: ', '');
      return CatalogSyncResult.failure('Could not reach the server. $msg');
    }
  }
}
