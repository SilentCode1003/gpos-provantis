import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/user_data_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/user_data_dao_provider.dart';

import '../domain/user_data_dto.dart';

part 'login_repository.g.dart';

@Riverpod(keepAlive: true)
UserDataRepository userDataRepository(Ref ref) {
  final dao = ref.watch(userDataDaoProvider);
  return UserDataRepository(ref, dao);
}

class UserDataRepository {
  final Ref _ref;
  final UserDataDao _dao;

  UserDataRepository(this._ref, this._dao);

  /// Calls POST /branch/getbranch with the given branchId, and saves the
  /// first matching record to BranchConfigTable. Throws on network/parse
  /// failure — callers (InitialSyncService) decide how to surface that.
  Future<void> fetchAndSaveUser(String username, String password) async {
    // Wait for DomainConfigDao's startup cache warm-up to finish before
    // touching apiClient. This matters specifically right after an app
    // restart: the in-memory domain cache starts empty and is repopulated
    // from the DB in the background as soon as the DAO is constructed —
    // this closes that brief window instead of racing it. On any call
    // after the very first one, cacheReady is already complete and this
    // returns instantly.
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post(
      '/poslogin',
      data: {'username': username, 'password': password},
    );

    debugPrint('API Response: ${response.data}');

    final apiResponse = ApiResponseModel<List<UserDataDto>>.fromDioResponse(
      response,
      fromJson: (data) => (data as List)
          .map((x) => UserDataDto.fromJson(x as Map<String, dynamic>))
          .toList(),
    );

    final records = apiResponse.responseData;
    if (records == null || records.isEmpty) {
      throw Exception('No user data returned for user "$username".');
    }

    final user = records.first;
    await _dao.saveUser(
      UserDataTableCompanion.insert(
        employeeId: Value(user.employeeId),
        fullName: Value(user.fullName),
        position: Value(user.position),
        contactInfo: Value(user.contactInfo),
        dateHired: Value(user.dateHired),
        userCode: Value(user.userCode),
        accessType: Value(user.accessType),
        status: Value(user.status),
        apk: Value(user.apk),
      ),
    );
  }
}
