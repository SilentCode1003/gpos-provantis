// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(salesDao)
final salesDaoProvider = SalesDaoProvider._();

final class SalesDaoProvider
    extends $FunctionalProvider<SalesDao, SalesDao, SalesDao>
    with $Provider<SalesDao> {
  SalesDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salesDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salesDaoHash();

  @$internal
  @override
  $ProviderElement<SalesDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SalesDao create(Ref ref) {
    return salesDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SalesDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SalesDao>(value),
    );
  }
}

String _$salesDaoHash() => r'b5f9223fb3c4b6d413cfba9c16923d305127c387';
