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

    // Log every id the server sent, plus any duplicates within THIS
    // response — if a UNIQUE constraint failure follows, this tells you
    // whether the server itself sent the same id twice (a payload bug)
    // as opposed to two separate calls racing each other (a concurrency
    // bug). A non-empty duplicates set here means it's the former.
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
      // If this throws a UNIQUE constraint failure and duplicateIds above
      // was EMPTY, that rules out a duplicated server payload — it means
      // another fetchAndSaveDenominations() call (different callId) is
      // running concurrently and its delete()/insert() interleaved with
      // this one's. Check for a second [Denominations][otherCallId] block
      // overlapping with this one in the log.
      debugPrint('[Denominations][$callId] replaceDenominations() failed: $e');
      rethrow;
    }
    debugPrint('[Denominations][$callId] replaceDenominations() succeeded.');
  }
}
