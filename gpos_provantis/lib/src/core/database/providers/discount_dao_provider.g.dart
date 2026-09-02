// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(discountDao)
final discountDaoProvider = DiscountDaoProvider._();

final class DiscountDaoProvider
    extends $FunctionalProvider<DiscountDao, DiscountDao, DiscountDao>
    with $Provider<DiscountDao> {
  DiscountDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discountDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discountDaoHash();

  @$internal
  @override
  $ProviderElement<DiscountDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DiscountDao create(Ref ref) {
    return discountDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiscountDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiscountDao>(value),
    );
  }
}

String _$discountDaoHash() => r'ba1b54fe5e51dd70cde8d1c45866ea318156ec7f';
