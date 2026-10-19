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

/// One-off health probe against an arbitrary [baseUrl] (e.g.
/// `https://host:8080/`), independent of the saved domain.
///
/// Used by the setup screen to verify the address the user just typed BEFORE
/// it is persisted — [apiClientProvider] only knows the saved domain, so it
/// can't be used there. Hits the same endpoint as [ServerHealthController].
///
/// Returns `null` when the server answered with a 2xx, otherwise a short
/// human-readable reason the check failed.
Future<String?> probeServerHealth(
  String baseUrl, {
  Duration timeout = const Duration(seconds: 6),
}) async {
  final root = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
  final path = _healthCheckPath.startsWith('/')
      ? _healthCheckPath.substring(1)
      : _healthCheckPath;

  final dio = Dio(
    BaseOptions(
      connectTimeout: timeout,
      receiveTimeout: timeout,
      sendTimeout: timeout,
    ),
  );

  try {
    final response = await dio.get('$root$path');
    final code = response.statusCode;
    if (code != null && code >= 200 && code < 300) return null;
    return 'server responded with status ${code ?? 'unknown'}';
  } on DioException catch (e) {
    debugPrint('🔥 setup health probe failed: ${e.type} ${e.message}');
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'the server took too long to respond';
      case DioExceptionType.badCertificate:
        return 'the SSL certificate was rejected';
      case DioExceptionType.badResponse:
        return 'server responded with status '
            '${e.response?.statusCode ?? 'unknown'}';
      case DioExceptionType.connectionError:
        return 'the server could not be reached';
      default:
        return e.message ?? 'unknown network error';
    }
  } catch (e) {
    debugPrint('🔥 setup health probe error: $e');
    return 'unexpected error';
  } finally {
    dio.close(force: true);
  }
}

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

  // Starts the heartbeat timer and triggers a first check immediately.
  @override
  ServerHealthStatus build() {
    ref.onDispose(() => _timer?.cancel());
    _startPolling();
    return ServerHealthStatus.checking;
  }

  // Starts or refreshes the recurring health check timer.
  void _startPolling() {
    _timer?.cancel();
    // Fire one check immediately rather than waiting out the first
    // interval, then keep polling every 10s after that.
    unawaited(_check());
    _timer = Timer.periodic(_healthCheckInterval, (_) => _check());
  }

  // Pings the server and updates the current connection state.
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

  // Runs one check now and reports whether the server answered. Used by the
  // "Reconnect" button so it can wait for a real result. Leaves the poll
  // timer alone.
  Future<bool> checkNow() async {
    await _check();
    return state == ServerHealthStatus.online;
  }

  // Forces a fresh health check and resets the polling timer.
  Future<void> refresh() async {
    state = ServerHealthStatus.checking;
    _startPolling();
  }
}
