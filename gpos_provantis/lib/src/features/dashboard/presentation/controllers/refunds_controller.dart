import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/database/providers/user_data_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/repository/refund_repository.dart';
import 'package:gpos_provantis/src/shared/widgets/toast_emitter.dart';

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
    // Unlike this auto-dispose controller, the emitter stays alive, so the
    // cashier still hears the result if the refund sheet closed mid-request.
    final toast = ref.read(toastEmitterProvider);

    state = const RefundsState(isSubmitting: true);

    try {
      final user = await userDao.getUser();
      final cashier = user?.fullName;
      debugPrint('Refunds: cashier resolved as "$cashier"');
      if (cashier == null || cashier.isEmpty || cashier == 'INVALID USER') {
        _finish(
          toast,
          detailId,
          const RefundOutcome.failed(
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
      _finish(toast, detailId, outcome);
    } catch (e) {
      debugPrint('Refunds: request failed: $e');
      if (isDuplicateRequestError(e)) {
        // Shown on purpose: swallowing it silently made the button look dead.
        _finish(
          toast,
          detailId,
          const RefundOutcome.failed(
            'A request is already in progress. Wait a moment and try again.',
          ),
        );
        return;
      }
      _finish(toast, detailId, RefundOutcome.failed(_describe(e)));
    }
  }

  void dismissOutcome() => state = const RefundsState();

  /// The one place a refund attempt ends: tells the cashier, then publishes
  /// the outcome. The toast goes first and the state write is guarded, so the
  /// result is never lost if this controller was disposed while waiting.
  void _finish(ToastEmitter toast, String detailId, RefundOutcome outcome) {
    if (_isSuccess(outcome)) {
      toast.success('Receipt #$detailId was refunded.');
    } else {
      final message = '${outcome.message}'.trim();
      toast.error(
        message.isEmpty
            ? 'Refund of receipt #$detailId failed.'
            : 'Refund of receipt #$detailId failed. $message',
      );
    }
    if (ref.mounted) state = RefundsState(outcome: outcome);
  }

  // CHECK THIS ONE: refund_repository.dart wasn't included, so I could only
  // go by `status` (the one other member visible here). If RefundOutcome has a
  // proper success flag (e.g. `outcome.isSuccess`), use that instead. If this
  // guess is wrong, a good refund shows as red; it can never show a failed
  // refund as green.
  bool _isSuccess(RefundOutcome outcome) =>
      outcome.status.toString().toLowerCase().contains('success');

  String _describe(Object e) {
    if (e is DioException) {
      return 'Could not reach the server. Check the connection and try again.';
    }
    return e.toString().replaceFirst('Exception: ', '');
  }
}
