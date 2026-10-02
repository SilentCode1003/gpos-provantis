import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';

part 'refund_repository.g.dart';

/// What the server said about a refund request.
enum RefundStatus { success, alreadyRefunded, receiptNotFound, failed }

class RefundOutcome {
  const RefundOutcome(this.status, this.message);

  const RefundOutcome.failed(String message)
    : this(RefundStatus.failed, message);

  final RefundStatus status;

  /// Ready to show to the cashier.
  final String message;

  bool get isSuccess => status == RefundStatus.success;
}

@Riverpod(keepAlive: true)
RefundRepository refundRepository(Ref ref) {
  return RefundRepository(ref);
}

class RefundRepository {
  RefundRepository(this._ref);

  final Ref _ref;

  /// Path of the refund route. Adjust if the router is mounted under a prefix.
  static const _path = '/salesdetails/refund';

  /// Refunds the sale with [detailId]. The server answers with a plain `msg`:
  /// `success`, `refunded` (already refunded), `ornotexist` (no such receipt),
  /// or an error. Network failures ([DioException]) propagate.
  Future<RefundOutcome> refundSale({
    required String detailId,
    required String reason,
    required String cashier,
  }) async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post(
      _path,
      data: {'detailid': detailId, 'reason': reason, 'cashier': cashier},
    );

    // This endpoint returns only {msg}, with no `data`, so the body is read
    // directly rather than through the list-based response model.
    final body = response.data;
    final msg = body is Map ? body['msg'] : null;

    switch (msg?.toString()) {
      case 'success':
        return RefundOutcome(
          RefundStatus.success,
          'Receipt $detailId was refunded and its items returned to stock.',
        );
      case 'refunded':
        return RefundOutcome(
          RefundStatus.alreadyRefunded,
          'Receipt $detailId has already been refunded.',
        );
      case 'ornotexist':
        return RefundOutcome(
          RefundStatus.receiptNotFound,
          'No receipt was found with ID $detailId.',
        );
      default:
        return RefundOutcome.failed(
          'The server could not complete the refund'
          '${msg == null ? '.' : ': $msg'}',
        );
    }
  }
}
