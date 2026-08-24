import 'package:drift/drift.dart';
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
  DomainConfigDao(super.db);

  /// Saves (inserts or overwrites) the full domain URL, e.g.
  /// 'https://mystore.example.com'.
  Future<void> saveDomain(String fullUrl) {
    return into(domainConfigTable).insertOnConflictUpdate(
      DomainConfigTableCompanion.insert(domain: Value(fullUrl)),
    );
  }

  /// One-time read of the currently configured domain, or null if unset.
  Future<String?> getDomain() async {
    final row = await select(domainConfigTable).getSingleOrNull();
    return row?.domain;
  }

  /// Reactive stream of the configured domain — used by [activeDomainProvider]
  /// so Dio's baseUrl updates automatically once setup saves a new domain.
  Stream<String?> watchDomain() {
    return select(
      domainConfigTable,
    ).watchSingleOrNull().map((row) => row?.domain);
  }
}
