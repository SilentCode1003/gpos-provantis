// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_images_sync.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productImagesSync)
final productImagesSyncProvider = ProductImagesSyncProvider._();

final class ProductImagesSyncProvider
    extends
        $FunctionalProvider<
          ProductImagesSync,
          ProductImagesSync,
          ProductImagesSync
        >
    with $Provider<ProductImagesSync> {
  ProductImagesSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productImagesSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productImagesSyncHash();

  @$internal
  @override
  $ProviderElement<ProductImagesSync> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductImagesSync create(Ref ref) {
    return productImagesSync(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductImagesSync value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductImagesSync>(value),
    );
  }
}

String _$productImagesSyncHash() => r'370fffb19fc2cd12fa248d50769bf65ee15c8508';
