// lib/core/network/dedupe_interceptor.dart
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';

/// Key used in [RequestOptions.extra] to opt a specific call into dedupe
/// blocking. Dedupe is now OFF by default for every request — it only
/// applies when a call explicitly asks for it, e.g.:
///
/// ```dart
/// _dio.post(
///   '/mobile-api/addrequstot',
///   data: {...},
///   options: Options(extra: {dedupeBlockKey: true}),
/// );
/// ```
///
/// Why opt-in instead of opt-out: this interceptor used to dedupe *every*
/// POST/PUT/PATCH globally, which silently swallowed legitimate repeat
/// calls (polling, refresh-on-rebuild, "get latest status" type endpoints)
/// any time the method+path+body happened to match a call still in
/// flight. Flipping to opt-in means only calls that actually need
/// duplicate-submission protection (form submits, "create/update/cancel"
/// actions users might double-tap) pay that cost.
const String dedupeBlockKey = 'blockAggressive';

/// Safety-valve: if for any reason onResponse/onError never fires for a
/// request (e.g. it's cancelled upstream some other way, or a bug), the
/// in-flight entry would leak forever and permanently block that
/// fingerprint. This TTL guarantees it eventually clears itself.
const Duration _dedupeTtl = Duration(seconds: 30);

/// Blocks duplicate in-flight requests (same method + path + body) from
/// ever reaching the network, but ONLY for requests that explicitly opt in
/// via `Options(extra: {dedupeBlockKey: true})`. This protects against
/// double-taps, race conditions in UI-level submit guards, retry storms,
/// etc. on the specific calls that ask for it — without risking legitimate
/// concurrent/repeat calls elsewhere in the app getting silently dropped.
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
    // Opt-in only. If the call didn't ask to be deduped, let it through
    // untouched — this is the fix for important calls like
    // fetchNextClockAction / _fetchData getting blocked.
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

    // Belt-and-suspenders auto-expiry in case onResponse/onError is
    // skipped for some reason.
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
