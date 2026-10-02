import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/service_package_dao.dart';

part 'service_package_dao_provider.g.dart';

@Riverpod(keepAlive: true)
ServicePackageDao servicePackageDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return ServicePackageDao(db);
}

final servicePackagesProvider =
    StreamNotifierProvider<
      ServicePackagesNotifier,
      List<ServicePackageTableData>
    >(ServicePackagesNotifier.new);

class ServicePackagesNotifier
    extends StreamNotifier<List<ServicePackageTableData>> {
  @override
  Stream<List<ServicePackageTableData>> build() {
    final dao = ref.watch(servicePackageDaoProvider);
    return dao.watchAllServicePackages();
  }
}
