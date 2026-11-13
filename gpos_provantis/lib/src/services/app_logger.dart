import 'dart:async';
import 'dart:convert';
import 'dart:ui' show PlatformDispatcher;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart' show FlutterError, debugPrint;
import 'package:riverpod/riverpod.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/app_log_dao.dart';

enum LogLevel { info, warn, error }

final appLogDaoProvider = Provider<AppLogDao>(
  (ref) => AppLogDao(ref.watch(appDatabaseProvider)),
);

final appLoggerProvider = Provider<AppLogger>(
  (ref) => AppLogger(ref.watch(appLogDaoProvider)),
);

/// The log shown on Settings > Developer, newest first.
final appLogsProvider = StreamProvider.autoDispose<List<AppLogTableData>>(
  (ref) => ref.watch(appLogDaoProvider).watchLatest(),
);

/// Writes important events to the on-device developer log (and the console).
///
/// It NEVER throws: a problem while logging must not break a sale. Tokens and
/// passwords are blanked out, long text is cut, and the same entry repeating
/// (an offline device failing every 30 seconds) is stored once per
/// [_repeatWindow] instead of flooding the log.
class AppLogger {
  AppLogger(this._dao);

  final AppLogDao _dao;

  static const _repeatWindow = Duration(minutes: 10);
  final _lastSeen = <String, DateTime>{};
  int _writes = 0;

  Future<void> info(
    String source,
    String message, {
    String? detailId,
    Map<String, Object?>? context,
  }) => _write(
    LogLevel.info,
    source,
    message,
    detailId: detailId,
    context: context,
  );

  Future<void> warn(
    String source,
    String message, {
    String? detailId,
    Map<String, Object?>? context,
  }) => _write(
    LogLevel.warn,
    source,
    message,
    detailId: detailId,
    context: context,
  );

  Future<void> error(
    String source,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? detailId,
    Map<String, Object?>? context,
  }) => _write(
    LogLevel.error,
    source,
    message,
    detailId: detailId,
    context: context,
    error: error,
    stackTrace: stackTrace,
  );

  Future<void> _write(
    LogLevel level,
    String source,
    String message, {
    String? detailId,
    Map<String, Object?>? context,
    Object? error,
    StackTrace? stackTrace,
  }) async {
    try {
      final text = _clip(_redact(message), 2000);
      debugPrint('[${level.name.toUpperCase()}] $source: $text');

      final now = DateTime.now();
      final key = '${level.name}|$source|${detailId ?? ''}|$text';
      final last = _lastSeen[key];
      if (last != null && now.difference(last) < _repeatWindow) return;
      _lastSeen[key] = now;
      if (_lastSeen.length > 500) {
        _lastSeen.removeWhere((_, t) => now.difference(t) >= _repeatWindow);
        if (_lastSeen.length > 500) _lastSeen.clear();
      }

      final details = <String, Object?>{...?context};
      if (error != null) details['error'] = error.toString();
      final contextJson = details.isEmpty
          ? null
          : _clip(
              _redact(jsonEncode(details, toEncodable: (o) => o.toString())),
              8000,
            );

      await _dao.add(
        AppLogTableCompanion.insert(
          level: level.name.toUpperCase(),
          source: source,
          message: text,
          detailId: Value(detailId),
          context: Value(contextJson),
          stackTrace: Value(
            stackTrace == null ? null : _clip(stackTrace.toString(), 6000),
          ),
        ),
      );

      if (_writes++ % 50 == 0) {
        unawaited(_dao.prune().then((_) {}, onError: (Object _) {}));
      }
    } catch (e) {
      debugPrint('AppLogger: could not write a log entry: $e');
    }
  }

  static final _secret = RegExp(
    r'''"?\b(apk|password|pin|token|authorization|secret)\b"?\s*[:=]\s*("[^"]*"|[^,}\s]+)''',
    caseSensitive: false,
  );
  static final _bearer = RegExp(
    r'Bearer\s+[A-Za-z0-9\-._~+/]+=*',
    caseSensitive: false,
  );

  static String _redact(String text) {
    return text
        .replaceAllMapped(_bearer, (_) => 'Bearer [redacted]')
        .replaceAllMapped(_secret, (m) => '"${m[1]}": "[redacted]"');
  }

  static String _clip(String text, int max) =>
      text.length <= max ? text : '${text.substring(0, max)}… [cut]';
}

/// Sends uncaught Flutter and async errors to the developer log, without
/// replacing what the app already does with them. Call once at start-up.
void installGlobalErrorLogging(AppLogger logger) {
  final previousFlutter = FlutterError.onError;
  FlutterError.onError = (details) {
    logger.error(
      'flutter',
      details.exceptionAsString(),
      error: details.exception,
      stackTrace: details.stack,
      context: {'library': details.library},
    );
    if (previousFlutter != null) {
      previousFlutter(details);
    } else {
      FlutterError.presentError(details);
    }
  };

  final previousPlatform = PlatformDispatcher.instance.onError;
  PlatformDispatcher.instance.onError = (error, stack) {
    logger.error('uncaught', error.toString(), error: error, stackTrace: stack);
    return previousPlatform?.call(error, stack) ?? false;
  };
}
