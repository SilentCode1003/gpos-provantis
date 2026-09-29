// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_restart_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(posRestartService)
final posRestartServiceProvider = PosRestartServiceProvider._();

final class PosRestartServiceProvider
    extends
        $FunctionalProvider<
          PosRestartService,
          PosRestartService,
          PosRestartService
        >
    with $Provider<PosRestartService> {
  PosRestartServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'posRestartServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$posRestartServiceHash();

  @$internal
  @override
  $ProviderElement<PosRestartService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PosRestartService create(Ref ref) {
    return posRestartService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PosRestartService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PosRestartService>(value),
    );
  }
}

String _$posRestartServiceHash() => r'5222d5b2bd3bee032536d610adc9308c47e3bb3c';
