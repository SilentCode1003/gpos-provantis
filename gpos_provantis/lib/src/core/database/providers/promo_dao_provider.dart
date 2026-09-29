import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/promo_dao.dart';

part 'promo_dao_provider.g.dart';

@Riverpod(keepAlive: true)
PromoDao promoDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return PromoDao(db);
}

final promoProvider =
    StreamNotifierProvider<PromoNotifier, List<PromoTableData>>(
      PromoNotifier.new,
    );

class PromoNotifier extends StreamNotifier<List<PromoTableData>> {
  @override
  Stream<List<PromoTableData>> build() {
    final dao = ref.watch(promoDaoProvider);
    return dao.watchAllPromos();
  }
}
