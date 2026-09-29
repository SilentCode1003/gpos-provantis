// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discounts_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(discountsDao)
final discountsDaoProvider = DiscountsDaoProvider._();

final class DiscountsDaoProvider
    extends $FunctionalProvider<DiscountsDao, DiscountsDao, DiscountsDao>
    with $Provider<DiscountsDao> {
  DiscountsDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discountsDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discountsDaoHash();

  @$internal
  @override
  $ProviderElement<DiscountsDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DiscountsDao create(Ref ref) {
    return discountsDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiscountsDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiscountsDao>(value),
    );
  }
}

String _$discountsDaoHash() => r'98603291256cbaa61a3d9ea0c9f4dfb4619f3f75';
