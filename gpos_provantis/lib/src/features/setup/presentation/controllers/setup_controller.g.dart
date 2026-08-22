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
    extends $NotifierProvider<SetupController, void> {
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
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$setupControllerHash() => r'ec003de33952edce3cf8408f5f1c63706c258088';

abstract class _$SetupController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
