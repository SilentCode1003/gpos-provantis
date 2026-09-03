// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_sync.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(catalogSyncService)
final catalogSyncServiceProvider = CatalogSyncServiceProvider._();

final class CatalogSyncServiceProvider
    extends
        $FunctionalProvider<
          CatalogSyncService,
          CatalogSyncService,
          CatalogSyncService
        >
    with $Provider<CatalogSyncService> {
  CatalogSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogSyncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogSyncServiceHash();

  @$internal
  @override
  $ProviderElement<CatalogSyncService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CatalogSyncService create(Ref ref) {
    return catalogSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogSyncService>(value),
    );
  }
}

String _$catalogSyncServiceHash() =>
    r'ede2eb0442a360d7cc625a99b54fe5999aade310';
