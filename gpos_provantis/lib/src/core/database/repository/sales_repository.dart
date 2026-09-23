import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/sales_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/sales_dao_provider.dart';

part 'sales_repository.g.dart';

@Riverpod(keepAlive: true)
SalesRepository salesRepository(Ref ref) {
  final dao = ref.watch(salesDaoProvider);
  return SalesRepository(ref, dao);
}

/// One sale's server-acknowledged outcome, as returned by POST
/// /salesdetails/save's `msg` field.
///
///   success — the server inserted the sale (and its items, discount,
///             cashier activity, e-payment detail, inventory deduction)
///             for the first time.
///   exists  — the server already has a `sales_detail` row with this
///             exact `detailid`. This happens when a prior upload
///             attempt actually succeeded server-side but the app never
///             got to record that locally (e.g. the response was lost
///             to a dropped connection after the server had already
///             committed). Treated the same as success for the purpose
///             of marking the local row synced — the data is safely on
///             the server either way — but kept as a separate value so
///             callers/logs can tell the two apart.
///   failure — anything else: a validation error, a server exception,
///             a network failure, or a response this client couldn't
///             even parse.
enum SaleUploadOutcome { success, exists, failure }

/// Pushes locally-created, not-yet-synced sales to the server, one at a
/// time and strictly in the order they were created — never in
/// parallel and never out of order. Order matters here because the
/// server assigns/validates `detailid` sequencing itself (see the
/// `/salesdetails/save` handler's duplicate check against
/// `sales_detail.st_detail_id`) and because the wider sales-flow spec
/// pulls the server's latest detail ID only *after* every pending sale
/// has been uploaded — uploading out of order would make that
/// post-upload comparison meaningless.
///
/// Stops at the first sale that doesn't come back as `success` or
/// `exists` — later sales in the same run are deliberately left
/// unsynced rather than uploaded ahead of a stuck one, since a gap in
/// the middle of the sequence is exactly the anomaly the detail-ID
/// reconciliation step (see the sales-flow spec) exists to catch. The
/// background sync service just calls this again on its next cycle;
/// there's no separate retry mechanism to build here.
class SalesRepository {
  final Ref _ref;
  final SalesDao _dao;

  SalesRepository(this._ref, this._dao);

  /// Uploads every unsynced sale, oldest first, stopping at the first
  /// failure. Returns the number of sales successfully confirmed
  /// (`success` or `exists`) in this run — 0 if there was nothing to
  /// upload, or if the very first sale failed.
  Future<int> uploadSales() async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final pending = await _dao.getUnsyncedSales();
    debugPrint('SalesRepository: ${pending.length} sale(s) pending upload');
    var confirmedCount = 0;

    for (final sale in pending) {
      final outcome = await _uploadOne(sale);

      if (outcome == SaleUploadOutcome.failure) {
        debugPrint(
          'SalesRepository: upload stopped at detailId=${sale.detailId} '
          '(local id=${sale.id}) — leaving it and everything after it '
          'unsynced for the next sync cycle.',
        );
        break;
      }

      debugPrint(
        'SalesRepository: confirmed detailId=${sale.detailId} '
        '(outcome=$outcome)',
      );
      await _dao.markSynced(sale.id);
      confirmedCount++;
    }

    return confirmedCount;
  }

  /// Uploads exactly one sale and classifies the server's response.
  /// Never throws — a network error, a timeout, or a response this
  /// client can't parse is caught and reported as
  /// [SaleUploadOutcome.failure], the same as an explicit server-side
  /// rejection, so [uploadSales] doesn't need two different failure
  /// paths to handle.
  Future<SaleUploadOutcome> _uploadOne(SalesTableData sale) async {
    final dio = _ref.read(apiClientProvider);

    try {
      final response = await dio.post(
        '/salesdetails/save',
        data: _toRequestBody(sale),
      );

      final apiResponse = ApiResponseModel<dynamic>.fromDioResponse(response);
      final msg = apiResponse.responseMessage;

      switch (msg) {
        case 'success':
          return SaleUploadOutcome.success;
        case 'exist':
          return SaleUploadOutcome.exists;
        default:
          debugPrint(
            'SalesRepository: server rejected detailId=${sale.detailId}: '
            '$msg',
          );
          return SaleUploadOutcome.failure;
      }
    } catch (error) {
      // Covers DioException (network/timeout/non-2xx) and the response
      // body failing to parse as the JSON object ApiResponseModel
      // expects (e.g. a 500 with an HTML error page) — either way, this
      // sale didn't get confirmed, so it's a failure.
      debugPrint(
        'SalesRepository: upload threw for detailId=${sale.detailId}: '
        '$error',
      );
      return SaleUploadOutcome.failure;
    }
  }

  /// Maps one local sale row onto the POST body
  /// `/salesdetails/save` expects. Field names mostly match the local
  /// column names directly, with one deliberate exception: the local
  /// `items` column is sent under the key `description` — that's the
  /// field name the server route destructures
  /// (`const { ..., description, ... } = req.body`), even though it
  /// holds the same items-JSON string `_buildItemsJson` produces
  /// locally. Don't rename this back to `items` without also changing
  /// the server route.
  Map<String, dynamic> _toRequestBody(SalesTableData sale) {
    return {
      'detailid': sale.detailId,
      'date': sale.date,
      'posid': sale.posid,
      'shift': sale.shift,
      'paymenttype': sale.paymentType,
      'referenceid': sale.referenceId,
      'paymentname': sale.paymentName,
      'description': sale.items,
      'total': sale.total,
      'cashier': sale.cashier,
      'cash': sale.cash,
      'ecash': sale.ecash,
      'branch': sale.branch,
      'discountdetail': sale.discountDetail,
    };
  }
}
