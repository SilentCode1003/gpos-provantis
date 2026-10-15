// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_purchase_order_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(salesPurchaseOrderService)
final salesPurchaseOrderServiceProvider = SalesPurchaseOrderServiceProvider._();

final class SalesPurchaseOrderServiceProvider
    extends
        $FunctionalProvider<
          SalesPurchaseOrderService,
          SalesPurchaseOrderService,
          SalesPurchaseOrderService
        >
    with $Provider<SalesPurchaseOrderService> {
  SalesPurchaseOrderServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salesPurchaseOrderServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salesPurchaseOrderServiceHash();

  @$internal
  @override
  $ProviderElement<SalesPurchaseOrderService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SalesPurchaseOrderService create(Ref ref) {
    return salesPurchaseOrderService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SalesPurchaseOrderService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SalesPurchaseOrderService>(value),
    );
  }
}

String _$salesPurchaseOrderServiceHash() =>
    r'8583b1a1c1269f19e6f88d113ff87d49d9b9e57b';
