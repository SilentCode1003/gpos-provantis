import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/domain/split_payment_dto.dart';
import 'package:gpos_provantis/src/core/database/repository/split_payment_repository.dart';

part 'split_payment_service.g.dart';

/// Outcome of recording a split sale. It is ALWAYS saved on the device first;
/// [sent] says whether the server has it yet.
class SplitPaymentResult {
  const SplitPaymentResult({
    required this.record,
    required this.sent,
    this.error,
  });

  final SplitPaymentTableData record;

  /// True once the server has the sale. False means it is safely stored and
  /// will be sent later.
  final bool sent;

  /// Why the last send failed, when [sent] is false and a send was tried.
  final String? error;
}

@Riverpod(keepAlive: true)
SplitPaymentService splitPaymentService(Ref ref) {
  return SplitPaymentService(
    repository: ref.watch(splitPaymentRepositoryProvider),
  );
}

/// Records a sale paid with two payments, the same way a normal sale is
/// recorded: save it on the device first, THEN send it to the server if the
/// connection allows.
class SplitPaymentService {
  SplitPaymentService({required SplitPaymentRepository repository})
    : _repository = repository;

  final SplitPaymentRepository _repository;

  /// Saves the split sale, then uploads it.
  ///
  /// 1. The sale is written to the local DB. Nothing is sent unless this
  ///    succeeds, and once it has, the sale can't be lost, whatever the network
  ///    does next. If this step throws, the caller must treat the sale as not
  ///    recorded.
  /// 2. Then every pending split sale (this one and any older ones) is
  ///    uploaded. This never throws: if the server is unreachable the sale
  ///    stays PENDING and goes out on a later [syncPending].
  Future<SplitPaymentResult> recordSplitPayment({
    required String detailId,
    required String date,
    required String posId,
    required String shift,
    required String items,
    required String staff,
    required String branchId,
    required String discountDetails,
    required double total,
    required SplitPaymentLeg first,
    required SplitPaymentLeg second,
    String paymentType = SplitPaymentKind.ePaymentAndEPayment,
  }) async {
    // 1. Always save first.
    final saved = await _repository.saveSplitPayment(
      SplitPaymentDto.create(
        detailId: detailId,
        date: date,
        posId: posId,
        shift: shift,
        items: items,
        staff: staff,
        branchId: branchId,
        first: first,
        second: second,
        discountDetails: discountDetails,
        total: total,
        paymentType: paymentType,
      ),
    );

    // 2. Then upload. Failures are recorded on the row, not thrown.
    try {
      await _repository.syncPending();
    } catch (e) {
      debugPrint('SplitPaymentService: upload failed: $e');
    }

    final latest = await _repository.getSplitPayment(saved.id) ?? saved;
    final sent = latest.syncStatus == SplitPaymentSyncStatus.synced;

    return SplitPaymentResult(
      record: latest,
      sent: sent,
      error: sent ? null : latest.lastError,
    );
  }

  /// Whether the server already has the sale with receipt id [detailId]. False
  /// if there is no such split sale here, or it hasn't been accepted yet.
  Future<bool> isUploaded(String detailId) async {
    final row = await _repository.getSplitPaymentForReceipt(detailId);
    return row?.syncStatus == SplitPaymentSyncStatus.synced;
  }

  /// Uploads any split sales still waiting (e.g. the device was offline when
  /// they were made). Safe to call any time; returns how many were sent.
  Future<int> syncPending() => _repository.syncPending();
}
