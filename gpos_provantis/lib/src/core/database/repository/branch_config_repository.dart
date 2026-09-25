import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/branch_config_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/branch_config_dao_provider.dart';

import '../domain/branch_config_dto.dart';

part 'branch_config_repository.g.dart';

@Riverpod(keepAlive: true)
BranchRepository branchRepository(Ref ref) {
  final dao = ref.watch(branchConfigDaoProvider);
  return BranchRepository(ref, dao);
}

class BranchRepository {
  final Ref _ref;
  final BranchConfigDao _dao;

  BranchRepository(this._ref, this._dao);

  Future<void> fetchAndSaveBranch(String branchId) async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post(
      '/branch/getbranch',
      data: {'branchid': branchId},
    );

    final apiResponse = ApiResponseModel<List<BranchConfigDto>>.fromDioResponse(
      response,
      fromJson: (data) => (data as List)
          .map((x) => BranchConfigDto.fromJson(x as Map<String, dynamic>))
          .toList(),
    );

    final records = apiResponse.responseData;
    if (records == null || records.isEmpty) {
      throw Exception('No branch config returned for branchId "$branchId".');
    }

    final branch = records.first;
    await _dao.saveBranch(
      BranchConfigTableCompanion.insert(
        branchId: Value(branch.branchId),
        branchName: Value(branch.branchName),
        tin: Value(branch.tin),
        address: Value(branch.address),
        logo: Value(branch.logo),
        status: Value(branch.status),
        createdBy: Value(branch.createdBy),
        createdDate: Value(branch.createdDate),
      ),
    );
  }
}
