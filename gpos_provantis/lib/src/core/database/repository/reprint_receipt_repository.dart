import 'dart:convert';

import 'package:riverpod/riverpod.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/printutil/receipt_generator.dart'
    show ReceiptSaleData, ReceiptLineItem;

import '../domain/reprint_receipt_dto.dart';

/// Manual provider (no build_runner pass needed).
final reprintReceiptRepositoryProvider = Provider<ReprintReceiptRepository>(
  (ref) => ReprintReceiptRepository(ref),
);

/// Fetches a receipt straight from the server for reprinting. Nothing is
/// saved to the local DB.
class ReprintReceiptRepository {
  final Ref _ref;
  ReprintReceiptRepository(this._ref);

  /// Returns the receipt for [detailId], or null when the server has no such
  /// OR number. Network failures ([DioException]) propagate so the caller can
  /// show a "could not reach the server" message.
  Future<ReceiptSaleData?> fetchReceipt(
    String detailId, {
    String branchId = '',
  }) async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post(
      '/salesdetails/getdetails',
      data: {'detailid': detailId},
    );

    final apiResponse =
        ApiResponseModel<List<ReprintReceiptDto>>.fromDioResponse(
          response,
          fromJson: (data) => (data as List)
              .map((x) => ReprintReceiptDto.fromJson(x as Map<String, dynamic>))
              .toList(),
        );

    final rows = apiResponse.responseData ?? const <ReprintReceiptDto>[];
    if (rows.isEmpty) return null;

    return receiptSaleDataFromServerRows(rows, branchId: branchId);
  }
}

const _discountLineNamePrefix = 'Discount (';

/// Builds the printable receipt from the server rows of ONE receipt.
ReceiptSaleData receiptSaleDataFromServerRows(
  List<ReprintReceiptDto> rows, {
  String branchId = '',
}) {
  final head = rows.first;

  // Line items + discount, same rules as the local mappers.
  String? discountLabel;
  double discountAmount = 0;
  final lineItems = <ReceiptLineItem>[];
  for (final raw in _decodeItems(head.orDescription)) {
    final name = raw['name'] as String? ?? '';
    final price = (raw['price'] as num?)?.toDouble() ?? 0;
    if (name.startsWith(_discountLineNamePrefix) && price < 0) {
      discountLabel = name;
      discountAmount = -price;
      continue;
    }
    lineItems.add(
      ReceiptLineItem(
        name: name,
        quantity: (raw['quantity'] as num?)?.toInt() ?? 1,
        price: price,
      ),
    );
  }

  // Payments: cash rows add to cash; non-cash rows are e-payments. The first
  // e-payment is the main one, a second one fills the `second...` fields.
  double cash = 0;
  double ecash = 0;
  String paymentName = head.paymentMethod;
  String referenceId = '';
  String secondName = '';
  String secondRef = '';
  double secondAmount = 0;
  var ePayments = 0;

  for (final r in rows) {
    if (r.isCash) {
      cash += r.amount;
    } else if (ePayments == 0) {
      ecash = r.amount;
      paymentName = r.paymentMethod;
      referenceId = r.referenceId;
      ePayments++;
    } else {
      secondAmount = r.amount;
      secondName = r.paymentMethod;
      secondRef = r.referenceId;
      ePayments++;
    }
  }

  return ReceiptSaleData(
    detailId: head.orNumber,
    posId: head.posId,
    shift: head.shift,
    cashier: head.cashier,
    branchId: branchId,
    dateTime: DateTime.tryParse(head.orDate) ?? DateTime.now(),
    items: lineItems,
    subtotal: head.total + discountAmount,
    discountLabel: discountLabel,
    discountAmount: discountAmount,
    total: head.total,
    paymentType: head.orPaymentType,
    cash: cash,
    ecash: ecash,
    referenceId: referenceId,
    paymentName: paymentName,
    secondPaymentName: secondName,
    secondReferenceId: secondRef,
    secondAmount: secondAmount,
    isReprint: true,
  );
}

List<Map<String, dynamic>> _decodeItems(String raw) {
  if (raw.isEmpty || raw == 'UNREGISTERED') return const [];
  try {
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      return decoded.whereType<Map<String, dynamic>>().toList();
    }
  } catch (_) {}
  return const [];
}
