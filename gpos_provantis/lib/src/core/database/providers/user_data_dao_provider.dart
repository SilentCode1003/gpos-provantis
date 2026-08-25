import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/user_data_dao.dart';

part 'user_data_dao_provider.g.dart';

@Riverpod(keepAlive: true)
UserDataDao userDataDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return UserDataDao(db);
}

final userDataProvider =
    StreamNotifierProvider<UserDataNotifier, UserDataTableData?>(
      UserDataNotifier.new,
    );

class UserDataNotifier extends StreamNotifier<UserDataTableData?> {
  @override
  Stream<UserDataTableData?> build() {
    final dao = ref.watch(userDataDaoProvider);
    return dao.watchUser();
  }
}
