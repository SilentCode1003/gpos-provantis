import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/product_image_dao.dart';

part 'product_image_dao_provider.g.dart';

@Riverpod(keepAlive: true)
ProductImageDao productImageDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProductImageDao(db);
}

/// productId -> image file path, for every downloaded image. Live: updates as
/// the sync saves or deletes images.
///
/// Throttled: while the sync is saving pictures the grid hears about them in
/// batches (at most once per [_pathsThrottle]), not once per picture. The
/// first value is delivered immediately.
final productImagePathsProvider = StreamProvider<Map<int, String>>((ref) {
  return _throttleLatest(
    ref.watch(productImageDaoProvider).watchDownloadedPaths(),
    _pathsThrottle,
  );
});

const Duration _pathsThrottle = Duration(milliseconds: 1500);

/// Passes the first event straight through, then at most one event per
/// [interval], always the most recent one (nothing is lost, just batched).
Stream<T> _throttleLatest<T>(Stream<T> source, Duration interval) {
  late final StreamController<T> controller;
  StreamSubscription<T>? subscription;
  Timer? timer;
  T? pending;
  var hasPending = false;
  var cooling = false;

  void startCooldown() {
    cooling = true;
    timer = Timer(interval, () {
      cooling = false;
      if (hasPending) {
        final value = pending as T;
        pending = null;
        hasPending = false;
        controller.add(value);
        startCooldown();
      }
    });
  }

  controller = StreamController<T>(
    onListen: () {
      subscription = source.listen(
        (value) {
          if (cooling) {
            pending = value;
            hasPending = true;
          } else {
            controller.add(value);
            startCooldown();
          }
        },
        onError: controller.addError,
        onDone: controller.close,
      );
    },
    onCancel: () {
      timer?.cancel();
      return subscription?.cancel();
    },
  );
  return controller.stream;
}

/// The image file path of ONE product, or null if it has none (yet). Only
/// rebuilds the widget when that product's path changes.
///
///   final path = ref.watch(productImagePathProvider(product.productId));
///   path == null ? placeholder : Image.file(File(path), cacheWidth: 200);
final productImagePathProvider = Provider.family<String?, int>((ref, id) {
  return ref.watch(productImagePathsProvider.select((a) => a.value?[id]));
});
