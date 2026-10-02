import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/database/providers/user_data_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/repository/refund_repository.dart';

part 'refunds_controller.g.dart';

class RefundsState {
  const RefundsState({this.isSubmitting = false, this.outcome});

  final bool isSubmitting;

  /// Result of the last attempt; null until one finishes.
  final RefundOutcome? outcome;
}

@riverpod
class RefundsController extends _$RefundsController {
  @override
  RefundsState build() => const RefundsState();

  Future<void> submit({
    required String detailId,
    required String reason,
  }) async {
    debugPrint('Refunds: submit(detailId=$detailId)');

    // Double-tap guard.
    if (state.isSubmitting) {
      debugPrint('Refunds: ignored, a refund is already in progress');
      return;
    }

    // Read everything from `ref` before the first await.
    final userDao = ref.read(userDataDaoProvider);
    final repository = ref.read(refundRepositoryProvider);

    state = const RefundsState(isSubmitting: true);

    try {
      final user = await userDao.getUser();
      final cashier = user?.fullName;
      debugPrint('Refunds: cashier resolved as "$cashier"');
      if (cashier == null || cashier.isEmpty || cashier == 'INVALID USER') {
        state = const RefundsState(
          outcome: RefundOutcome.failed(
            'No user is logged in, so the refund can\'t be attributed to a '
            'cashier.',
          ),
        );
        return;
      }

      debugPrint('Refunds: calling API');
      final outcome = await repository.refundSale(
        detailId: detailId,
        reason: reason,
        cashier: cashier,
      );
      debugPrint(
        'Refunds: API answered ${outcome.status} - ${outcome.message}',
      );
      state = RefundsState(outcome: outcome);
    } catch (e) {
      debugPrint('Refunds: request failed: $e');
      if (isDuplicateRequestError(e)) {
        // Shown on purpose: swallowing it silently made the button look dead.
        state = const RefundsState(
          outcome: RefundOutcome.failed(
            'A request is already in progress. Wait a moment and try again.',
          ),
        );
        return;
      }
      state = RefundsState(outcome: RefundOutcome.failed(_describe(e)));
    }
  }

  void dismissOutcome() => state = const RefundsState();

  String _describe(Object e) {
    if (e is DioException) {
      return 'Could not reach the server. Check the connection and try again.';
    }
    return e.toString().replaceFirst('Exception: ', '');
  }
}
