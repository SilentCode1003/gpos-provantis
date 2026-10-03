import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/receipt_history_dao.dart';

part 'receipt_history_dao_provider.g.dart';

@Riverpod(keepAlive: true)
ReceiptHistoryDao receiptHistoryDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return ReceiptHistoryDao(db);
}
