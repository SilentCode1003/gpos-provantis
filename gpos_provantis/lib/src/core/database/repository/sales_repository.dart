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

enum SaleUploadOutcome { success, exists, failure }

class SalesRepository {
  final Ref _ref;
  final SalesDao _dao;

  SalesRepository(this._ref, this._dao);

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
      debugPrint(
        'SalesRepository: upload threw for detailId=${sale.detailId}: '
        '$error',
      );
      return SaleUploadOutcome.failure;
    }
  }

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
