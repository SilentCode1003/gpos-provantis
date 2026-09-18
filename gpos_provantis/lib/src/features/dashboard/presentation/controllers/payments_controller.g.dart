// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payments_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// E-payment methods available right now, mapped from whatever's synced
/// into the local `payments` table and filtered to active rows only —
/// the endpoint this table is synced from is `/payment/getactive` (see
/// `payments_repository.dart`), but a row's `status` can still flip
/// after it's already been synced/cached locally, so this re-checks
/// rather than trusting every cached row is still current.
///
/// A standalone provider rather than a getter on `PaymentController`
/// on purpose: a getter reached through `ref.read(provider.notifier)`
/// still runs `ref.watch(paymentsProvider)` internally, but the
/// *widget* calling that getter never itself subscribes to
/// `paymentsProvider` — so if the payments stream hadn't emitted yet
/// (e.g. right after login, before the first sync finishes), the
/// widget would render an empty list and then simply never rebuild
/// when the real data arrived a moment later, since nothing told it
/// to. Only a subsequent, unrelated rebuild (like the one from
/// tapping a tile) would happen to pick up the now-loaded data — which
/// is exactly the "first tap looks empty, second tap works" symptom
/// this caused. Calling `ref.watch(ePaymentMethodsProvider)` directly
/// from the widget subscribes it for real, so it rebuilds the instant
/// the underlying stream emits.

@ProviderFor(ePaymentMethods)
final ePaymentMethodsProvider = EPaymentMethodsProvider._();

/// E-payment methods available right now, mapped from whatever's synced
/// into the local `payments` table and filtered to active rows only —
/// the endpoint this table is synced from is `/payment/getactive` (see
/// `payments_repository.dart`), but a row's `status` can still flip
/// after it's already been synced/cached locally, so this re-checks
/// rather than trusting every cached row is still current.
///
/// A standalone provider rather than a getter on `PaymentController`
/// on purpose: a getter reached through `ref.read(provider.notifier)`
/// still runs `ref.watch(paymentsProvider)` internally, but the
/// *widget* calling that getter never itself subscribes to
/// `paymentsProvider` — so if the payments stream hadn't emitted yet
/// (e.g. right after login, before the first sync finishes), the
/// widget would render an empty list and then simply never rebuild
/// when the real data arrived a moment later, since nothing told it
/// to. Only a subsequent, unrelated rebuild (like the one from
/// tapping a tile) would happen to pick up the now-loaded data — which
/// is exactly the "first tap looks empty, second tap works" symptom
/// this caused. Calling `ref.watch(ePaymentMethodsProvider)` directly
/// from the widget subscribes it for real, so it rebuilds the instant
/// the underlying stream emits.

final class EPaymentMethodsProvider
    extends
        $FunctionalProvider<
          List<PaymentMethod>,
          List<PaymentMethod>,
          List<PaymentMethod>
        >
    with $Provider<List<PaymentMethod>> {
  /// E-payment methods available right now, mapped from whatever's synced
  /// into the local `payments` table and filtered to active rows only —
  /// the endpoint this table is synced from is `/payment/getactive` (see
  /// `payments_repository.dart`), but a row's `status` can still flip
  /// after it's already been synced/cached locally, so this re-checks
  /// rather than trusting every cached row is still current.
  ///
  /// A standalone provider rather than a getter on `PaymentController`
  /// on purpose: a getter reached through `ref.read(provider.notifier)`
  /// still runs `ref.watch(paymentsProvider)` internally, but the
  /// *widget* calling that getter never itself subscribes to
  /// `paymentsProvider` — so if the payments stream hadn't emitted yet
  /// (e.g. right after login, before the first sync finishes), the
  /// widget would render an empty list and then simply never rebuild
  /// when the real data arrived a moment later, since nothing told it
  /// to. Only a subsequent, unrelated rebuild (like the one from
  /// tapping a tile) would happen to pick up the now-loaded data — which
  /// is exactly the "first tap looks empty, second tap works" symptom
  /// this caused. Calling `ref.watch(ePaymentMethodsProvider)` directly
  /// from the widget subscribes it for real, so it rebuilds the instant
  /// the underlying stream emits.
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

String _$paymentControllerHash() => r'8eb72af3a223afdc945ee6690006ae499b5b5469';

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
