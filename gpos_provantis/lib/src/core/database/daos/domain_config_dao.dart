import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../app_database.dart';
import '../tables/domain_config_table.dart';

part 'domain_config_dao.g.dart';

@DriftAccessor(tables: [DomainConfigTable])
class DomainConfigDao extends DatabaseAccessor<AppDatabase>
    with _$DomainConfigDaoMixin {
  DomainConfigDao(super.db) {
    _cacheReady = _warmCache();
  }

  late final Future<void> _cacheReady;

  Future<void> get cacheReady => _cacheReady;

  Future<void> _warmCache() async {
    final domain = await getDomain();
    debugPrint('🔥 DomainConfigDao: cache warmed on startup = "$domain"');
  }

  String? _cachedDomain;

  String? get cachedDomain => _cachedDomain;

  Future<void> saveDomain(String fullUrl) async {
    await into(domainConfigTable).insertOnConflictUpdate(
      DomainConfigTableCompanion.insert(domain: Value(fullUrl)),
    );
    _cachedDomain = fullUrl;
  }

  Future<String?> getDomain() async {
    final row = await select(domainConfigTable).getSingleOrNull();
    _cachedDomain = row?.domain;
    return row?.domain;
  }

  Stream<String?> watchDomain() {
    return select(domainConfigTable).watch().map((rows) {
      debugPrint('🔬 watchDomain: raw watch() emitted ${rows.length} row(s)');
      final value = rows.isEmpty ? null : rows.first.domain;
      _cachedDomain = value;
      return value;
    });
  }
}
