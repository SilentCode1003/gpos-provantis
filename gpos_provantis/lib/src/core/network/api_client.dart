// lib/core/network/api_client.dart

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/features/login/data_sources/login_local_data_source.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'dedupe_interceptor.dart';
import 'package:flutter/material.dart';

part 'api_client.g.dart';

@riverpod
Dio apiClient(Ref ref) {
  // activeDomainProvider is a Stream<String?> provider (it watches the DB
  // row via DomainConfigDao.watchDomain()), so ref.watch returns an
  // AsyncValue<String?> here, not a plain String?.
  //
  // `.value` on an AsyncValue returns the last emitted value regardless of
  // whether the stream is currently loading, has an error, or has data —
  // so on the very first app launch, before the stream's first event has
  // arrived, this will be null and fall through to the inert placeholder
  // below. That's expected: this provider is NOT keepAlive, so as soon as
  // the stream emits (which happens immediately once DomainConfigDao reads
  // the DB), apiClient rebuilds automatically with the real baseUrl. Any
  // in-flight request made during that brief window would hit the inert
  // URL and fail fast rather than silently hang, which is the safer
  // failure mode.
  final domainAsync = ref.watch(activeDomainProvider);
  final baseUrl = domainAsync.value ?? 'http://0.0.0.0/';

  // 🔍 Confirms what apiClient actually resolved as baseUrl on this build.
  // If you see 'http://0.0.0.0/' here, activeDomainProvider hadn't emitted
  // yet when this ran (see note above) — the fix there is to wait/retry,
  // not to treat this as the real failure. If you see a real domain but
  // it's still the wrong protocol/host/port, the bug is upstream in
  // SetupController's URL composition, not here.
  debugPrint('🌐 apiClient baseUrl resolved: $baseUrl');
  debugPrint('🌐 activeDomainProvider raw AsyncValue: $domainAsync');

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  dio.interceptors.add(DedupeInterceptor());

  final dataSource = ref.watch(loginLocalDataSourceProvider);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? apk;
        try {
          final user = await dataSource.watchCurrentUser().first;
          apk = user?.apk;
        } catch (e, st) {
          debugPrint('🔥 interceptor DB read error: $e');
          debugPrint('$st');
        }

        if (apk != null && apk.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $apk';
          final method = options.method.toUpperCase();
          if (method == 'GET' || method == 'DELETE') {
            // Context-specific params handled in features
          } else {
            // Rebuild as Map<String, dynamic> instead of mutating a
            // possibly narrower-typed map (e.g. Map<String, int> when the
            // caller passed a literal like {requestid: 32105}) in place.
            final existing = options.data;
            if (existing is Map) {
              options.data = <String, dynamic>{...existing, 'APK': apk};
            } else if (existing == null) {
              options.data = <String, dynamic>{'APK': apk};
            }
            // else: non-map body (FormData, etc.) — leave untouched.
          }
        } else {
          // Expected during setup / initial sync: no user has logged in
          // yet, so there's no APK. Branch and POS config endpoints don't
          // require it, so this placeholder header is harmless for them.
          options.headers['Authorization'] = 'Bearer missing_local_apk';
        }

        // 🔍 DEBUG LOGGING — request
        debugPrint('>>> ${options.method} ${options.uri}');
        debugPrint('>>> baseUrl: ${options.baseUrl}');
        debugPrint('>>> path: ${options.path}');
        debugPrint('>>> headers: ${options.headers}');
        debugPrint('>>> data: ${options.data}');
        return handler.next(options);
      },
      onError: (error, handler) {
        // 🔍 DEBUG LOGGING — error. DioExceptionType tells you which
        // failure mode this actually is:
        //   connectionError   -> couldn't reach the host at all (wrong
        //                        domain/port, device not on the same
        //                        network, server down, firewall)
        //   connectionTimeout -> reached network stack but no response
        //                        within connectTimeout (60s here)
        //   badResponse       -> got a response, but non-2xx status
        //   cancel            -> DedupeInterceptor blocked a duplicate,
        //                        or the request was cancelled elsewhere
        debugPrint('<<< ERROR type: ${error.type}');
        debugPrint('<<< ERROR message: ${error.message}');
        debugPrint('<<< ERROR requested URI: ${error.requestOptions.uri}');
        debugPrint(
          '<<< ERROR ${error.response?.statusCode} for ${error.requestOptions.uri}',
        );
        debugPrint('<<< response data: ${error.response?.data}');
        debugPrint('<<< underlying error: ${error.error}');
        return handler.next(error);
      },
    ),
  );
  return dio;
}
