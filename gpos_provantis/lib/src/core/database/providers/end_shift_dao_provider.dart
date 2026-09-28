import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/end_shift_report_dao.dart';

part 'end_shift_dao_provider.g.dart';

@Riverpod(keepAlive: true)
EndShiftDao endShiftDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return EndShiftDao(db);
}

final endShiftProvider =
    StreamNotifierProvider<EndShiftNotifier, List<EndShiftTableData>>(
      EndShiftNotifier.new,
    );

class EndShiftNotifier extends StreamNotifier<List<EndShiftTableData>> {
  @override
  Stream<List<EndShiftTableData>> build() {
    final dao = ref.watch(endShiftDaoProvider);
    return dao.watchAllEndShift();
  }
}
