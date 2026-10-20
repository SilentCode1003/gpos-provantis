import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/product_image_dao.dart';
import 'package:gpos_provantis/src/core/database/daos/product_price_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/product_image_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/product_price_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/tables/product_image_table.dart';

import '../domain/product_image_dto.dart';

part 'product_image_repository.g.dart';

@Riverpod(keepAlive: true)
ProductImageRepository productImageRepository(Ref ref) {
  return ProductImageRepository(
    ref,
    ref.watch(productImageDaoProvider),
    ref.watch(productPriceDaoProvider),
  );
}

/// What happened for one product.
enum ImageFetchResult {
  /// Already saved on this device; the server was not called.
  alreadyLocal,

  /// Fetched, decoded and saved as a file.
  downloaded,

  /// The server has no image for this product.
  noImage,

  /// This product failed (bad data / server error). Others can still go on.
  failed,
}

class ProductImageRepository {
  final Ref _ref;
  final ProductImageDao _dao;
  final ProductPriceDao _productPriceDao;

  ProductImageRepository(this._ref, this._dao, this._productPriceDao);

  /// Makes sure [productId] has an image on this device.
  ///
  /// 1. Unless [force], a saved image whose file still exists is used as is
  ///    (no server call), and a product the server already said has no image
  ///    is not asked again.
  /// 2. Otherwise `/products/image` is called, the base64 is decoded and
  ///    written to disk in a background isolate, and only the file path /
  ///    status is stored in the DB.
  ///
  /// Connection problems (server unreachable, timeouts) are rethrown as
  /// [DioException] so a batch can stop instead of timing out on every
  /// product. Anything product-specific is recorded as `failed` and returned.
  Future<ImageFetchResult> ensureImage(
    int productId, {
    bool force = false,
  }) async {
    final existing = await _dao.getByProductId(productId);

    if (!force && existing != null) {
      if (existing.status == ProductImageStatus.downloaded) {
        final path = existing.filePath;
        if (path != null && await File(path).exists()) {
          return ImageFetchResult.alreadyLocal;
        }
        // Row says downloaded but the file is gone (storage cleared): refetch.
      } else if (existing.status == ProductImageStatus.none) {
        return ImageFetchResult.noImage;
      }
    }

    await _ref.read(domainConfigDaoProvider).cacheReady;
    final dio = _ref.read(apiClientProvider);

    try {
      final response = await dio.post(
        '/products/image',
        data: {'productid': productId.toString()},
      );

      final apiResponse =
          ApiResponseModel<List<ProductImageDto>>.fromDioResponse(
            response,
            fromJson: (data) => (data as List)
                .map((x) => ProductImageDto.fromJson(x as Map<String, dynamic>))
                .toList(),
          );

      final records = apiResponse.responseData;
      final dto = (records == null || records.isEmpty) ? null : records.first;

      if (dto == null || !dto.hasImage) {
        await _dao.upsert(
          ProductImageTableCompanion(
            productId: Value(productId),
            filePath: const Value(null),
            status: const Value(ProductImageStatus.none),
            fetchedAt: Value(DateTime.now()),
            lastError: const Value(null),
          ),
        );
        await _deleteFile(existing?.filePath);
        return ImageFetchResult.noImage;
      }

      final dir = await _imagesDir();
      final stem = 'p${productId}_${DateTime.now().millisecondsSinceEpoch}';
      // Small images (the normal case) are decoded right here: that takes
      // well under a millisecond, which is far cheaper than spawning an
      // isolate (tens of ms on a weak device), and the file write is async so
      // it doesn't block the UI either. Only unusually large payloads go to a
      // background isolate.
      final savedPath = dto.productImage.length < _isolateThresholdChars
          ? await _decodeAndWriteAsync(dto.productImage, dir.path, stem)
          : await _decodeInIsolate(dto.productImage, dir.path, stem);

      if (savedPath == null) {
        await _recordFailure(
          productId,
          existing,
          'The server sent data that is not a valid image.',
        );
        return ImageFetchResult.failed;
      }

      await _dao.upsert(
        ProductImageTableCompanion(
          productId: Value(productId),
          filePath: Value(savedPath),
          status: const Value(ProductImageStatus.downloaded),
          fetchedAt: Value(DateTime.now()),
          lastError: const Value(null),
        ),
      );

      // The new file has a new name (so Flutter's image cache can't show the
      // old picture); remove the old one only now that the new one is safe.
      if (existing?.filePath != null && existing!.filePath != savedPath) {
        await _deleteFile(existing.filePath);
      }
      return ImageFetchResult.downloaded;
    } on DioException catch (e) {
      if (_isConnectionProblem(e)) rethrow;
      debugPrint('ProductImages: $productId failed: ${e.message}');
      await _recordFailure(
        productId,
        existing,
        'Server error${e.response?.statusCode != null ? ' (${e.response!.statusCode})' : ''}.',
      );
      return ImageFetchResult.failed;
    } catch (e) {
      debugPrint('ProductImages: $productId failed: $e');
      await _recordFailure(productId, existing, e.toString());
      return ImageFetchResult.failed;
    }
  }

  /// Product ids that still need an image: never fetched, failed, or whose
  /// file has gone missing from disk. Products the server said have no image
  /// are skipped unless [includeNoImage].
  Future<List<int>> productIdsMissingImage({
    bool includeNoImage = false,
  }) async {
    final products = await _productPriceDao.getAllProductPrices();
    final rows = {for (final r in await _dao.getAll()) r.productId: r};
    // One directory listing instead of one File.exists() per product.
    final onDisk = await _fileNamesOnDisk();

    final missing = <int>[];
    for (final p in products) {
      if (p.productId <= 0) continue;
      final row = rows[p.productId];
      if (row == null) {
        missing.add(p.productId);
        continue;
      }
      switch (row.status) {
        case ProductImageStatus.downloaded:
          final path = row.filePath;
          if (path == null || !onDisk.contains(_baseName(path))) {
            missing.add(p.productId);
          }
        case ProductImageStatus.none:
          if (includeNoImage) missing.add(p.productId);
        default:
          missing.add(p.productId);
      }
    }
    return missing;
  }

  Future<Set<String>> _fileNamesOnDisk() async {
    final names = <String>{};
    try {
      final dir = await _imagesDir();
      if (!await dir.exists()) return names;
      await for (final e in dir.list(followLinks: false)) {
        if (e is File) names.add(_baseName(e.path));
      }
    } catch (e) {
      debugPrint('ProductImages: could not list image folder: $e');
    }
    return names;
  }

  static String _baseName(String path) =>
      path.substring(path.lastIndexOf(Platform.pathSeparator) + 1);

  /// Every product id in the local price list.
  Future<List<int>> allProductIds() async {
    final products = await _productPriceDao.getAllProductPrices();
    return [
      for (final p in products)
        if (p.productId > 0) p.productId,
    ];
  }

  /// Deletes one product's image (file + record).
  Future<void> deleteImage(int productId) async {
    final row = await _dao.getByProductId(productId);
    await _dao.deleteByProductId(productId);
    await _deleteFile(row?.filePath);
  }

  /// Deletes every record and every image file.
  Future<void> deleteAllImages() async {
    await _dao.deleteAll(); // records first, so the UI stops pointing at files
    try {
      final dir = await _imagesDir();
      if (await dir.exists()) await dir.delete(recursive: true);
    } catch (e) {
      debugPrint('ProductImages: could not clear image folder: $e');
    }
  }

  // ---- helpers ------------------------------------------------------------

  Future<Directory> _imagesDir() async {
    final base = await getApplicationSupportDirectory();
    return Directory('${base.path}${Platform.pathSeparator}product_images');
  }

  Future<void> _deleteFile(String? path) async {
    if (path == null) return;
    try {
      final f = File(path);
      if (await f.exists()) await f.delete();
    } catch (e) {
      debugPrint('ProductImages: could not delete $path: $e');
    }
  }

  // A failed re-fetch must not throw away an image we already have.
  Future<void> _recordFailure(
    int productId,
    ProductImageTableData? existing,
    String message,
  ) {
    final keepsImage =
        existing?.status == ProductImageStatus.downloaded &&
        existing?.filePath != null;
    return _dao.upsert(
      ProductImageTableCompanion(
        productId: Value(productId),
        status: keepsImage
            ? const Value.absent()
            : const Value(ProductImageStatus.failed),
        lastError: Value(message),
      ),
    );
  }

  bool _isConnectionProblem(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      default:
        return false;
    }
  }
}

// ---- decoding ---------------------------------------------------------------

/// Payloads shorter than this many base64 characters (~110 KB of image) are
/// decoded on the calling isolate; longer ones go to a background isolate.
const int _isolateThresholdChars = 150000;

/// Decodes base64 and writes `<dir>/<stem>.<ext>` with an async write, via a
/// temp file so a half-written image is never seen. Null if it isn't an image.
Future<String?> _decodeAndWriteAsync(
  String raw,
  String dirPath,
  String stem,
) async {
  final decoded = _decodeImageBytes(raw);
  if (decoded == null) return null;

  await Directory(dirPath).create(recursive: true);
  final finalPath = '$dirPath${Platform.pathSeparator}$stem.${decoded.$2}';
  final tmp = File('$finalPath.tmp');
  await tmp.writeAsBytes(decoded.$1, flush: true);
  await tmp.rename(finalPath);
  return finalPath;
}

// Top-level on purpose: the closure captures only plain strings, never `this`.
Future<String?> _decodeInIsolate(String raw, String dirPath, String stem) {
  return Isolate.run(() => _decodeAndWriteImage(raw, dirPath, stem));
}

/// Runs in the isolate (blocking calls are fine there).
String? _decodeAndWriteImage(String raw, String dirPath, String stem) {
  final decoded = _decodeImageBytes(raw);
  if (decoded == null) return null;

  Directory(dirPath).createSync(recursive: true);
  final finalPath = '$dirPath${Platform.pathSeparator}$stem.${decoded.$2}';
  final tmp = File('$finalPath.tmp');
  tmp.writeAsBytesSync(decoded.$1, flush: true);
  tmp.renameSync(finalPath);
  return finalPath;
}

/// base64 -> (bytes, extension), or null if it isn't valid base64 / a
/// recognisable image.
(Uint8List, String)? _decodeImageBytes(String raw) {
  var data = raw.trim();
  final comma = data.indexOf(',');
  if (data.startsWith('data:') && comma != -1) {
    data = data.substring(comma + 1); // strip "data:image/png;base64,"
  }

  final Uint8List bytes;
  try {
    bytes = base64.decode(base64.normalize(data.replaceAll(RegExp(r'\s'), '')));
  } on FormatException {
    return null;
  }

  final ext = _sniffExtension(bytes);
  return ext == null ? null : (bytes, ext);
}

String? _sniffExtension(Uint8List b) {
  if (b.length >= 4 &&
      b[0] == 0x89 &&
      b[1] == 0x50 &&
      b[2] == 0x4E &&
      b[3] == 0x47) {
    return 'png';
  }
  if (b.length >= 3 && b[0] == 0xFF && b[1] == 0xD8 && b[2] == 0xFF) {
    return 'jpg';
  }
  if (b.length >= 4 && b[0] == 0x47 && b[1] == 0x49 && b[2] == 0x46) {
    return 'gif';
  }
  if (b.length >= 12 &&
      b[0] == 0x52 &&
      b[1] == 0x49 &&
      b[2] == 0x46 &&
      b[3] == 0x46 &&
      b[8] == 0x57 &&
      b[9] == 0x45 &&
      b[10] == 0x42 &&
      b[11] == 0x50) {
    return 'webp';
  }
  return null;
}
