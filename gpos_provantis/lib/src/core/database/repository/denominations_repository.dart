import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/denominations_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/denominations_dao_provider.dart';

import '../domain/denominations_dto.dart';

part 'denominations_repository.g.dart';

@Riverpod(keepAlive: true)
DenominationsRepository denominationsRepository(Ref ref) {
  final dao = ref.watch(denominationsDaoProvider);
  return DenominationsRepository(ref, dao);
}

class DenominationsRepository {
  final Ref _ref;
  final DenominationsDao _dao;

  DenominationsRepository(this._ref, this._dao);

  Future<void> fetchAndSaveDenominations() async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final callId = DateTime.now().microsecondsSinceEpoch;
    debugPrint('[Denominations][$callId] fetchAndSaveDenominations() started');

    final dio = _ref.read(apiClientProvider);

    late final Response response;
    try {
      response = await dio.post('/denomination/active');
    } on DioException catch (e) {
      debugPrint(
        '[Denominations][$callId] POST /denomination/active failed: '
        '${e.type} — ${e.message}',
      );
      if (e.response != null) {
        debugPrint(
          '[Denominations][$callId] Server responded with status '
          '${e.response?.statusCode}: ${e.response?.data}',
        );
      }
      rethrow;
    }

    debugPrint(
      '[Denominations][$callId] Raw response (status '
      '${response.statusCode}): ${response.data}',
    );

    final apiResponse =
        ApiResponseModel<List<DenominationsDto>>.fromDioResponse(
          response,
          fromJson: (data) => (data as List)
              .map((x) => DenominationsDto.fromJson(x as Map<String, dynamic>))
              .toList(),
        );

    final records = apiResponse.responseData;
    if (records == null || records.isEmpty) {
      debugPrint('[Denominations][$callId] Empty result from server.');
      throw Exception(
        'No denominations returned from server: ${apiResponse.responseMessage}',
      );
    }

    final ids = records.map((d) => d.id).toList();
    final seen = <int>{};
    final duplicateIds = <int>{};
    for (final id in ids) {
      if (!seen.add(id)) duplicateIds.add(id);
    }
    debugPrint(
      '[Denominations][$callId] Parsed ${records.length} records. '
      'ids: $ids',
    );
    if (duplicateIds.isNotEmpty) {
      debugPrint(
        '[Denominations][$callId] *** DUPLICATE ids WITHIN this response: '
        '$duplicateIds — server payload contains the same id more than once.',
      );
    }

    final denominations = records
        .map(
          (denomination) => DenominationsTableCompanion.insert(
            id: Value(denomination.id),
            code: Value(denomination.code),
            description: Value(denomination.description),
            value: Value(denomination.value),
            status: Value(denomination.status),
            createdBy: Value(denomination.createdBy),
            createdDate: Value(denomination.createdDate),
          ),
        )
        .toList();

    debugPrint(
      '[Denominations][$callId] Calling replaceDenominations() with '
      '${denominations.length} rows now.',
    );
    try {
      await _dao.replaceDenominations(denominations);
    } catch (e) {
      debugPrint('[Denominations][$callId] replaceDenominations() failed: $e');
      rethrow;
    }
    debugPrint('[Denominations][$callId] replaceDenominations() succeeded.');
  }
}
