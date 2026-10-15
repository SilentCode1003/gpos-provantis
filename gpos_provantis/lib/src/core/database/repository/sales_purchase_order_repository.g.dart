// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_purchase_order_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(salesPurchaseOrderRepository)
final salesPurchaseOrderRepositoryProvider =
    SalesPurchaseOrderRepositoryProvider._();

final class SalesPurchaseOrderRepositoryProvider
    extends
        $FunctionalProvider<
          SalesPurchaseOrderRepository,
          SalesPurchaseOrderRepository,
          SalesPurchaseOrderRepository
        >
    with $Provider<SalesPurchaseOrderRepository> {
  SalesPurchaseOrderRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salesPurchaseOrderRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salesPurchaseOrderRepositoryHash();

  @$internal
  @override
  $ProviderElement<SalesPurchaseOrderRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SalesPurchaseOrderRepository create(Ref ref) {
    return salesPurchaseOrderRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SalesPurchaseOrderRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SalesPurchaseOrderRepository>(value),
    );
  }
}

String _$salesPurchaseOrderRepositoryHash() =>
    r'8925e9d967099afe233316eb5aa22d61bccfebc6';
