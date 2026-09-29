import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/providers/payments_dao_provider.dart';

part 'payments_controller.g.dart';

class PaymentMethod {
  const PaymentMethod._({
    required this.id,
    required this.label,
    required this.isCash,
  });

  static const cash = PaymentMethod._(
    id: '__cash__',
    label: 'Cash',
    isCash: true,
  );

  factory PaymentMethod.fromPaymentRow(PaymentsTableData row) {
    return PaymentMethod._(
      id: row.paymentId.toString(),
      label: row.paymentName,
      isCash: false,
    );
  }

  final String id;
  final String label;
  final bool isCash;

  @override
  bool operator ==(Object other) => other is PaymentMethod && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

enum PaymentStep {
  root,
  ePayments,
  ePaymentConfirm,
  cash,
  splitChoice,
  splitCashEPayment,
  splitEPaymentEPayment,
}

enum SplitKind { cashAndEPayment, ePaymentAndEPayment }

class SplitSlot {
  const SplitSlot({this.method, this.amount, this.referenceId});

  final PaymentMethod? method;
  final double? amount;
  final String? referenceId;

  bool get isCash => method?.isCash ?? false;

  bool get isComplete {
    if (method == null || amount == null || amount! <= 0) return false;
    if (isCash) return true;
    return (referenceId ?? '').trim().isNotEmpty;
  }

  SplitSlot copyWith({
    Object? method = _unset,
    Object? amount = _unset,
    Object? referenceId = _unset,
  }) {
    return SplitSlot(
      method: identical(method, _unset)
          ? this.method
          : method as PaymentMethod?,
      amount: identical(amount, _unset) ? this.amount : amount as double?,
      referenceId: identical(referenceId, _unset)
          ? this.referenceId
          : referenceId as String?,
    );
  }
}

const Object _unset = Object();

class PaymentState {
  const PaymentState({
    this.step = PaymentStep.root,
    this.selectedMethod,
    this.cashAmountTendered,
    this.singleEPaymentReferenceId,
    this.splitKind,
    this.splitSlots = const [SplitSlot(), SplitSlot()],
  });

  final PaymentStep step;

  final PaymentMethod? selectedMethod;

  final double? cashAmountTendered;

  final String? singleEPaymentReferenceId;

  final SplitKind? splitKind;

  final List<SplitSlot> splitSlots;

  double? cashChangeDue(double chargeTotal) {
    final tendered = cashAmountTendered;
    if (tendered == null) return null;
    final change = tendered - chargeTotal;
    return change < 0 ? null : change;
  }

  bool cashIsReadyToConfirm(double chargeTotal) {
    final tendered = cashAmountTendered;
    if (tendered == null) return false;
    return tendered - chargeTotal >= -0.01;
  }

  bool get singleEPaymentIsReadyToConfirm {
    if (selectedMethod == null) return false;
    return (singleEPaymentReferenceId ?? '').trim().isNotEmpty;
  }

  double get splitAssignedTotal =>
      splitSlots.fold(0, (sum, slot) => sum + (slot.amount ?? 0));

  bool get isSplitReady {
    if (!splitSlots.every((slot) => slot.isComplete)) return false;
    return splitSlots[0].method != splitSlots[1].method;
  }

  bool splitIsReadyToConfirm(double chargeTotal) {
    if (!isSplitReady) return false;

    return (splitAssignedTotal - chargeTotal).abs() < 0.01;
  }

  PaymentState copyWith({
    PaymentStep? step,
    Object? selectedMethod = _unset,
    Object? cashAmountTendered = _unset,
    Object? singleEPaymentReferenceId = _unset,
    Object? splitKind = _unset,
    List<SplitSlot>? splitSlots,
  }) {
    return PaymentState(
      step: step ?? this.step,
      selectedMethod: identical(selectedMethod, _unset)
          ? this.selectedMethod
          : selectedMethod as PaymentMethod?,
      cashAmountTendered: identical(cashAmountTendered, _unset)
          ? this.cashAmountTendered
          : cashAmountTendered as double?,
      singleEPaymentReferenceId: identical(singleEPaymentReferenceId, _unset)
          ? this.singleEPaymentReferenceId
          : singleEPaymentReferenceId as String?,
      splitKind: identical(splitKind, _unset)
          ? this.splitKind
          : splitKind as SplitKind?,
      splitSlots: splitSlots ?? this.splitSlots,
    );
  }
}

@riverpod
List<PaymentMethod> ePaymentMethods(Ref ref) {
  final rows = ref.watch(paymentsProvider).value ?? const <PaymentsTableData>[];
  return rows
      .where((row) => row.status.toLowerCase() == 'active')
      .map(PaymentMethod.fromPaymentRow)
      .toList();
}

@riverpod
class PaymentController extends _$PaymentController {
  @override
  PaymentState build() => const PaymentState();

  void openEPaymentsList() {
    state = state.copyWith(step: PaymentStep.ePayments);
  }

  void openCash() {
    state = state.copyWith(step: PaymentStep.cash);
  }

  void openSplitChoice() {
    state = state.copyWith(step: PaymentStep.splitChoice);
  }

  void chooseSplitKind(SplitKind kind) {
    final step = kind == SplitKind.cashAndEPayment
        ? PaymentStep.splitCashEPayment
        : PaymentStep.splitEPaymentEPayment;
    final firstSlot = kind == SplitKind.cashAndEPayment
        ? const SplitSlot(method: PaymentMethod.cash)
        : const SplitSlot();
    state = state.copyWith(
      step: step,
      splitKind: kind,
      splitSlots: [firstSlot, const SplitSlot()],
    );
  }

  void goBack() {
    switch (state.step) {
      case PaymentStep.root:
        break; // nothing above root — caller should close the modal instead
      case PaymentStep.ePayments:
      case PaymentStep.cash:
      case PaymentStep.splitChoice:
        state = state.copyWith(
          step: PaymentStep.root,
          selectedMethod: null,
          cashAmountTendered: null,
        );
      case PaymentStep.ePaymentConfirm:
        state = state.copyWith(
          step: PaymentStep.ePayments,
          selectedMethod: null,
          singleEPaymentReferenceId: null,
        );
      case PaymentStep.splitCashEPayment:
      case PaymentStep.splitEPaymentEPayment:
        state = state.copyWith(
          step: PaymentStep.splitChoice,
          splitKind: null,
          splitSlots: const [SplitSlot(), SplitSlot()],
        );
    }
  }

  void selectEPaymentMethod(PaymentMethod method) {
    state = state.copyWith(
      step: PaymentStep.ePaymentConfirm,
      selectedMethod: method,
      singleEPaymentReferenceId: null,
    );
  }

  void setSingleEPaymentReferenceId(String referenceId) {
    state = state.copyWith(singleEPaymentReferenceId: referenceId);
  }

  void setCashAmountTendered(double? amount) {
    state = state.copyWith(cashAmountTendered: amount);
  }

  void setCashExactAmount(double chargeTotal) {
    setCashAmountTendered(chargeTotal);
  }

  void setSplitSlotMethod(int index, PaymentMethod method) {
    final updated = [...state.splitSlots];
    updated[index] = updated[index].copyWith(method: method, referenceId: null);
    state = state.copyWith(splitSlots: updated);
  }

  void setSplitSlotAmount(int index, double? amount) {
    final updated = [...state.splitSlots];
    updated[index] = updated[index].copyWith(amount: amount);
    state = state.copyWith(splitSlots: updated);
  }

  void setSplitSlotReferenceId(int index, String referenceId) {
    final updated = [...state.splitSlots];
    updated[index] = updated[index].copyWith(referenceId: referenceId);
    state = state.copyWith(splitSlots: updated);
  }

  void fillRemainingAmount(int index, double chargeTotal) {
    final otherIndex = index == 0 ? 1 : 0;
    final otherAmount = state.splitSlots[otherIndex].amount ?? 0;
    final remaining = chargeTotal - otherAmount;
    setSplitSlotAmount(index, remaining < 0 ? 0 : remaining);
  }

  void reset() {
    state = const PaymentState();
  }
}
