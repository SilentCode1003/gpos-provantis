// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_health_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// --- Server health polling ---------------------------------------------------
///
/// Pings `/checkhealth/check-health` on [apiClientProvider]'s [Dio] instance
/// every 10 seconds for as long as the app is running, and exposes the
/// result as [ServerHealthStatus] for any widget to watch — e.g. a colored
/// indicator on the dashboard top bar.
///
/// This is deliberately foreground-only: the timer lives for as long as this
/// provider is kept alive (see `keepAlive: true` below) and stops the moment
/// the app process dies. There's no platform background-execution here
/// (no `workmanager`, no iOS background fetch) — this app runs on a POS
/// tablet that's expected to stay open, so that scope wasn't needed.
///
/// `keepAlive: true` matches [ThemeModeController]'s pattern: this should
/// keep polling across navigation, not get disposed the moment the widget
/// watching it unmounts.

@ProviderFor(ServerHealthController)
final serverHealthControllerProvider = ServerHealthControllerProvider._();

/// --- Server health polling ---------------------------------------------------
///
/// Pings `/checkhealth/check-health` on [apiClientProvider]'s [Dio] instance
/// every 10 seconds for as long as the app is running, and exposes the
/// result as [ServerHealthStatus] for any widget to watch — e.g. a colored
/// indicator on the dashboard top bar.
///
/// This is deliberately foreground-only: the timer lives for as long as this
/// provider is kept alive (see `keepAlive: true` below) and stops the moment
/// the app process dies. There's no platform background-execution here
/// (no `workmanager`, no iOS background fetch) — this app runs on a POS
/// tablet that's expected to stay open, so that scope wasn't needed.
///
/// `keepAlive: true` matches [ThemeModeController]'s pattern: this should
/// keep polling across navigation, not get disposed the moment the widget
/// watching it unmounts.
final class ServerHealthControllerProvider
    extends $NotifierProvider<ServerHealthController, ServerHealthStatus> {
  /// --- Server health polling ---------------------------------------------------
  ///
  /// Pings `/checkhealth/check-health` on [apiClientProvider]'s [Dio] instance
  /// every 10 seconds for as long as the app is running, and exposes the
  /// result as [ServerHealthStatus] for any widget to watch — e.g. a colored
  /// indicator on the dashboard top bar.
  ///
  /// This is deliberately foreground-only: the timer lives for as long as this
  /// provider is kept alive (see `keepAlive: true` below) and stops the moment
  /// the app process dies. There's no platform background-execution here
  /// (no `workmanager`, no iOS background fetch) — this app runs on a POS
  /// tablet that's expected to stay open, so that scope wasn't needed.
  ///
  /// `keepAlive: true` matches [ThemeModeController]'s pattern: this should
  /// keep polling across navigation, not get disposed the moment the widget
  /// watching it unmounts.
  ServerHealthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverHealthControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverHealthControllerHash();

  @$internal
  @override
  ServerHealthController create() => ServerHealthController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerHealthStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServerHealthStatus>(value),
    );
  }
}

String _$serverHealthControllerHash() =>
    r'b51801d58d3e5879527a651a254f0f5cf485b147';

/// --- Server health polling ---------------------------------------------------
///
/// Pings `/checkhealth/check-health` on [apiClientProvider]'s [Dio] instance
/// every 10 seconds for as long as the app is running, and exposes the
/// result as [ServerHealthStatus] for any widget to watch — e.g. a colored
/// indicator on the dashboard top bar.
///
/// This is deliberately foreground-only: the timer lives for as long as this
/// provider is kept alive (see `keepAlive: true` below) and stops the moment
/// the app process dies. There's no platform background-execution here
/// (no `workmanager`, no iOS background fetch) — this app runs on a POS
/// tablet that's expected to stay open, so that scope wasn't needed.
///
/// `keepAlive: true` matches [ThemeModeController]'s pattern: this should
/// keep polling across navigation, not get disposed the moment the widget
/// watching it unmounts.

abstract class _$ServerHealthController extends $Notifier<ServerHealthStatus> {
  ServerHealthStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ServerHealthStatus, ServerHealthStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ServerHealthStatus, ServerHealthStatus>,
              ServerHealthStatus,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
