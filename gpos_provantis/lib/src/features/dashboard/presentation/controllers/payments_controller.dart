// Location: src/features/dashboard/controllers/payment_controller.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/providers/payments_dao_provider.dart';

part 'payments_controller.g.dart';

/// =========================================================================
/// PAYMENT CONTROLLER — state for the payment modal that opens off the
/// cart's Charge button.
///
/// The modal is a single small drill-down, not a set of independent
/// screens — `PaymentStep` is exactly the tree the cashier can be
/// looking at, and `step` is the only thing that decides which of it is
/// currently on screen:
///
///   root
///   ├─ ePayments            (tap E-PAYMENTS on root)
///   ├─ cash                 (tap CASH on root — placeholder for now)
///   └─ splitChoice          (tap SPLIT PAYMENT on root)
///      ├─ splitCashEPayment       (Cash + one E-payment)
///      └─ splitEPaymentEPayment   (two E-payments)
///
/// Back navigation is just walking this tree upward — see
/// `PaymentController.goBack()`.
///
/// METHOD SOURCE: the server/local DB (`PaymentsTableData`, via
/// `paymentsProvider`) only ever returns E-payment methods — there is no
/// CASH row anywhere in that table. Cash is a fixed, code-level option
/// with no backing DB row (see `PaymentMethod.cash` below).
///
/// SPLIT IS EXACTLY TWO TENDERS: reconciling which tender covered what
/// stops being something a cashier can eyeball on a receipt past two,
/// so the two split shapes (`splitCashEPayment` / `splitEPaymentEPayment`)
/// are the only two the tree has — there's no path to a third slot.
/// =========================================================================

/// One selectable tender. `cash` is the single hardcoded, non-DB-backed
/// instance; every other instance is a 1:1 mapping of a synced
/// `PaymentsTableData` row (`fromPaymentRow`).
class PaymentMethod {
  const PaymentMethod._({
    required this.id,
    required this.label,
    required this.isCash,
  });

  /// The one static option. `id` is a sentinel string, never a real
  /// `paymentId` — nothing in `PaymentsTableData` can collide with it,
  /// since DB rows are keyed by integer `paymentId` and this is never
  /// parsed as one.
  static const cash = PaymentMethod._(
    id: '__cash__',
    label: 'Cash',
    isCash: true,
  );

  /// Maps a synced E-payment DB row onto the same shape the UI uses for
  /// Cash, so dropdown/selection code doesn't need to special-case where
  /// a given `PaymentMethod` came from.
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

/// Every screen the payment modal can be showing. See the file doc
/// comment above for the tree this enum walks.
enum PaymentStep {
  root,
  ePayments,
  cash,
  splitChoice,
  splitCashEPayment,
  splitEPaymentEPayment,
}

/// Which of the two split shapes is in play. Kept separate from
/// `PaymentStep` itself (rather than switching UI purely off the step)
/// so the split-slot widgets have one flag to key off regardless of
/// which step got them there.
enum SplitKind { cashAndEPayment, ePaymentAndEPayment }

/// One tender inside a split payment. `referenceId` only ever applies to
/// an E-payment slot (a cash slot has nothing to reference) — left
/// present-but-ignored on a cash slot rather than modeled away, since a
/// slot can flip from E-payment to cash while the cashier is still
/// filling amounts in, and this way nothing needs to be cleared out
/// when that happens.
class SplitSlot {
  const SplitSlot({this.method, this.amount, this.referenceId});

  final PaymentMethod? method;
  final double? amount;
  final String? referenceId;

  bool get isCash => method?.isCash ?? false;

  /// A cash slot only needs a method + positive amount. An E-payment
  /// slot additionally needs a non-blank reference id — there's no
  /// reconciling an E-payment tender against the processor's own
  /// records without one.
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

/// Full state of the payment modal.
class PaymentState {
  const PaymentState({
    this.step = PaymentStep.root,
    this.selectedMethod,
    this.cashAmountTendered,
    this.splitKind,
    this.splitSlots = const [SplitSlot(), SplitSlot()],
  });

  final PaymentStep step;

  /// The single tender chosen on the E-PAYMENTS list. Root-level Cash
  /// confirms straight from `PaymentMethod.cash` without needing this
  /// field, since there's nothing to pick from a list of one.
  final PaymentMethod? selectedMethod;

  /// How much cash the customer handed over, for the root-level Cash
  /// screen (`PaymentStep.cash`) — distinct from any split-slot amount,
  /// since a single cash tender can exceed the total (change is owed)
  /// while a split slot's amount is capped by what's left of the total.
  final double? cashAmountTendered;

  /// Which split shape is active, once the cashier has picked one on
  /// `splitChoice`. Null before that pick is made.
  final SplitKind? splitKind;

  /// Always exactly two entries — index 0 is "Cash" when
  /// `splitKind == cashAndEPayment` (locked, not user-changeable),
  /// otherwise both indices are free-choice E-payment slots.
  final List<SplitSlot> splitSlots;

  /// Change owed back to the customer on the root-level Cash screen, or
  /// null until a valid amount has been entered. Never negative from
  /// this getter's point of view — a tendered amount below the total
  /// isn't "negative change", it's simply not enough yet, which
  /// `cashIsReadyToConfirm` is what actually gates.
  double? cashChangeDue(double chargeTotal) {
    final tendered = cashAmountTendered;
    if (tendered == null) return null;
    final change = tendered - chargeTotal;
    return change < 0 ? null : change;
  }

  /// Ready to confirm once the customer has tendered at least the
  /// charge total (a cent of floating-point slack either way).
  bool cashIsReadyToConfirm(double chargeTotal) {
    final tendered = cashAmountTendered;
    if (tendered == null) return false;
    return tendered - chargeTotal >= -0.01;
  }

  double get splitAssignedTotal =>
      splitSlots.fold(0, (sum, slot) => sum + (slot.amount ?? 0));

  bool get isSplitReady {
    if (!splitSlots.every((slot) => slot.isComplete)) return false;
    return splitSlots[0].method != splitSlots[1].method;
  }

  bool splitIsReadyToConfirm(double chargeTotal) {
    if (!isSplitReady) return false;
    // Floating point money math — compare within a cent rather than
    // exact equality.
    return (splitAssignedTotal - chargeTotal).abs() < 0.01;
  }

  PaymentState copyWith({
    PaymentStep? step,
    Object? selectedMethod = _unset,
    Object? cashAmountTendered = _unset,
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
      splitKind: identical(splitKind, _unset)
          ? this.splitKind
          : splitKind as SplitKind?,
      splitSlots: splitSlots ?? this.splitSlots,
    );
  }
}

/// E-payment methods available right now, mapped from whatever's synced
/// into the local `payments` table and filtered to active rows only —
/// the endpoint this table is synced from is `/payment/getactive` (see
/// `payments_repository.dart`), but a row's `status` can still flip
/// after it's already been synced/cached locally, so this re-checks
/// rather than trusting every cached row is still current.
///
/// A standalone provider rather than a getter on `PaymentController`
/// on purpose: a getter reached through `ref.read(provider.notifier)`
/// still runs `ref.watch(paymentsProvider)` internally, but the
/// *widget* calling that getter never itself subscribes to
/// `paymentsProvider` — so if the payments stream hadn't emitted yet
/// (e.g. right after login, before the first sync finishes), the
/// widget would render an empty list and then simply never rebuild
/// when the real data arrived a moment later, since nothing told it
/// to. Only a subsequent, unrelated rebuild (like the one from
/// tapping a tile) would happen to pick up the now-loaded data — which
/// is exactly the "first tap looks empty, second tap works" symptom
/// this caused. Calling `ref.watch(ePaymentMethodsProvider)` directly
/// from the widget subscribes it for real, so it rebuilds the instant
/// the underlying stream emits.
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

  // --- Navigation ---------------------------------------------------

  void openEPaymentsList() {
    state = state.copyWith(step: PaymentStep.ePayments);
  }

  void openCash() {
    state = state.copyWith(step: PaymentStep.cash);
  }

  void openSplitChoice() {
    state = state.copyWith(step: PaymentStep.splitChoice);
  }

  /// Enters one of the two split shapes and resets both slots for it.
  /// For `cashAndEPayment`, slot 0 is pre-seeded with the Cash method
  /// (it's fixed there, not a free dropdown choice) so the cashier only
  /// ever fills its amount, never re-picks what it is.
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

  /// Walks one level back up the tree described in the file doc
  /// comment. Called by the modal's back/close-to-parent control.
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
      case PaymentStep.splitCashEPayment:
      case PaymentStep.splitEPaymentEPayment:
        state = state.copyWith(
          step: PaymentStep.splitChoice,
          splitKind: null,
          splitSlots: const [SplitSlot(), SplitSlot()],
        );
    }
  }

  // --- Single-method selection ---------------------------------------

  void selectEPaymentMethod(PaymentMethod method) {
    state = state.copyWith(selectedMethod: method);
  }

  void setCashAmountTendered(double? amount) {
    state = state.copyWith(cashAmountTendered: amount);
  }

  /// Fills the root-level Cash screen's tendered amount with exactly
  /// the charge total — the "customer paid exact change" one-tap path,
  /// same idea as `fillRemainingAmount` for split slots but simpler
  /// since there's no other slot to subtract.
  void setCashExactAmount(double chargeTotal) {
    setCashAmountTendered(chargeTotal);
  }

  // --- Split slot editing ---------------------------------------------

  /// Sets a split slot's method. Slot 0 is locked to Cash for the
  /// cash-and-e-payment shape — callers only ever invoke this for the
  /// e-payment slot(s) in that shape, and for either slot in the
  /// e-payment-and-e-payment shape.
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

  /// Fills whichever slot is still missing an amount with exactly what's
  /// left of the charge total.
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
