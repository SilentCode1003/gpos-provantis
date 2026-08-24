import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/domain_config_dao.dart';

part 'domain_provider.g.dart';

/// DAO provider for DomainConfigTable, used both by the setup flow (to
/// write the domain) and by [activeDomainProvider] (to read it).
@Riverpod(keepAlive: true)
DomainConfigDao domainConfigDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return DomainConfigDao(db);
}

/// Streams the currently configured domain (e.g. 'https://mystore.com')
/// from the local database. `apiClient` watches this to build its baseUrl,
/// so as soon as setup saves a new domain, any Dio calls made afterward
/// automatically pick it up — no manual provider invalidation needed.
///
/// Value is null before setup has ever run.
@Riverpod(keepAlive: true)
Stream<String?> activeDomain(Ref ref) {
  final dao = ref.watch(domainConfigDaoProvider);
  return dao.watchDomain();
}
