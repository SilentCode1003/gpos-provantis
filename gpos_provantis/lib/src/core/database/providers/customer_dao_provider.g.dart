// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(customerDao)
final customerDaoProvider = CustomerDaoProvider._();

final class CustomerDaoProvider
    extends $FunctionalProvider<CustomerDao, CustomerDao, CustomerDao>
    with $Provider<CustomerDao> {
  CustomerDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerDaoHash();

  @$internal
  @override
  $ProviderElement<CustomerDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CustomerDao create(Ref ref) {
    return customerDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomerDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomerDao>(value),
    );
  }
}

String _$customerDaoHash() => r'f16c6f53e89bd18575b728196aef9e7c3b073507';
