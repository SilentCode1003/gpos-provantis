import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/pos_config_dao.dart';

part 'pos_config_dao_provider.g.dart';

@Riverpod(keepAlive: true)
PosConfigDao posConfigDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return PosConfigDao(db);
}