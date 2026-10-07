import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/customer_dao.dart';

part 'customer_dao_provider.g.dart';

@Riverpod(keepAlive: true)
CustomerDao customerDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return CustomerDao(db);
}