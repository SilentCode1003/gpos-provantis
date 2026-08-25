import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../app_database.dart';
import '../tables/domain_config_table.dart';

part 'domain_config_dao.g.dart';

/// Handles reads/writes for the single-row DomainConfigTable.
///
/// The row's `id` is always the fixed constant 'domain_config' (see the
/// table's default), so every write here is an upsert against that one row
/// — there is only ever one domain configured per device.
@DriftAccessor(tables: [DomainConfigTable])
class DomainConfigDao extends DatabaseAccessor<AppDatabase>
    with _$DomainConfigDaoMixin {
  DomainConfigDao(super.db) {
    // Warm the cache immediately on construction by reading the DB once,
    // in the background. Without this, a fresh app launch (or restart)
    // leaves _cachedDomain at null until something happens to call
    // getDomain() or saveDomain() — and apiClient, being a synchronous
    // builder, can't await a fresh DB read itself. _cacheReady lets
    // callers that CAN await (like apiClient's callers, on first use
    // after launch) wait for this one-time warm-up to finish instead of
    // racing it.
    _cacheReady = _warmCache();
  }

  late final Future<void> _cacheReady;

  /// Completes once the startup cache warm-up has finished. Callers that
  /// can await (e.g. a repository's first call after app launch) should
  /// await this before reading [cachedDomain] if they want to be sure a
  /// previously-saved domain has had a chance to load. Safe to await
  /// repeatedly — it's the same Future every time.
  Future<void> get cacheReady => _cacheReady;

  Future<void> _warmCache() async {
    final domain = await getDomain();
    debugPrint('🔥 DomainConfigDao: cache warmed on startup = "$domain"');
  }

  /// In-memory cache of the last known domain, updated synchronously on
  /// every successful [saveDomain] and lazily on first [getDomain]/
  /// [watchDomain] read (including the automatic startup warm-up above).
  /// Exists because watchDomain()'s stream has been confirmed (via
  /// instrumentation) to sometimes never deliver its first event under
  /// this project's current riverpod 3.x + drift version pairing — see
  /// notes on [cachedDomain] and SetupController.saveSetup. This gives
  /// synchronous callers (like apiClient, which cannot await) a reliable
  /// value without depending on stream delivery.
  ///
  /// NOTE: there is still a brief window right after app launch, before
  /// _warmCache()'s query finishes, where this is null even if a domain
  /// was previously saved. apiClient handles that window by throwing a
  /// clear StateError rather than silently using an inert placeholder —
  /// see api_client.dart. In practice this window is very short (a single
  /// fast local SQLite read), but any UI that calls apiClient during the
  /// very first frame after launch should be aware of it.
  String? _cachedDomain;

  /// Synchronous access to the last known domain. Null until either
  /// saveDomain() has been called once, or getDomain()/watchDomain() has
  /// completed at least one read (including the automatic startup
  /// warm-up). Prefer this over the stream in contexts that can't await
  /// (like apiClient's synchronous @riverpod builder).
  String? get cachedDomain => _cachedDomain;

  /// Saves (inserts or overwrites) the full domain URL, e.g.
  /// 'https://mystore.example.com'.
  Future<void> saveDomain(String fullUrl) async {
    await into(domainConfigTable).insertOnConflictUpdate(
      DomainConfigTableCompanion.insert(domain: Value(fullUrl)),
    );
    _cachedDomain = fullUrl;
  }

  /// One-time read of the currently configured domain, or null if unset.
  Future<String?> getDomain() async {
    final row = await select(domainConfigTable).getSingleOrNull();
    _cachedDomain = row?.domain;
    return row?.domain;
  }

  /// Reactive stream of the configured domain — used by [activeDomainProvider]
  /// so Dio's baseUrl updates automatically once setup saves a new domain.
  ///
  /// NOTE: instrumentation confirmed this stream can subscribe successfully
  /// and never deliver a single event (not even the initial value), under
  /// riverpod 3.2.1 + drift 2.31.0 in this project. Treat this as a
  /// best-effort reactivity signal, not a guaranteed delivery mechanism —
  /// anything that MUST have the current domain synchronously or
  /// immediately after a write should use [cachedDomain] or [getDomain]
  /// instead.
  Stream<String?> watchDomain() {
    return select(domainConfigTable).watch().map((rows) {
      debugPrint('🔬 watchDomain: raw watch() emitted ${rows.length} row(s)');
      final value = rows.isEmpty ? null : rows.first.domain;
      _cachedDomain = value;
      return value;
    });
  }
}
