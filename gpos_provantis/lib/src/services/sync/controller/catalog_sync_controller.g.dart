// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_sync_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CatalogSyncController)
final catalogSyncControllerProvider = CatalogSyncControllerProvider._();

final class CatalogSyncControllerProvider
    extends $NotifierProvider<CatalogSyncController, CatalogSyncState> {
  CatalogSyncControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogSyncControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogSyncControllerHash();

  @$internal
  @override
  CatalogSyncController create() => CatalogSyncController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogSyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogSyncState>(value),
    );
  }
}

String _$catalogSyncControllerHash() =>
    r'9deaaf84b05472a0d747e4469b9dd8859fd3e98e';

abstract class _$CatalogSyncController extends $Notifier<CatalogSyncState> {
  CatalogSyncState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CatalogSyncState, CatalogSyncState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CatalogSyncState, CatalogSyncState>,
              CatalogSyncState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
