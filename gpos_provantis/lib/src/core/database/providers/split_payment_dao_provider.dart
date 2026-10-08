import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/split_payment_dao.dart';

part 'split_payment_dao_provider.g.dart';

@Riverpod(keepAlive: true)
SplitPaymentDao splitPaymentDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return SplitPaymentDao(db);
}
