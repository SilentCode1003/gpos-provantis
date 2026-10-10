import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/email_dao.dart';

part 'email_dao_provider.g.dart';

@Riverpod(keepAlive: true)
EmailDao emailDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return EmailDao(db);
}

final emailProvider = StreamNotifierProvider<EmailNotifier, EmailTableData?>(
  EmailNotifier.new,
);

class EmailNotifier extends StreamNotifier<EmailTableData?> {
  @override
  Stream<EmailTableData?> build() {
    final dao = ref.watch(emailDaoProvider);
    return dao.watchEmail();
  }
}
