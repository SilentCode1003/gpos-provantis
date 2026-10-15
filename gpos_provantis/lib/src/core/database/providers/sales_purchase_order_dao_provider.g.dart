// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_purchase_order_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(salesPurchaseOrderDao)
final salesPurchaseOrderDaoProvider = SalesPurchaseOrderDaoProvider._();

final class SalesPurchaseOrderDaoProvider
    extends
        $FunctionalProvider<
          SalesPurchaseOrderDao,
          SalesPurchaseOrderDao,
          SalesPurchaseOrderDao
        >
    with $Provider<SalesPurchaseOrderDao> {
  SalesPurchaseOrderDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salesPurchaseOrderDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salesPurchaseOrderDaoHash();

  @$internal
  @override
  $ProviderElement<SalesPurchaseOrderDao> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SalesPurchaseOrderDao create(Ref ref) {
    return salesPurchaseOrderDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SalesPurchaseOrderDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SalesPurchaseOrderDao>(value),
    );
  }
}

String _$salesPurchaseOrderDaoHash() =>
    r'450d1701be2955f37f63631553963b67a6115f28';
