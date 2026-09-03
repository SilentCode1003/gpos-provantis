import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/payments_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/payments_dao_provider.dart';

import '../domain/payments_dto.dart';

part 'payments_repository.g.dart';

@Riverpod(keepAlive: true)
PaymentsRepository paymentsRepository(Ref ref) {
  final dao = ref.watch(paymentsDaoProvider);
  return PaymentsRepository(ref, dao);
}

class PaymentsRepository {
  final Ref _ref;
  final PaymentsDao _dao;

  PaymentsRepository(this._ref, this._dao);

  // Fetch payments from the API and save them to the database.
  Future<void> fetchAndSavePayments() async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post(
      '/payment/getactive',
    );

    final apiResponse = ApiResponseModel<List<PaymentsDto>>.fromDioResponse(
      response,
      fromJson: (data) => (data as List)
          .map((x) => PaymentsDto.fromJson(x as Map<String, dynamic>))
          .toList(),
    );

    final records = apiResponse.responseData;
    if (records == null || records.isEmpty) {
      throw Exception(
        'No payments returned from server: ${apiResponse.responseMessage}',
      );
    }

    // TODO: confirm PaymentsTableCompanion field names match PaymentsDto fields
    final companions = records
        .map(
          (payment) => PaymentsTableCompanion.insert(
            paymentName: Value(payment.paymentName),
          ),
        )
        .toList();

    await _dao.replacePayments(companions);
  }
}
