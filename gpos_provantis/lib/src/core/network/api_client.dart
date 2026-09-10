// lib/core/network/api_client.dart

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/providers/user_data_dao_provider.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'dedupe_interceptor.dart';
import 'package:flutter/material.dart';

part 'api_client.g.dart';

@riverpod
Dio apiClient(Ref ref) {
  final domainAsync = ref.watch(activeDomainProvider);
  final dao = ref.watch(domainConfigDaoProvider);
  final baseUrl = domainAsync.value ?? dao.cachedDomain;

  // debugPrint('🌐 apiClient baseUrl resolved: $baseUrl');
  // debugPrint('🌐 activeDomainProvider raw AsyncValue: $domainAsync');
  // debugPrint('🌐 DomainConfigDao.cachedDomain: ${dao.cachedDomain}');

  if (baseUrl == null || baseUrl.isEmpty) {
    throw StateError(
      'apiClient was built before a domain was available '
      '(activeDomainProvider: $domainAsync, cachedDomain: ${dao.cachedDomain}). '
      'Callers must ensure setup has saved a domain before making requests.',
    );
  }

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  dio.interceptors.add(DedupeInterceptor());

  // Reads the logged-in user's APK straight from UserDataTable, same DAO
  // used by userDataProvider (see user_data_dao_provider.dart). Empty
  // during setup (before any login has happened) — that's expected, since
  // /branch/getbranch and /pos/getposconfig don't require it. Any endpoint
  // behind the server's auth middleware DOES require it, so this header
  // must carry a real APK by the time the user reaches those calls.
  final userDataDao = ref.watch(userDataDaoProvider);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? apk;
        try {
          final user = await userDataDao.getUser();
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
            final existing = options.data;
            if (existing is Map) {
              options.data = <String, dynamic>{...existing, 'APK': apk};
            } else if (existing == null) {
              options.data = <String, dynamic>{'APK': apk};
            }
          }
        } else {
          // Expected during setup / initial sync: no user has logged in
          // yet, so there's no APK. Branch and POS config endpoints don't
          // require it, so this placeholder header is harmless for them.
          options.headers['Authorization'] = 'Bearer missing_local_apk';
        }

        // debugPrint('>>> ${options.method} ${options.uri}');
        // debugPrint('>>> baseUrl: ${options.baseUrl}');
        // debugPrint('>>> path: ${options.path}');
        // debugPrint('>>> headers: ${options.headers}');
        // debugPrint('>>> data: ${options.data}');
        return handler.next(options);
      },
      onError: (error, handler) {
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
