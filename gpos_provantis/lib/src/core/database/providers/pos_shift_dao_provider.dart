import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/pos_shift_dao.dart';

part 'pos_shift_dao_provider.g.dart';

@Riverpod(keepAlive: true)
PosShiftDao posShiftDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return PosShiftDao(db);
}

final posShiftProvider =
    StreamNotifierProvider<PosShiftNotifier, List<PosShiftTableData>>(
      PosShiftNotifier.new,
    );

class PosShiftNotifier extends StreamNotifier<List<PosShiftTableData>> {
  @override
  Stream<List<PosShiftTableData>> build() {
    final dao = ref.watch(posShiftDaoProvider);
    return dao.watchAllPosShifts();
  }
}
