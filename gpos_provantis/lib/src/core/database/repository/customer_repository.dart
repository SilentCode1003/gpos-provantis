import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/customer_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/customer_dao_provider.dart';

import '../domain/customer_dto.dart';

part 'customer_repository.g.dart';

@Riverpod(keepAlive: true)
CustomerRepository customerRepository(Ref ref) {
  final dao = ref.watch(customerDaoProvider);
  return CustomerRepository(ref, dao);
}

class CustomerRepository {
  CustomerRepository(this._ref, this._dao);

  final Ref _ref;
  final CustomerDao _dao;

  /// True while [syncPending] is running, so overlapping calls can't send the
  /// same customer twice.
  bool _syncing = false;

  /// Saves the customer on this device and returns the stored row. A customer
  /// already saved for the same sale is replaced.
  Future<CustomerTableData> saveCustomer(CustomerDto customer) async {
    await _dao.upsertForSale(customer.toCompanion());
    final saved = await _dao.getBySalesId(customer.salesId);
    if (saved == null) {
      throw StateError('Customer was not found after saving.');
    }
    return saved;
  }

  Future<CustomerTableData?> getCustomer(String id) => _dao.getById(id);

  Future<CustomerTableData?> getCustomerForSale(String salesId) =>
      _dao.getBySalesId(salesId);

  Future<List<CustomerTableData>> getLocalCustomers() => _dao.getAllCustomers();

  Future<List<CustomerTableData>> getPendingCustomers() => _dao.getPending();

  /// Posts one customer to `/mobile-api/customer-transaction`. Returns
  /// normally only if the server answered `msg: success`; anything else
  /// throws, so the caller keeps it PENDING. Network failures
  /// ([DioException]) propagate as well.
  Future<void> submitCustomer(CustomerTableData row) async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post(
      '/mobile-api/customer-transaction',
      data: CustomerDto.fromTableData(row).toApiJson(),
    );

    final body = response.data;
    final msg = body is Map ? body['msg']?.toString() : null;
    if (msg != 'success') {
      throw Exception(
        'Server did not accept the customer'
        '${msg == null ? '.' : ': $msg'}',
      );
    }
  }

  /// Sends every PENDING customer and marks the accepted ones SYNCED. One that
  /// fails stays PENDING with its error recorded, and the rest still go out.
  /// A SYNCED customer is never sent again. Returns how many were sent.
  Future<int> syncPending() async {
    if (_syncing) return 0;
    _syncing = true;

    try {
      var synced = 0;
      for (final row in await _dao.getPending()) {
        try {
          await submitCustomer(row);
          await _dao.markSynced(row.id, DateTime.now());
          synced++;
        } catch (e) {
          debugPrint('Customer: could not send ${row.salesId}: $e');
          await _dao.markAttemptFailed(row.id, _describe(e));
        }
      }
      return synced;
    } finally {
      _syncing = false;
    }
  }

  String _describe(Object e) {
    if (e is DioException) return 'Network error: ${e.type.name}';
    return e.toString().replaceFirst('Exception: ', '');
  }
}
