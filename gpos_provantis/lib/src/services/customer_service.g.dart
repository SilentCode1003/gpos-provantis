// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(customerService)
final customerServiceProvider = CustomerServiceProvider._();

final class CustomerServiceProvider
    extends
        $FunctionalProvider<CustomerService, CustomerService, CustomerService>
    with $Provider<CustomerService> {
  CustomerServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerServiceHash();

  @$internal
  @override
  $ProviderElement<CustomerService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CustomerService create(Ref ref) {
    return customerService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomerService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomerService>(value),
    );
  }
}

String _$customerServiceHash() => r'789514724483582ec94dc9bc523faafb0644a9ef';
