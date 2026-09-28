import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/sold_items_dao.dart';

part 'sold_items_dao_provider.g.dart';

@Riverpod(keepAlive: true)
SoldItemsDao soldItemsDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return SoldItemsDao(db);
}
