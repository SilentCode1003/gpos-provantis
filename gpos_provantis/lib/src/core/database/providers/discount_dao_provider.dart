import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/discount_dao.dart';

part 'discount_dao_provider.g.dart';

@Riverpod(keepAlive: true)
DiscountDao discountDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return DiscountDao(db);
}

final discountProvider =
    StreamNotifierProvider<DiscountNotifier, List<DiscountTableData>>(
      DiscountNotifier.new,
    );

class DiscountNotifier extends StreamNotifier<List<DiscountTableData>> {
  @override
  Stream<List<DiscountTableData>> build() {
    final dao = ref.watch(discountDaoProvider);
    return dao.watchAllDiscounts();
  }
}
