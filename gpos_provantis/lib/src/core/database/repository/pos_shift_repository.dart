import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_config_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/pos_shift_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_shift_dao_provider.dart';

import '../domain/pos_shift_dto.dart';

part 'pos_shift_repository.g.dart';

@Riverpod(keepAlive: true)
PosShiftRepository posShiftRepository(Ref ref) {
  final dao = ref.watch(posShiftDaoProvider);
  return PosShiftRepository(ref, dao);
}

class PosShiftRepository {
  final Ref _ref;
  final PosShiftDao _dao;

  PosShiftRepository(this._ref, this._dao);

  // Fetch pos shifts from the API and save them to the database.
  Future<void> fetchAndSavePosShifts() async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final posConfigDao = _ref.read(posConfigDaoProvider);
    final posConfig = await posConfigDao.getPos();

    if (posConfig == null) {
      throw Exception('No pos config found — cannot resolve posId');
    }
    final response = await dio.post(
      '/posshiftlog/getposshift',
      data: {'posid': posConfig.posId},
    );

    // debugPrint('PosShifts: $response');

    final apiResponse = ApiResponseModel<List<PosShiftDto>>.fromDioResponse(
      response,
      fromJson: (data) => (data as List)
          .map((x) => PosShiftDto.fromJson(x as Map<String, dynamic>))
          .toList(),
    );

    final records = apiResponse.responseData;
    if (records == null || records.isEmpty) {
      throw Exception(
        'No pos shifts returned from server: ${apiResponse.responseMessage}',
      );
    }

    final companions = records
        .map(
          (shift) => PosShiftTableCompanion.insert(
            posId: Value(shift.posId),
            date: Value(shift.date),
            shift: Value(shift.shift),
            status: Value(shift.status),
          ),
        )
        .toList();

    await _dao.replacePosShifts(companions);
  }
}
