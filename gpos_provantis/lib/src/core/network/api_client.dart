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
          } else {
            final existing = options.data;
            if (existing is Map) {
              options.data = <String, dynamic>{...existing, 'APK': apk};
            } else if (existing == null) {
              options.data = <String, dynamic>{'APK': apk};
            }
          }
        } else {
          options.headers['Authorization'] = 'Bearer missing_local_apk';
        }

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
