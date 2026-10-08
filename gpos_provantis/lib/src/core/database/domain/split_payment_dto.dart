import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';

/// One of the two payments in a split sale.
class SplitPaymentLeg {
  const SplitPaymentLeg({
    required this.type,
    required this.amount,
    required this.reference,
  });

  /// The payment method's name, e.g. "GCASH".
  final String type;
  final double amount;

  /// The e-payment reference the customer gave.
  final String reference;
}

/// Values for [SplitPaymentTableData.paymentType].
abstract class SplitPaymentKind {
  static const ePaymentAndEPayment = 'E2E';
}

/// Values for [SplitPaymentTableData.syncStatus].
abstract class SplitPaymentSyncStatus {
  static const pending = 'PENDING';
  static const synced = 'SYNCED';
}

class SplitPaymentDto {
  const SplitPaymentDto({
    required this.id,
    required this.detailId,
    required this.date,
    required this.posId,
    required this.shift,
    required this.items,
    required this.staff,
    required this.branchId,
    required this.first,
    required this.second,
    required this.discountDetails,
    required this.total,
    required this.paymentType,
    required this.createdAt,
    this.syncStatus = SplitPaymentSyncStatus.pending,
  });

  /// A new split sale, with a fresh id.
  factory SplitPaymentDto.create({
    required String detailId,
    required String date,
    required String posId,
    required String shift,
    required String items,
    required String staff,
    required String branchId,
    required SplitPaymentLeg first,
    required SplitPaymentLeg second,
    required String discountDetails,
    required double total,
    String paymentType = SplitPaymentKind.ePaymentAndEPayment,
  }) {
    return SplitPaymentDto(
      id: const Uuid().v4(),
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
      createdAt: DateTime.now(),
    );
  }

  final String id;
  final String detailId;
  final String date;
  final String posId;
  final String shift;
  final String items;
  final String staff;
  final String branchId;
  final SplitPaymentLeg first;
  final SplitPaymentLeg second;
  final String discountDetails;
  final double total;
  final String paymentType;
  final DateTime createdAt;
  final String syncStatus;

  factory SplitPaymentDto.fromTableData(SplitPaymentTableData row) {
    return SplitPaymentDto(
      id: row.id,
      detailId: row.detailId,
      date: row.date,
      posId: row.posId,
      shift: row.shift,
      items: row.items,
      staff: row.staff,
      branchId: row.branchId,
      first: SplitPaymentLeg(
        type: row.firstPaymentType,
        amount: row.firstPayment,
        reference: row.firstPaymentReference,
      ),
      second: SplitPaymentLeg(
        type: row.secondPaymentType,
        amount: row.secondPayment,
        reference: row.secondPaymentReference,
      ),
      discountDetails: row.discountDetails,
      total: row.total,
      paymentType: row.paymentType,
      createdAt: row.createdAt,
      syncStatus: row.syncStatus,
    );
  }

  SplitPaymentTableCompanion toCompanion() {
    return SplitPaymentTableCompanion.insert(
      id: Value(id),
      detailId: detailId,
      date: date,
      posId: posId,
      shift: shift,
      items: items,
      staff: staff,
      branchId: branchId,
      firstPaymentType: first.type,
      firstPayment: first.amount,
      firstPaymentReference: Value(first.reference),
      secondPaymentType: second.type,
      secondPayment: second.amount,
      secondPaymentReference: Value(second.reference),
      discountDetails: Value(discountDetails),
      total: total,
      paymentType: Value(paymentType),
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
    );
  }

  /// The body `POST /salesdetails/splitpayment` expects. Amounts are strings
  /// (`'250.0'`), `items` and `discountdetails` are JSON strings, and the key
  /// for the first reference is misspelled on the server, so it is misspelled
  /// here on purpose.
  Map<String, dynamic> toApiJson() => {
    'detailid': detailId,
    'date': date,
    'posid': posId,
    'shift': shift,
    'items': items,
    'staff': staff,
    'firstpayment': first.amount.toString(),
    'secondpayment': second.amount.toString(),
    'firstpaymenttype': first.type,
    'secondpaymenttype': second.type,
    'branchid': branchId,
    'firstpatmentreference': first.reference, // sic: the server's spelling
    'secondpaymentreference': second.reference,
    'discountdetails': discountDetails,
    'total': total.toString(),
    'paymenttype': paymentType,
  };
}