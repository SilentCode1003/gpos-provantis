// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_price_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productPriceDao)
final productPriceDaoProvider = ProductPriceDaoProvider._();

final class ProductPriceDaoProvider
    extends
        $FunctionalProvider<ProductPriceDao, ProductPriceDao, ProductPriceDao>
    with $Provider<ProductPriceDao> {
  ProductPriceDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productPriceDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productPriceDaoHash();

  @$internal
  @override
  $ProviderElement<ProductPriceDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProductPriceDao create(Ref ref) {
    return productPriceDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductPriceDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductPriceDao>(value),
    );
  }
}

String _$productPriceDaoHash() => r'bd4f4d32771dfd46e032a6d82f4aeb044bbdb321';
