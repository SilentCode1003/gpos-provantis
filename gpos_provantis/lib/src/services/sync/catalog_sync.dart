import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';

import 'package:gpos_provantis/src/core/database/repository/categories_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/denominations_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/discounts_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/employees_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/payments_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/pos_detail_id_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/pos_settings_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/pos_shift_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/product_price_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/promo_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/service_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/service_package_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/addon_repository.dart';
import 'package:gpos_provantis/src/services/split_payment_service.dart';
import 'package:gpos_provantis/src/services/sync/product_images_sync.dart';

part 'catalog_sync.g.dart';

/// How long after a successful catalog sync the picture download waits before
/// starting, so the dashboard can finish its first render undisturbed.
const Duration _imageSyncStartDelay = Duration(seconds: 5);

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
  final posSettingsRepository = ref.watch(posSettingsRepositoryProvider);
  final serviceRepository = ref.watch(serviceRepositoryProvider);
  final servicePackageRepository = ref.watch(servicePackageRepositoryProvider);
  final addonRepository = ref.watch(addonRepositoryProvider);
  final splitPaymentService = ref.watch(splitPaymentServiceProvider);
  final productImagesSync = ref.watch(productImagesSyncProvider);

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
    posSettingsRepository,
    serviceRepository,
    servicePackageRepository,
    addonRepository,
    splitPaymentService,
    productImagesSync,
  );
}

class CatalogSyncResult {
  final bool success;
  final String? errorMessage;

  /// Set when the catalog synced but the final printer-settings step didn't.
  /// The sync still counts as a success; surface this if you want to tell the
  /// user their printers weren't auto-configured.
  final String? warning;

  const CatalogSyncResult.ok({this.warning})
    : success = true,
      errorMessage = null;
  const CatalogSyncResult.failure(this.errorMessage)
    : success = false,
      warning = null;
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
  final PosSettingsRepository _posSettingsRepository;
  final ServiceRepository _serviceRepository;
  final ServicePackageRepository _servicePackageRepository;
  final AddonRepository _addonRepository;
  final SplitPaymentService _splitPaymentService;
  final ProductImagesSync _productImagesSync;

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
    this._posSettingsRepository,
    this._serviceRepository,
    this._servicePackageRepository,
    this._addonRepository,
    this._splitPaymentService,
    this._productImagesSync,
  );

  /// Starts pulling product images in the background. Only called once the
  /// catalog has synced (so the product list is saved). Not awaited: the sync
  /// result returns immediately and the images arrive one at a time while the
  /// till is in use. A picture problem never affects the sync result.
  void _startProductImageSync() {
    unawaited(
      Future<void>.delayed(
        _imageSyncStartDelay,
      ).then((_) => _productImagesSync.runAutomatic()).catchError((Object e) {
        debugPrint('CatalogSync: product images not started: $e');
        return const ProductImagesSyncResult(aborted: true);
      }),
    );
  }

  Future<CatalogSyncResult> syncCatalog({
    void Function(String label)? onStep,
  }) async {
    final notify = onStep ?? (_) {};

    Future<T> announced<T>(String label, Future<T> Function() task) async {
      notify(label);
      return task();
    }

    try {
      // Push first, pull second: anything still waiting on this device goes to
      // the server BEFORE any catalog data is pulled. If it can't be sent, the
      // sync stops here so nothing pending is ever put at risk.
      notify('Sending pending sales');
      try {
        await _splitPaymentService.syncPending();
      } catch (e) {
        if (isDuplicateRequestError(e)) rethrow;
        debugPrint('CatalogSync: pending sales not sent: $e');
        return CatalogSyncResult.failure(
          'Pending sales could not be sent, so the sync was stopped. '
          'Please try again once the server can be reached. '
          '${e.toString().replaceFirst('Exception: ', '')}',
        );
      }

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
        announced('Services', () => _serviceRepository.fetchAndSaveServices()),
        announced(
          'Service packages',
          () => _servicePackageRepository.fetchAndSaveServicePackages(),
        ),
        announced('Addons', () => _addonRepository.fetchAndSaveAddons()),
      ]);

      // Last on purpose: it needs the POS id saved by the steps above. A
      // problem here must not fail the whole catalog sync (the till can still
      // sell), so it is reported as a warning instead.
      notify('Printer settings');
      try {
        await _posSettingsRepository.syncPosSettings();
      } catch (e) {
        if (isDuplicateRequestError(e)) rethrow;
        debugPrint('CatalogSync: printer settings not synced: $e');
        // The catalog itself synced, so the products are saved.
        _startProductImageSync();
        return CatalogSyncResult.ok(
          warning:
              'Printer settings were not updated. '
              '${e.toString().replaceFirst('Exception: ', '')}',
        );
      }

      _startProductImageSync();
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
