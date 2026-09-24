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

/// Parses the trailing run of digits off the end of a receipt/detail ID
/// like `PO000001` or `100000035`, increments that number by 1, and
/// re-assembles the string with the same prefix and the same digit
/// count (zero-padded), e.g.:
///   `100000035` -> `100000036`
///   `PO000001`  -> `PO000002`
///   `PO999`     -> `PO1000`      (grows a digit if incrementing rolls
///                                 over the original width — see note
///                                 below)
///
/// Throws [FormatException] if [id] has no trailing digits at all
/// (e.g. `POS` with nothing numeric to increment) — there's no numbering
/// scheme to fall back on in that case, so this refuses to guess one
/// rather than silently invent a value the server was never sent before.
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
  // padLeft only pads UP to `width` — if incrementing rolls the number
  // past what the original width could hold (e.g. 999 -> 1000), this
  // intentionally lets the string grow rather than truncating/wrapping
  // back to 0, since silently wrapping would reuse an ID that's
  // already been used.
  final nextDigits = nextValue.toString().padLeft(width, '0');

  return '$prefix$nextDigits';
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
    if (records == null) {
      throw Exception(
        'No pos shifts returned from server: ${apiResponse.responseMessage}',
      );
    }

    // An empty list is a valid "server has zero shifts" answer — save
    // it as-is (replacePosShifts will just clear the local table) so
    // local data doesn't stay stale when everything's been removed
    // server-side.
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

  // Start Shift
  Future<void> startShift() async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    // POS ID
    final posConfigDao = _ref.read(posConfigDaoProvider);
    final posConfig = await posConfigDao.getPos();

    // FULLNAME
    final userDataDao = _ref.read(userDataDaoProvider);
    final userData = await userDataDao.getUser();

    // DETAIL ID
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

    // `posDetailId.posDetailId` is a string (e.g. "100000035",
    // "PO000001") — the server wants the *next* receipt number, i.e.
    // that value incremented by 1, with whatever non-numeric prefix
    // and zero-padding it already had preserved. See
    // `incrementTrailingNumber`'s doc comment for exactly how that
    // works and what it refuses to guess.
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

  // End Shift
  Future<void> endShift() async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    // POS ID
    final posConfigDao = _ref.read(posConfigDaoProvider);
    final posConfig = await posConfigDao.getPos();

    // DETAIL ID
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
