import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/pos_config_dao.dart';
import 'package:gpos_provantis/src/core/database/daos/receipt_history_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_config_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/receipt_history_dao_provider.dart';

import '../domain/receipt_history_dto.dart';

part 'receipt_history_repository.g.dart';

@Riverpod(keepAlive: true)
ReceiptHistoryRepository receiptHistoryRepository(Ref ref) {
  return ReceiptHistoryRepository(
    ref,
    ref.watch(posConfigDaoProvider),
    ref.watch(receiptHistoryDaoProvider),
  );
}

class ReceiptHistoryRepository {
  final Ref _ref;
  final PosConfigDao _posConfigDao;
  final ReceiptHistoryDao _dao;

  ReceiptHistoryRepository(this._ref, this._posConfigDao, this._dao);

  /// How long a pulled receipt stays on the device after it was fetched.
  static const cacheRetention = Duration(days: 7);

  /// Pulls the receipts for [dateFrom]..[dateTo] (`yyyy-MM-dd`) from the
  /// server, replaces the local copy of that range, prunes anything older than
  /// [cacheRetention], and returns the saved rows, newest first.
  ///
  /// The server sends one row per payment, so split sales are merged back into
  /// a single receipt here. An empty range is valid and clears it locally.
  /// Network failures ([DioException]) propagate so the caller can fall back to
  /// [getLocalReceipts].
  Future<List<ReceiptHistoryTableData>> fetchAndSaveReceipts({
    required String dateFrom,
    required String dateTo,
  }) async {
    final posId = await _posId();

    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post(
      '/salesdetails/getreceipts',
      data: {'datefrom': dateFrom, 'dateto': dateTo, 'posid': posId},
    );

    final apiResponse =
        ApiResponseModel<List<ReceiptHistoryDto>>.fromDioResponse(
          response,
          fromJson: (data) => (data as List)
              .map((x) => ReceiptHistoryDto.fromJson(x as Map<String, dynamic>))
              .toList(),
        );

    final receipts = ReceiptHistoryDto.groupRows(
      apiResponse.responseData ?? const <ReceiptHistoryDto>[],
    );

    final fetchedAt = DateTime.now();

    await _dao.replaceForRange(
      dateFrom: dateFrom,
      dateTo: dateTo,
      posId: posId,
      rows: [
        for (final r in receipts)
          ReceiptHistoryTableCompanion.insert(
            detailId: r.detailId,
            posId: posId,
            receiptDate: r.receiptDate.isEmpty ? dateFrom : r.receiptDate,
            createdAt: r.dateTime,
            shift: Value(r.shift),
            paymentType: Value(r.paymentType),
            description: Value(r.description),
            total: Value(r.total),
            cashier: Value(r.cashier),
            status: Value(r.status),
            ePaymentType: Value(r.ePaymentType),
            referenceId: Value(r.referenceId),
            tendersJson: Value(r.tendersJson),
            fetchedAt: Value(fetchedAt),
          ),
      ],
    );

    await _purgeExpired();

    return _dao.getForRange(dateFrom: dateFrom, dateTo: dateTo, posId: posId);
  }

  /// Locally cached receipts for the range. No network call.
  Future<List<ReceiptHistoryTableData>> getLocalReceipts({
    required String dateFrom,
    required String dateTo,
  }) async {
    final posId = await _posId();
    return _dao.getForRange(dateFrom: dateFrom, dateTo: dateTo, posId: posId);
  }

  /// Housekeeping must never make a good fetch look like a failure.
  Future<void> _purgeExpired() async {
    try {
      final removed = await _dao.deleteFetchedBefore(
        DateTime.now().subtract(cacheRetention),
      );
      if (removed > 0) debugPrint('Receipts: pruned $removed expired copies.');
    } catch (e) {
      debugPrint('Receipts: prune failed: $e');
    }
  }

  /// The POS id comes from the saved POS config.
  Future<int> _posId() async {
    final pos = await _posConfigDao.getPos();
    if (pos == null) {
      throw StateError('No POS config saved on this device.');
    }
    return pos.posId;
  }
}
