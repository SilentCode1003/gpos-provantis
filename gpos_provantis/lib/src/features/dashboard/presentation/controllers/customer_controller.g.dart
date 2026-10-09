// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CustomerController)
final customerControllerProvider = CustomerControllerProvider._();

final class CustomerControllerProvider
    extends $NotifierProvider<CustomerController, CustomerUiState> {
  CustomerControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerControllerHash();

  @$internal
  @override
  CustomerController create() => CustomerController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomerUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomerUiState>(value),
    );
  }
}

String _$customerControllerHash() =>
    r'bf3fa68d2f4d3e3dda22f3e0d1041b31bc81dea3';

abstract class _$CustomerController extends $Notifier<CustomerUiState> {
  CustomerUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CustomerUiState, CustomerUiState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CustomerUiState, CustomerUiState>,
              CustomerUiState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
