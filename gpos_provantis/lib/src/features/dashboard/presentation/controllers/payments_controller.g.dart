// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payments_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ePaymentMethods)
final ePaymentMethodsProvider = EPaymentMethodsProvider._();

final class EPaymentMethodsProvider
    extends
        $FunctionalProvider<
          List<PaymentMethod>,
          List<PaymentMethod>,
          List<PaymentMethod>
        >
    with $Provider<List<PaymentMethod>> {
  EPaymentMethodsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ePaymentMethodsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ePaymentMethodsHash();

  @$internal
  @override
  $ProviderElement<List<PaymentMethod>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<PaymentMethod> create(Ref ref) {
    return ePaymentMethods(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PaymentMethod> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PaymentMethod>>(value),
    );
  }
}

String _$ePaymentMethodsHash() => r'cacd6b67b3369570b1b6edb94db32e5b24b75f97';

@ProviderFor(PaymentController)
final paymentControllerProvider = PaymentControllerProvider._();

final class PaymentControllerProvider
    extends $NotifierProvider<PaymentController, PaymentState> {
  PaymentControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentControllerHash();

  @$internal
  @override
  PaymentController create() => PaymentController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaymentState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaymentState>(value),
    );
  }
}

String _$paymentControllerHash() => r'9a10ebf317bb7d0e97f44887115d38525e52a8de';

abstract class _$PaymentController extends $Notifier<PaymentState> {
  PaymentState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PaymentState, PaymentState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PaymentState, PaymentState>,
              PaymentState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
