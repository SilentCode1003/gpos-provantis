// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payments_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(paymentsDao)
final paymentsDaoProvider = PaymentsDaoProvider._();

final class PaymentsDaoProvider
    extends $FunctionalProvider<PaymentsDao, PaymentsDao, PaymentsDao>
    with $Provider<PaymentsDao> {
  PaymentsDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentsDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentsDaoHash();

  @$internal
  @override
  $ProviderElement<PaymentsDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PaymentsDao create(Ref ref) {
    return paymentsDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaymentsDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaymentsDao>(value),
    );
  }
}

String _$paymentsDaoHash() => r'd412de5f9e936ed4ca8501120e5255ff099eb01f';
