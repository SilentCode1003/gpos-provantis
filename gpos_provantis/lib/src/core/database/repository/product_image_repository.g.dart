// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_image_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productImageRepository)
final productImageRepositoryProvider = ProductImageRepositoryProvider._();

final class ProductImageRepositoryProvider
    extends
        $FunctionalProvider<
          ProductImageRepository,
          ProductImageRepository,
          ProductImageRepository
        >
    with $Provider<ProductImageRepository> {
  ProductImageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productImageRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productImageRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProductImageRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductImageRepository create(Ref ref) {
    return productImageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductImageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductImageRepository>(value),
    );
  }
}

String _$productImageRepositoryHash() =>
    r'ac4bf58c07b2f879c651cd8bdc6c57272ac42467';
