import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/pos_detail_id_dao.dart';

part 'pos_detail_id_dao_provider.g.dart';

@Riverpod(keepAlive: true)
PosDetailIdDao posDetailIdDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return PosDetailIdDao(db);
}

final posDetailIdProvider =
    StreamNotifierProvider<PosDetailIdNotifier, PosDetailIdTableData?>(
      PosDetailIdNotifier.new,
    );

class PosDetailIdNotifier extends StreamNotifier<PosDetailIdTableData?> {
  @override
  Stream<PosDetailIdTableData?> build() {
    final dao = ref.watch(posDetailIdDaoProvider);
    return dao.watchPosDetailId();
  }
}
