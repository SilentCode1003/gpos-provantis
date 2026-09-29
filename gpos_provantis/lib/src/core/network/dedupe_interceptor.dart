import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';

const String dedupeBlockKey = 'blockAggressive';

const Duration _dedupeTtl = Duration(seconds: 30);

class DedupeInterceptor extends Interceptor {
  final _inFlight = <String, Timer>{};

  String _fingerprint(RequestOptions options) {
    final bodyPart = options.data is FormData
        ? 'formdata:${options.data.hashCode}' // FormData can't be JSON-encoded reliably
        : jsonEncode(options.data);
    final raw = '${options.method}:${options.path}:$bodyPart';
    return sha256.convert(utf8.encode(raw)).toString();
  }

  void _clear(String? key) {
    if (key == null) return;
    _inFlight.remove(key)?.cancel();
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final wantsDedupe = options.extra[dedupeBlockKey] == true;
    if (!wantsDedupe) {
      return handler.next(options);
    }

    final key = _fingerprint(options);
    options.extra['dedupeKey'] =
        key; // stash so onResponse/onError can clean up

    if (_inFlight.containsKey(key)) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
          error: 'duplicate_request_blocked',
          message: 'An identical request is already in flight.',
        ),
      );
    }

    _inFlight[key] = Timer(_dedupeTtl, () => _inFlight.remove(key));
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _clear(response.requestOptions.extra['dedupeKey'] as String?);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _clear(err.requestOptions.extra['dedupeKey'] as String?);
    handler.next(err);
  }
}
