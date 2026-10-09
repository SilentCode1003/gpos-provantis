// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipts_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReceiptsController)
final receiptsControllerProvider = ReceiptsControllerProvider._();

final class ReceiptsControllerProvider
    extends $NotifierProvider<ReceiptsController, ReceiptsState> {
  ReceiptsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'receiptsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$receiptsControllerHash();

  @$internal
  @override
  ReceiptsController create() => ReceiptsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReceiptsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReceiptsState>(value),
    );
  }
}

String _$receiptsControllerHash() =>
    r'158bb3928f4055b86c2c0f16b1ed45e5c9949d27';

abstract class _$ReceiptsController extends $Notifier<ReceiptsState> {
  ReceiptsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ReceiptsState, ReceiptsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReceiptsState, ReceiptsState>,
              ReceiptsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
