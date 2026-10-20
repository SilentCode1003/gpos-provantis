import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/database/daos/settings_dao.dart';
import 'package:gpos_provantis/src/core/database/domain/settings_dto.dart';
import 'package:gpos_provantis/src/core/database/providers/settings_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/repository/product_image_repository.dart';

part 'product_images_sync.g.dart';

@Riverpod(keepAlive: true)
ProductImagesSync productImagesSync(Ref ref) {
  return ProductImagesSync(
    ref.watch(productImageRepositoryProvider),
    ref.watch(settingsDaoProvider),
  );
}

/// `done` of `total` products handled so far.
typedef ProductImagesProgress = void Function(int done, int total);

class ProductImagesSyncResult {
  const ProductImagesSyncResult({
    this.total = 0,
    this.downloaded = 0,
    this.noImage = 0,
    this.alreadyLocal = 0,
    this.failed = 0,
    this.aborted = false,
    this.message,
  });

  /// Products this run set out to handle.
  final int total;
  final int downloaded;
  final int noImage;
  final int alreadyLocal;
  final int failed;

  /// Stopped early: server unreachable, too many failures, or cancelled.
  final bool aborted;
  final String? message;

  bool get isOk => !aborted && failed == 0;
}

/// Manages the product-image files on this device. Call it from any screen:
///
///   final sync = ref.read(productImagesSyncProvider);
///   await sync.fetchMissing(onProgress: (done, total) => ...);
///   await sync.resyncAll();
///   await sync.deleteAll();
///
/// Images are fetched ONE AT A TIME, so the server and the app are never hit
/// with a burst. Only one run can be active at once. The UI doesn't need this
/// class to show images: read `productImagePathProvider(productId)`.
class ProductImagesSync {
  ProductImagesSync(
    this._repository,
    this._settingsDao, {
    this.pauseBetweenImages = const Duration(milliseconds: 150),
  });

  /// Breathing room after every image that needed the network, so the device
  /// (and the till in use on it) always has idle frames between downloads.
  /// Raise it for slower devices; Duration.zero turns it off.
  final Duration pauseBetweenImages;

  final ProductImageRepository _repository;
  final SettingsDao _settingsDao;

  bool _running = false;
  bool _cancelRequested = false;

  /// After this many products in a row fail, the run stops (something is
  /// wrong server-side; no point hammering it).
  static const _maxConsecutiveFailures = 5;

  bool get isRunning => _running;

  /// Asks the current run to stop after the product it is working on.
  void cancel() => _cancelRequested = true;

  /// Cancels the current run (if any) and waits until it has really stopped,
  /// up to [timeout]. Use before deleting images so nothing is mid-download.
  Future<void> cancelAndWait({
    Duration timeout = const Duration(seconds: 8),
  }) async {
    if (!_running) return;
    _cancelRequested = true;
    final deadline = DateTime.now().add(timeout);
    while (_running && DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }

  /// What the catalog sync calls. Obeys the Settings screen:
  ///  - automatic download off  -> does nothing;
  ///  - the refresh schedule is due -> re-downloads everything ([resyncAll]);
  ///  - otherwise -> only downloads what is missing ([fetchMissing]).
  /// The first automatic run also records "now" as the schedule's starting
  /// point, so the days are counted from then.
  Future<ProductImagesSyncResult> runAutomatic({
    ProductImagesProgress? onProgress,
  }) async {
    final rows = await _settingsDao.getSettings();
    final settings = rows.isEmpty
        ? const ProductImageSettings()
        : ProductImageSettings.fromTableData(rows.first);

    if (!settings.autoFetch) {
      return const ProductImagesSyncResult(
        message: 'Automatic image download is off.',
      );
    }

    final now = DateTime.now();
    if (settings.isRefetchDue(now)) {
      final result = await resyncAll(onProgress: onProgress);
      if (!result.aborted) await _settingsDao.markProductImagesRefetched(now);
      return result;
    }

    final result = await fetchMissing(onProgress: onProgress);
    if (settings.lastRefetchedAt == null && !result.aborted) {
      await _settingsDao.markProductImagesRefetched(now);
    }
    return result;
  }

  /// Deletes every saved image, then downloads them all again, one at a time.
  /// Runs whether or not automatic download is on (the cashier asked for it).
  Future<ProductImagesSyncResult> deleteAndRefetch({
    ProductImagesProgress? onProgress,
  }) async {
    if (_running) return _busy();
    if (!await deleteAll()) return _busy();
    final result = await fetchMissing(onProgress: onProgress);
    if (!result.aborted) {
      await _settingsDao.markProductImagesRefetched(DateTime.now());
    }
    return result;
  }

  /// 2. Fetches only products that have no image on this device yet (never
  /// fetched, previously failed, or whose file went missing). Products the
  /// server already said have no image are skipped unless [retryNoImage].
  Future<ProductImagesSyncResult> fetchMissing({
    bool retryNoImage = false,
    ProductImagesProgress? onProgress,
  }) async {
    if (_running) return _busy();
    _running = true;
    _cancelRequested = false;
    try {
      final ids = await _repository.productIdsMissingImage(
        includeNoImage: retryNoImage,
      );
      // The list is already "what's missing", so every id is fetched for real.
      return await _run(ids, force: true, onProgress: onProgress);
    } finally {
      _running = false;
    }
  }

  /// 1. Re-fetches the image of EVERY product and replaces what is saved.
  ///
  /// Each old image is only removed after its replacement has been saved, so
  /// if the server drops out halfway the cashier keeps the pictures they had
  /// instead of ending up with none.
  Future<ProductImagesSyncResult> resyncAll({
    ProductImagesProgress? onProgress,
  }) async {
    if (_running) return _busy();
    _running = true;
    _cancelRequested = false;
    try {
      final ids = await _repository.allProductIds();
      return await _run(ids, force: true, onProgress: onProgress);
    } finally {
      _running = false;
    }
  }

  /// 3. Deletes every image file and record on this device. Returns false
  /// (and does nothing) if a fetch is running; call [cancel] first.
  Future<bool> deleteAll() async {
    if (_running) return false;
    _running = true;
    _cancelRequested = false;
    try {
      await _repository.deleteAllImages();
      return true;
    } finally {
      _running = false;
    }
  }

  // ---- internals ----------------------------------------------------------

  ProductImagesSyncResult _busy() => const ProductImagesSyncResult(
    aborted: true,
    message: 'Product images are already being updated.',
  );

  Future<ProductImagesSyncResult> _run(
    List<int> ids, {
    required bool force,
    ProductImagesProgress? onProgress,
  }) async {
    var done = 0;
    var downloaded = 0;
    var noImage = 0;
    var alreadyLocal = 0;
    var failed = 0;
    var consecutiveFailures = 0;
    var aborted = false;
    String? message;

    ProductImagesSyncResult build() => ProductImagesSyncResult(
      total: ids.length,
      downloaded: downloaded,
      noImage: noImage,
      alreadyLocal: alreadyLocal,
      failed: failed,
      aborted: aborted,
      message: message,
    );

    onProgress?.call(0, ids.length);

    for (final id in ids) {
      if (_cancelRequested) {
        aborted = true;
        message = 'Cancelled.';
        break;
      }

      var usedNetwork = false;
      try {
        final result = await _repository.ensureImage(id, force: force);
        usedNetwork = result != ImageFetchResult.alreadyLocal;
        switch (result) {
          case ImageFetchResult.downloaded:
            downloaded++;
            consecutiveFailures = 0;
          case ImageFetchResult.noImage:
            noImage++;
            consecutiveFailures = 0;
          case ImageFetchResult.alreadyLocal:
            alreadyLocal++;
            consecutiveFailures = 0;
          case ImageFetchResult.failed:
            failed++;
            consecutiveFailures++;
        }
      } on DioException catch (e) {
        debugPrint('ProductImages: server unreachable: ${e.type}');
        aborted = true;
        message = 'Could not reach the server. Images fetched so far are kept.';
        break;
      }

      done++;
      onProgress?.call(done, ids.length);

      if (usedNetwork && pauseBetweenImages > Duration.zero) {
        await Future<void>.delayed(pauseBetweenImages);
      }

      if (consecutiveFailures >= _maxConsecutiveFailures) {
        aborted = true;
        message =
            'Stopped after $_maxConsecutiveFailures failures in a row. '
            'Try again later.';
        break;
      }
    }

    return build();
  }
}
