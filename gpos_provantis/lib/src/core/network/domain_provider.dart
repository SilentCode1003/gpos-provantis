import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/domain_config_dao.dart';

part 'domain_provider.g.dart';

@Riverpod(keepAlive: true)
DomainConfigDao domainConfigDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return DomainConfigDao(db);
}

@Riverpod(keepAlive: true)
Stream<String?> activeDomain(Ref ref) {
  final dao = ref.watch(domainConfigDaoProvider);
  debugPrint(
    '🌊 activeDomain: provider (re)built, subscribing to watchDomain()',
  );
  return dao.watchDomain().map((value) {
    debugPrint('🌊 activeDomain: stream emitted "$value"');
    return value;
  });
}
