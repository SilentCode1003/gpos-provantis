// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_price_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productPriceRepository)
final productPriceRepositoryProvider = ProductPriceRepositoryProvider._();

final class ProductPriceRepositoryProvider
    extends
        $FunctionalProvider<
          ProductPriceRepository,
          ProductPriceRepository,
          ProductPriceRepository
        >
    with $Provider<ProductPriceRepository> {
  ProductPriceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productPriceRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productPriceRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProductPriceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductPriceRepository create(Ref ref) {
    return productPriceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductPriceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductPriceRepository>(value),
    );
  }
}

String _$productPriceRepositoryHash() =>
    r'8a7638e7486060cb3c1a57788c73c95e6844051b';
