// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_drop_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CashDropController)
final cashDropControllerProvider = CashDropControllerProvider._();

final class CashDropControllerProvider
    extends $NotifierProvider<CashDropController, CashDropState> {
  CashDropControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cashDropControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cashDropControllerHash();

  @$internal
  @override
  CashDropController create() => CashDropController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CashDropState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CashDropState>(value),
    );
  }
}

String _$cashDropControllerHash() =>
    r'e5f5db8c57d2a9d83285e68a7f381ffe458d5fe2';

abstract class _$CashDropController extends $Notifier<CashDropState> {
  CashDropState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CashDropState, CashDropState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CashDropState, CashDropState>,
              CashDropState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
