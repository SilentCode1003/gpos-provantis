import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/domain_config_dao.dart';

part 'domain_config_dao_provider.g.dart';

@Riverpod(keepAlive: true)
DomainConfigDao domainConfigDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return DomainConfigDao(db);
}

@Riverpod(keepAlive: true)
Stream<String?> activeDomain(Ref ref) {
  final dao = ref.watch(domainConfigDaoProvider);
  return dao.watchDomain();
}
