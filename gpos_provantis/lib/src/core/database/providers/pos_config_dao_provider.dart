import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/pos_config_dao.dart';

part 'pos_config_dao_provider.g.dart';

@Riverpod(keepAlive: true)
PosConfigDao posConfigDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return PosConfigDao(db);
}

final posConfigProvider =
    StreamNotifierProvider<PosConfigNotifier, POSConfigTableData?>(
      PosConfigNotifier.new,
    );

class PosConfigNotifier extends StreamNotifier<POSConfigTableData?> {
  @override
  Stream<POSConfigTableData?> build() {
    final dao = ref.watch(posConfigDaoProvider);
    return dao.watchPos();
  }
}
