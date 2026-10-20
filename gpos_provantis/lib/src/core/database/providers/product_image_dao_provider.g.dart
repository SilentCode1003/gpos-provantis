// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_image_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productImageDao)
final productImageDaoProvider = ProductImageDaoProvider._();

final class ProductImageDaoProvider
    extends
        $FunctionalProvider<ProductImageDao, ProductImageDao, ProductImageDao>
    with $Provider<ProductImageDao> {
  ProductImageDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productImageDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productImageDaoHash();

  @$internal
  @override
  $ProviderElement<ProductImageDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProductImageDao create(Ref ref) {
    return productImageDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductImageDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductImageDao>(value),
    );
  }
}

String _$productImageDaoHash() => r'b0ed29b7b7b7c640be6fba0eb695ac53e1d6160f';
