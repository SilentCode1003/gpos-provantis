// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SetupController)
final setupControllerProvider = SetupControllerProvider._();

final class SetupControllerProvider
    extends $NotifierProvider<SetupController, SetupState> {
  SetupControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setupControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setupControllerHash();

  @$internal
  @override
  SetupController create() => SetupController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetupState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SetupState>(value),
    );
  }
}

String _$setupControllerHash() => r'6016f5f04fbd5f852438e004ab77a9f47b30b949';

abstract class _$SetupController extends $Notifier<SetupState> {
  SetupState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SetupState, SetupState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SetupState, SetupState>,
              SetupState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
