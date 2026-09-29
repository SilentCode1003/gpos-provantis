import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/discounts_dao.dart';

part 'discounts_dao_provider.g.dart';

@Riverpod(keepAlive: true)
DiscountsDao discountsDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return DiscountsDao(db);
}

final discountsProvider =
    StreamNotifierProvider<DiscountsNotifier, List<DiscountsTableData>>(
      DiscountsNotifier.new,
    );

class DiscountsNotifier extends StreamNotifier<List<DiscountsTableData>> {
  @override
  Stream<List<DiscountsTableData>> build() {
    final dao = ref.watch(discountsDaoProvider);
    return dao.watchAllDiscounts();
  }
}
