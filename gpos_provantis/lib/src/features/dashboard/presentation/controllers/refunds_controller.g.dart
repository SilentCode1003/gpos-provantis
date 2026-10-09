// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refunds_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RefundsController)
final refundsControllerProvider = RefundsControllerProvider._();

final class RefundsControllerProvider
    extends $NotifierProvider<RefundsController, RefundsState> {
  RefundsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refundsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refundsControllerHash();

  @$internal
  @override
  RefundsController create() => RefundsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RefundsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RefundsState>(value),
    );
  }
}

String _$refundsControllerHash() => r'bded541b9b5e2fe51a8eae435bb19f0596ea0ea5';

abstract class _$RefundsController extends $Notifier<RefundsState> {
  RefundsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<RefundsState, RefundsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RefundsState, RefundsState>,
              RefundsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
