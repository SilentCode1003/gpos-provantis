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
import 'package:gpos_provantis/src/core/database/providers/user_data_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_detail_id_dao_provider.dart';

import '../domain/pos_shift_dto.dart';

part 'pos_shift_repository.g.dart';

@Riverpod(keepAlive: true)
PosShiftRepository posShiftRepository(Ref ref) {
  final dao = ref.watch(posShiftDaoProvider);
  return PosShiftRepository(ref, dao);
}

String incrementTrailingNumber(String id) {
  final match = RegExp(r'^(.*?)(\d+)$').firstMatch(id);
  if (match == null) {
    throw FormatException(
      'Cannot increment "$id" — it has no trailing digits to increment.',
    );
  }

  final prefix = match.group(1)!;
  final digits = match.group(2)!;
  final width = digits.length;

  final nextValue = int.parse(digits) + 1;

  final nextDigits = nextValue.toString().padLeft(width, '0');

  return '$prefix$nextDigits';
}

class PosShiftRepository {
  final Ref _ref;
  final PosShiftDao _dao;

  PosShiftRepository(this._ref, this._dao);

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

    final apiResponse = ApiResponseModel<List<PosShiftDto>>.fromDioResponse(
      response,
      fromJson: (data) => (data as List)
          .map((x) => PosShiftDto.fromJson(x as Map<String, dynamic>))
          .toList(),
    );

    final records = apiResponse.responseData;
    if (records == null) {
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

  Future<void> startShift() async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);

    final posConfigDao = _ref.read(posConfigDaoProvider);
    final posConfig = await posConfigDao.getPos();

    final userDataDao = _ref.read(userDataDaoProvider);
    final userData = await userDataDao.getUser();

    final posDetailIdDao = _ref.read(posDetailIdDaoProvider);
    final posDetailId = await posDetailIdDao.getPosDetailId();

    if (posConfig == null) {
      throw Exception('No pos config found — cannot resolve posId');
    }
    if (userData == null) {
      throw Exception('No user data found — cannot resolve fullname');
    }
    if (posDetailId == null) {
      throw Exception(
        'No pos detail id found — cannot resolve receipt beginning',
      );
    }

    final receiptBeginning = incrementTrailingNumber(posDetailId.posDetailId);

    final response = await dio.post(
      '/posshiftlog/startshift',
      data: {
        'posid': posConfig.posId,
        'cashier': userData.fullName,
        'receiptbeginning': receiptBeginning,
      },
    );

    debugPrint('Response for Start Shift: $response');

    if (response.statusCode != 200) {
      throw Exception('Failed to start shift: ${response.statusCode}');
    }
  }

  Future<void> endShift() async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);

    final posConfigDao = _ref.read(posConfigDaoProvider);
    final posConfig = await posConfigDao.getPos();

    final posDetailIdDao = _ref.read(posDetailIdDaoProvider);
    final posDetailId = await posDetailIdDao.getPosDetailId();

    if (posConfig == null) {
      throw Exception('No pos config found — cannot resolve posId');
    }

    if (posDetailId == null) {
      throw Exception(
        'No pos detail id found — cannot resolve receipt beginning',
      );
    }

    final response = await dio.post(
      '/posshiftlog/endshift',
      data: {
        'posid': posConfig.posId,
        'receiptending': posDetailId.posDetailId,
      },
    );

    debugPrint('Response for End Shift: $response');

    if (response.statusCode != 200) {
      throw Exception('Failed to end shift: ${response.statusCode}');
    }
  }
}
