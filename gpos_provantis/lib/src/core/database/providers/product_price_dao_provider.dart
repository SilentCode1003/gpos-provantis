import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/product_price_dao.dart';

part 'product_price_dao_provider.g.dart';

@Riverpod(keepAlive: true)
ProductPriceDao productPriceDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProductPriceDao(db);
}

final productPriceProvider =
    StreamNotifierProvider<ProductPriceNotifier, List<ProductPriceTableData>>(
      ProductPriceNotifier.new,
    );

class ProductPriceNotifier extends StreamNotifier<List<ProductPriceTableData>> {
  @override
  Stream<List<ProductPriceTableData>> build() {
    final dao = ref.watch(productPriceDaoProvider);
    return dao.watchAllProductPrices();
  }
}
