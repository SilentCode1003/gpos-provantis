import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/service_package_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/service_package_dao_provider.dart';

import '../domain/service_package_dto.dart';

part 'service_package_repository.g.dart';

@Riverpod(keepAlive: true)
ServicePackageRepository servicePackageRepository(Ref ref) {
  final dao = ref.watch(servicePackageDaoProvider);
  return ServicePackageRepository(ref, dao);
}

class ServicePackageRepository {
  final Ref _ref;
  final ServicePackageDao _dao;

  ServicePackageRepository(this._ref, this._dao);

  /// Fetches the active service packages from the server, replaces the local
  /// list and returns the saved rows.
  ///
  /// An empty list is valid (no active packages) and clears the local copy, so
  /// a deactivated package can't stay sellable. Network failures
  /// ([DioException]) propagate; use [getLocalServicePackages] for the offline
  /// fallback.
  Future<List<ServicePackageTableData>> fetchAndSaveServicePackages() async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post(
      '/servicepackage/getactive',
      data: {'status': 'ACTIVE'},
    );

    final apiResponse =
        ApiResponseModel<List<ServicePackageDto>>.fromDioResponse(
          response,
          fromJson: (data) => (data as List)
              .map((x) => ServicePackageDto.fromJson(x as Map<String, dynamic>))
              .toList(),
        );

    final records = apiResponse.responseData ?? const <ServicePackageDto>[];

    await _dao.replaceServicePackages([
      for (final r in records)
        ServicePackageTableCompanion.insert(
          id: Value(r.id),
          name: Value(r.name),
          price: Value(r.price),
          quantity: Value(r.quantity),
        ),
    ]);

    return _dao.getAllServicePackages();
  }

  /// Locally stored service packages. No network call.
  Future<List<ServicePackageTableData>> getLocalServicePackages() {
    return _dao.getAllServicePackages();
  }
}
