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

  /// [onStep], if provided, is called with a short human-readable label
  /// right before each repository fetch starts — e.g. "Categories",
  /// "Promos" — so a caller (the sync overlay) can show live progress
  /// text instead of a static "please wait" message.
  ///
  /// The 8 calls after categories run concurrently via [Future.wait].
  /// Building that list literal fires every step's `notify(...)` back
  /// to back, synchronously, before any of the underlying futures start
  /// doing real async work — so all 8 labels arrive in the same tick.
  /// That's intentional: `notify` is not a per-step completion signal,
  /// it's "these are now in flight." No artificial delay is introduced
  /// here to spread them out for the UI's sake — that's the overlay's
  /// job (e.g. rendering them as a log it reveals progressively), not
  /// something this service should slow itself down for.
  ///
  /// Callers should treat each invocation as "now working on this," not
  /// as a checklist of guaranteed completion order — the underlying
  /// fetches can still finish in any order.
  Future<CatalogSyncResult> syncCatalog({
    void Function(String label)? onStep,
  }) async {
    final notify = onStep ?? (_) {};

    Future<T> announced<T>(String label, Future<T> Function() task) async {
      notify(label);
      return task();
    }

    try {
      // fetchAndSaveProductPrices() reads categories back out of the local
      // DB (via CategoriesDao) to loop over them — see the comment in
      // product_price_repository.dart. Running everything through a single
      // Future.wait() races that read against fetchAndSaveCategories()
      // still writing, and product prices loses that race intermittently
      // ("No categories found locally..."). Categories has to be fully
      // saved before product prices starts, so it's pulled out and
      // awaited on its own first; everything else that doesn't have this
      // dependency still runs concurrently afterward.
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
