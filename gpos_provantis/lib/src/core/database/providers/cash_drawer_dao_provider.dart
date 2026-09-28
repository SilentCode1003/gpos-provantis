import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/cash_drawer_dao.dart';

part 'cash_drawer_dao_provider.g.dart';

@Riverpod(keepAlive: true)
CashDrawerDao cashDrawerDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return CashDrawerDao(db);
}
