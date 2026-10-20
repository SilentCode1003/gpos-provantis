import 'package:riverpod/riverpod.dart';

import 'package:gpos_provantis/src/core/database/providers/settings_dao_provider.dart';
import 'package:gpos_provantis/src/services/check_health_service.dart';
import 'package:gpos_provantis/src/services/sync/product_images_sync.dart';
import 'package:gpos_provantis/src/shared/widgets/toast_emitter.dart';

/// What the Product Images screen shows while one of its actions is running.
class ProductImagesJobState {
  const ProductImagesJobState({this.label, this.done = 0, this.total = 0});

  /// What is happening right now, or null when idle.
  final String? label;
  final int done;
  final int total;

  bool get busy => label != null;

  /// 0..1, or null when the total isn't known yet (shows a moving bar).
  double? get fraction => total > 0 ? done / total : null;
}

/// Written as a manual provider (no build_runner pass), and NOT auto-dispose:
/// a long download keeps going, and still reports back with a toast, if the
/// cashier leaves the Settings screen.
final productImagesJobProvider =
    NotifierProvider<ProductImagesJobController, ProductImagesJobState>(
      ProductImagesJobController.new,
    );

class ProductImagesJobController extends Notifier<ProductImagesJobState> {
  @override
  ProductImagesJobState build() => const ProductImagesJobState();

  // ---- the toggles / schedule: saved straight to the local settings --------

  Future<void> setShowImages(bool value) =>
      ref.read(settingsDaoProvider).setShowProductImages(value);

  Future<void> setAutoFetch(bool value) =>
      ref.read(settingsDaoProvider).setAutoFetchProductImages(value);

  /// 0 = off.
  Future<void> setRefetchDays(int days) =>
      ref.read(settingsDaoProvider).setProductImageRefetchDays(days);

  // ---- the two buttons ----------------------------------------------------

  /// Deletes every saved image, then downloads them all again.
  Future<void> deleteAndRefetch() async {
    if (state.busy) return;

    // Everything from `ref` is read before the first await.
    final sync = ref.read(productImagesSyncProvider);
    final toast = ref.read(toastEmitterProvider);
    final health = ref.read(serverHealthControllerProvider.notifier);

    state = const ProductImagesJobState(label: 'Checking the server…');
    try {
      // Never delete the pictures when they can't be downloaded again.
      if (!await health.checkNow()) {
        toast.error(
          'Can\'t reach the server, so nothing was deleted. '
          'Try again once the connection is back.',
        );
        return;
      }

      _set(const ProductImagesJobState(label: 'Deleting images…'));
      await sync.cancelAndWait(); // a background download may be running

      final result = await sync.deleteAndRefetch(
        onProgress: (done, total) => _set(
          ProductImagesJobState(
            label: 'Downloading images…',
            done: done,
            total: total,
          ),
        ),
      );

      if (result.aborted) {
        toast.warning(
          result.message ??
              'Stopped early. Use "Delete and download again" or a catalog '
                  'sync to get the rest.',
        );
      } else if (result.failed > 0) {
        toast.warning(
          '${result.downloaded} images downloaded, ${result.failed} failed. '
          'The failed ones are retried on the next sync.',
        );
      } else {
        toast.success('${result.downloaded} images downloaded.');
      }
    } catch (e) {
      toast.error('Could not refresh the images. ${_describe(e)}');
    } finally {
      _set(const ProductImagesJobState());
    }
  }

  /// Deletes every saved image AND turns automatic downloading off, so they
  /// stay gone.
  Future<void> deleteAndStop() async {
    if (state.busy) return;

    final sync = ref.read(productImagesSyncProvider);
    final dao = ref.read(settingsDaoProvider);
    final toast = ref.read(toastEmitterProvider);

    state = const ProductImagesJobState(label: 'Deleting images…');
    try {
      // Off FIRST, so no automatic download can start behind our back.
      await dao.setAutoFetchProductImages(false);
      await sync.cancelAndWait();

      if (await sync.deleteAll()) {
        toast.success(
          'Images deleted. Automatic downloading is off, so they won\'t '
          'come back.',
        );
      } else {
        toast.warning(
          'Automatic downloading is off, but the images could not be deleted '
          'because a download is still running. Try again in a moment.',
        );
      }
    } catch (e) {
      toast.error('Could not delete the images. ${_describe(e)}');
    } finally {
      _set(const ProductImagesJobState());
    }
  }

  void _set(ProductImagesJobState value) {
    if (ref.mounted) state = value;
  }

  String _describe(Object e) => e.toString().replaceFirst('Exception: ', '');
}
