import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';

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

  Future<CatalogSyncResult> syncCatalog({
    void Function(String label)? onStep,
  }) async {
    final notify = onStep ?? (_) {};

    Future<T> announced<T>(String label, Future<T> Function() task) async {
      notify(label);
      return task();
    }

    try {
      notify('Categories');
      await _categoriesRepository.fetchAndSaveCategories();

      await Future.wait([
        announced(
          'Denominations',
          () => _denominationsRepository.fetchAndSaveDenominations(),
        ),
        announced(
          'Discounts',
          () => _discountsRepository.fetchAndSaveDiscounts(),
        ),
        announced(
          'Employees',
          () => _employeesRepository.fetchAndSaveEmployees(),
        ),
        announced(
          'Payment methods',
          () => _paymentsRepository.fetchAndSavePayments(),
        ),
        announced(
          'Store details',
          () => _posDetailIdRepository.fetchAndSavePosDetailId(),
        ),
        announced('Shifts', () => _posShiftRepository.fetchAndSavePosShifts()),
        announced(
          'Product prices',
          () => _productPriceRepository.fetchAndSaveProductPrices(),
        ),
        announced('Promos', () => _promoRepository.fetchAndSavePromos()),
      ]);
      return const CatalogSyncResult.ok();
    } catch (e) {
      if (isDuplicateRequestError(e)) {
        return const CatalogSyncResult.failure(null);
      }
      final msg = e.toString().replaceFirst('Exception: ', '');
      return CatalogSyncResult.failure('Could not reach the server. $msg');
    }
  }
}
