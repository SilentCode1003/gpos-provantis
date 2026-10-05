import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/cash_drop_dao.dart';

part 'cash_drop_dao_provider.g.dart';

@Riverpod(keepAlive: true)
CashDropDao cashDropDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return CashDropDao(db);
}

final cashDropsProvider =
    StreamNotifierProvider<CashDropsNotifier, List<CashDropTableData>>(
      CashDropsNotifier.new,
    );

class CashDropsNotifier extends StreamNotifier<List<CashDropTableData>> {
  @override
  Stream<List<CashDropTableData>> build() {
    final dao = ref.watch(cashDropDaoProvider);
    return dao.watchAllCashDrops();
  }
}
