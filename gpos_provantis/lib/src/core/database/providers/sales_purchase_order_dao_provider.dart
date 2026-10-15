import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/sales_purchase_order_dao.dart';

part 'sales_purchase_order_dao_provider.g.dart';

@Riverpod(keepAlive: true)
SalesPurchaseOrderDao salesPurchaseOrderDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return SalesPurchaseOrderDao(db);
}
