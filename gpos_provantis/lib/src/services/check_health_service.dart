// Location: src/services/health/check_health_service.dart
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/network/api_client.dart';

part 'check_health_service.g.dart';

/// How often the app pings the server while running. Foreground-only by
/// design (see the class doc below) — this is a plain in-app [Timer], not a
/// platform background task, which is fine for a POS tablet that's expected
/// to stay open.
const Duration _healthCheckInterval = Duration(seconds: 10);

const String _healthCheckPath = '/checkhealth/alive';

/// Tri-state result of the server health check.
///
/// [checking] is also the state before the very first check has resolved —
/// callers (e.g. an avatar border) should render this as a neutral color
/// rather than assuming online or offline.
enum ServerHealthStatus { checking, online, offline }

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
@Riverpod(keepAlive: true)
class ServerHealthController extends _$ServerHealthController {
  Timer? _timer;

  @override
  ServerHealthStatus build() {
    ref.onDispose(() => _timer?.cancel());
    _startPolling();
    return ServerHealthStatus.checking;
  }

  void _startPolling() {
    _timer?.cancel();
    // Fire one check immediately rather than waiting out the first
    // interval, then keep polling every 10s after that.
    unawaited(_check());
    _timer = Timer.periodic(_healthCheckInterval, (_) => _check());
  }

  Future<void> _check() async {
    try {
      final dio = ref.read(apiClientProvider);
      final response = await dio.get(_healthCheckPath);
      final ok =
          response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
      state = ok ? ServerHealthStatus.online : ServerHealthStatus.offline;
    } on DioException catch (e, st) {
      debugPrint('🔥 health check failed: ${e.message}');
      debugPrint('$st');
      state = ServerHealthStatus.offline;
    } catch (e, st) {
      // apiClientProvider throws StateError synchronously if no domain has
      // been configured yet — treat that the same as "server unreachable"
      // rather than letting it crash the poll loop.
      debugPrint('🔥 health check error: $e');
      debugPrint('$st');
      state = ServerHealthStatus.offline;
    }
  }

  /// Force an immediate check, independent of the 10s timer. Used by the
  /// "Refresh connection" action in the top bar's profile menu. Resets the
  /// timer so the next automatic check is a full interval after this one,
  /// rather than firing again almost immediately.
  Future<void> refresh() async {
    state = ServerHealthStatus.checking;
    _startPolling();
  }
}
