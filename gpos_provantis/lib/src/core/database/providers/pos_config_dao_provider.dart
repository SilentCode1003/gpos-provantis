import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/pos_config_dao.dart';

part 'pos_config_dao_provider.g.dart';

// This one stays code-generated — it's fine, no Drift type involved
@Riverpod(keepAlive: true)
PosConfigDao posConfigDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return PosConfigDao(db);
}

/// Streams the currently configured POS from the local database.
/// Value is null before setup has ever run.
/// Manually written (not @riverpod) to avoid a known riverpod_generator
/// bug resolving Drift-generated types — see rrousselGit/riverpod#4370.
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
