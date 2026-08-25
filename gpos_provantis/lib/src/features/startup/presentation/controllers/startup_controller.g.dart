// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'startup_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StartupController)
final startupControllerProvider = StartupControllerFamily._();

final class StartupControllerProvider
    extends $AsyncNotifierProvider<StartupController, StartupDestination> {
  StartupControllerProvider._({
    required StartupControllerFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'startupControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$startupControllerHash();

  @override
  String toString() {
    return r'startupControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  StartupController create() => StartupController();

  @override
  bool operator ==(Object other) {
    return other is StartupControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$startupControllerHash() => r'fbae12d3761ca60e3c7ccdfe6b123704a3b534b7';

final class StartupControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          StartupController,
          AsyncValue<StartupDestination>,
          StartupDestination,
          FutureOr<StartupDestination>,
          bool
        > {
  StartupControllerFamily._()
    : super(
        retry: null,
        name: r'startupControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StartupControllerProvider call({bool enforceMinDuration = true}) =>
      StartupControllerProvider._(argument: enforceMinDuration, from: this);

  @override
  String toString() => r'startupControllerProvider';
}

abstract class _$StartupController extends $AsyncNotifier<StartupDestination> {
  late final _$args = ref.$arg as bool;
  bool get enforceMinDuration => _$args;

  FutureOr<StartupDestination> build({bool enforceMinDuration = true});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<StartupDestination>, StartupDestination>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<StartupDestination>, StartupDestination>,
              AsyncValue<StartupDestination>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(enforceMinDuration: _$args));
  }
}
