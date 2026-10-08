import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/login_credentials_dao.dart';

part 'login_credentials_dao_provider.g.dart';

@Riverpod(keepAlive: true)
LoginCredentialsDao loginCredentialsDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return LoginCredentialsDao(db);
}