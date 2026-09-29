import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/sales_dao.dart';

part 'sales_dao_provider.g.dart';

@Riverpod(keepAlive: true)
SalesDao salesDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return SalesDao(db);
}

final salesProvider =
    StreamNotifierProvider<SalesNotifier, List<SalesTableData>>(
      SalesNotifier.new,
    );

class SalesNotifier extends StreamNotifier<List<SalesTableData>> {
  @override
  Stream<List<SalesTableData>> build() {
    final dao = ref.watch(salesDaoProvider);
    return dao.watchAllSales();
  }
}
