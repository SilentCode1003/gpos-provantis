// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_restart_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Thin wrapper around `Restart.restartApp()` so call sites depend on
/// this service (mockable/testable) rather than the package directly.

@ProviderFor(posRestartService)
final posRestartServiceProvider = PosRestartServiceProvider._();

/// Thin wrapper around `Restart.restartApp()` so call sites depend on
/// this service (mockable/testable) rather than the package directly.

final class PosRestartServiceProvider
    extends
        $FunctionalProvider<
          PosRestartService,
          PosRestartService,
          PosRestartService
        >
    with $Provider<PosRestartService> {
  /// Thin wrapper around `Restart.restartApp()` so call sites depend on
  /// this service (mockable/testable) rather than the package directly.
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
