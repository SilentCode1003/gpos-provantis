// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/payment_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/core/database/providers/payments_dao_provider.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/payments_controller.dart';
import 'amount_input_formatter.dart';
import 'dashboard_constants.dart';

/// =========================================================================
/// PAYMENT MODAL — opens centered over the dashboard off the cart's
/// Charge button. Call `showPaymentModal(context)`.
///
/// This is a drill-down inside one fixed-size dialog card, not a stack
/// of routes — `PaymentController.step` (see payment_controller.dart)
/// says which of the tree below is on screen, and every step renders
/// through the same header (title + back/close) and the same outer
/// frame, so nothing about the dialog's size or position jumps around
/// as the cashier drills in and out:
///
///   root                        — E-PAYMENTS / CASH / SPLIT PAYMENT
///   ├─ ePayments                — list of synced E-payment methods
///   ├─ cash                     — placeholder
///   └─ splitChoice              — CASH + E-PAYMENT / E-PAYMENT + E-PAYMENT
///      ├─ splitCashEPayment     — Cash row w/ amount, then one E-payment block
///      └─ splitEPaymentEPayment — two E-payment blocks
///
/// Deliberately not dismissible by a barrier tap — same reasoning as
/// the old full-screen version: a payment in progress shouldn't vanish
/// from an accidental tap outside the card. The header's close/back
/// control is the only way out.
/// =========================================================================

Future<void> showPaymentModal(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _PaymentModal(),
  );
}

class _PaymentModal extends ConsumerWidget {
  const _PaymentModal();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final step = ref.watch(paymentControllerProvider.select((s) => s.step));

    // A plain Dialog does NOT reposition itself above a software
    // keyboard the way a Scaffold with resizeToAvoidBottomInset does —
    // showDialog's AnimatedPadding only pads by viewInsets.bottom, it
    // doesn't shrink *this* box's own maxHeight, so a fixed-height
    // dialog can still end up with its lower content (e.g. the Amount
    // field on the split screens) sitting behind the keyboard on
    // Android/Windows touch keyboards. Reading viewInsets.bottom here
    // and subtracting it from the available height keeps the whole
    // dialog inside whatever space is actually left above the
    // keyboard, so it visibly shrinks/rises instead of getting
    // clipped. AnimatedPadding (not Padding) so the resize tracks the
    // keyboard's own slide-in/out animation instead of snapping.
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: Dialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          // Sized for a 14" POS terminal in landscape, not a phone
          // dialog — wide enough that the root/split-choice cubes sit
          // at a real touch-friendly size side-by-side instead of
          // being squeezed into a narrow column. maxHeight is clamped
          // against whatever room is left once the keyboard (if any)
          // and the dialog's own inset padding are accounted for, so
          // it shrinks to fit rather than overflowing off-screen.
          constraints: BoxConstraints(
            maxWidth: 860,
            maxHeight: (MediaQuery.sizeOf(context).height - keyboardInset - 64)
                .clamp(320, 720),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ModalHeader(step: step),
              Flexible(child: _ModalBody(step: step)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Title + total, and either a close (✕, at root) or back (←, everywhere
/// deeper) control. Sized above the dashboard's 56px floor — this is a
/// frequently-tapped, high-consequence control (closing/backing out of
/// a payment in progress), so it gets the same generous treatment as
/// the cubes below rather than shrinking to the bare minimum just
/// because it's "only" a header icon.
class _ModalHeader extends ConsumerWidget {
  const _ModalHeader({required this.step});

  final PaymentStep step;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final total = ref.watch(dashboardControllerProvider).total;
    final notifier = ref.read(paymentControllerProvider.notifier);
    final isRoot = step == PaymentStep.root;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 28, 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: Row(
        children: [
          Material(
            color: colors.surfaceVariant,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () async {
                if (isRoot) {
                  final confirmed = await _confirmCancel(context);
                  if (confirmed == true && context.mounted) {
                    notifier.reset();
                    Navigator.of(context).pop();
                  }
                } else {
                  notifier.goBack();
                }
              },
              customBorder: const CircleBorder(),
              child: SizedBox(
                width: primaryTapTarget,
                height: primaryTapTarget,
                child: Icon(
                  isRoot ? PhosphorIcons.x : PhosphorIcons.arrowLeft,
                  size: 26,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              _titleFor(step),
              style: AppTypography.display(
                color: colors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '₱${formatAmountForField(total)}',
            style: AppTypography.display(
              color: colors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _titleFor(PaymentStep step) {
    switch (step) {
      case PaymentStep.root:
        return 'Payment';
      case PaymentStep.ePayments:
        return 'E-Payments';
      case PaymentStep.cash:
        return 'Cash';
      case PaymentStep.splitChoice:
        return 'Split payment';
      case PaymentStep.splitCashEPayment:
        return 'Cash + E-Payment';
      case PaymentStep.splitEPaymentEPayment:
        return 'E-Payment + E-Payment';
    }
  }

  Future<bool?> _confirmCancel(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel payment?'),
        content: const Text(
          'The sale will stay in the cart — nothing is lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('KEEP EDITING'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('CANCEL PAYMENT'),
          ),
        ],
      ),
    );
  }
}

class _ModalBody extends StatelessWidget {
  const _ModalBody({required this.step});

  final PaymentStep step;

  @override
  Widget build(BuildContext context) {
    switch (step) {
      case PaymentStep.root:
        return const _RootOptions();
      case PaymentStep.ePayments:
        return const _EPaymentsList();
      case PaymentStep.cash:
        return const _CashScreen();
      case PaymentStep.splitChoice:
        return const _SplitChoiceOptions();
      case PaymentStep.splitCashEPayment:
        return const _SplitLayout(kind: SplitKind.cashAndEPayment);
      case PaymentStep.splitEPaymentEPayment:
        return const _SplitLayout(kind: SplitKind.ePaymentAndEPayment);
    }
  }
}

/// --- Root: E-PAYMENTS / CASH / SPLIT PAYMENT ----------------------------

/// Three big square buttons side by side — the highest-traffic decision
/// point in the whole payment flow, so this gets the largest, most
/// touch-forgiving treatment in the modal rather than a compact list.
/// A vertical list of rows (the old design) wastes the width a 14"
/// landscape terminal actually has and gives each option a smaller,
/// thumb-height target; three squares across use the width instead and
/// make every option large in both dimensions.
class _RootOptions extends ConsumerWidget {
  const _RootOptions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(paymentControllerProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _CubeButton(
              label: 'E-Payments',
              icon: PhosphorIcons.deviceMobile,
              onTap: notifier.openEPaymentsList,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: _CubeButton(
              label: 'Cash',
              icon: PhosphorIcons.money,
              onTap: notifier.openCash,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: _CubeButton(
              label: 'Split Payment',
              icon: PhosphorIcons.arrowsSplit,
              onTap: notifier.openSplitChoice,
            ),
          ),
        ],
      ),
    );
  }
}

/// Square, large-icon-over-label button — the primary touch target
/// shape for this modal. Kept square (via AspectRatio) rather than
/// letting height float free, so 3-up and 2-up rows both read as a
/// consistent family of controls no matter which step is showing them.
///
/// Sizing is deliberately generous well past the 56px floor: the icon
/// alone is 44px and the whole tile runs well over 120px tall at the
/// modal's default width, because on a 14" terminal a primary decision
/// button should be unmistakably large, not just technically compliant
/// with the minimum.
class _CubeButton extends StatelessWidget {
  const _CubeButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.subtitle,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.border, width: 1.5),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 44, color: colors.primary),
                const SizedBox(height: 14),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.ui(
                    color: colors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.ui(
                      color: colors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// --- E-PAYMENTS: list of synced payment rows -----------------------------

/// Shows whatever's in `ePaymentMethodsProvider` — the local `payments`
/// table synced from the server (see payments_repository.dart). Tapping
/// a row selects it as the charge's single tender and confirms
/// immediately, same as tapping Cash does at root — there's nothing
/// further to configure for a single E-payment tender at this step (no
/// reference id / amount split, since the full total is going on one
/// tender).
///
/// Uses `ref.watch(ePaymentMethodsProvider)` directly (not read through
/// the controller) so this widget actually subscribes to the payments
/// stream and rebuilds the moment it resolves — see the doc comment on
/// `ePaymentMethodsProvider` in payment_controller.dart for why that
/// distinction matters here specifically.
class _EPaymentsList extends ConsumerWidget {
  const _EPaymentsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final notifier = ref.read(paymentControllerProvider.notifier);
    // Watch the raw AsyncValue (not the derived list) so "still
    // loading" and "genuinely empty" render differently — without
    // this, the first open of the screen (before the payments stream
    // has emitted at all) looked identical to "no payment methods
    // exist", which read as broken even once the stale-subscription
    // bug above was fixed.
    final paymentsAsync = ref.watch(paymentsProvider);

    return paymentsAsync.when(
      loading: () => const _EPaymentsLoading(),
      error: (error, _) => _EPaymentsError(error: error),
      data: (_) {
        final methods = ref.watch(ePaymentMethodsProvider);
        if (methods.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Text(
                'No E-payment methods are synced yet.',
                textAlign: TextAlign.center,
                style: AppTypography.ui(
                  color: colors.textSecondary,
                  fontSize: 15,
                ),
              ),
            ),
          );
        }

        // Grid of cubes, same family as the root options — 3 across
        // keeps each tile large; wraps to more rows as more methods
        // sync in rather than shrinking tiles to fit them all on one
        // row.
        return GridView.builder(
          padding: const EdgeInsets.all(28),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1,
          ),
          itemCount: methods.length,
          itemBuilder: (context, index) {
            final method = methods[index];
            return _CubeButton(
              label: method.label,
              icon: PhosphorIcons.deviceMobile,
              onTap: () {
                notifier.selectEPaymentMethod(method);
                _confirmSingle(context, ref);
              },
            );
          },
        );
      },
    );
  }

  void _confirmSingle(BuildContext context, WidgetRef ref) {
    ref.read(paymentControllerProvider.notifier).reset();
    Navigator.of(context).pop();
  }
}

class _EPaymentsLoading extends StatelessWidget {
  const _EPaymentsLoading();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading payment methods…',
              style: AppTypography.ui(
                color: colors.textSecondary,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EPaymentsError extends StatelessWidget {
  const _EPaymentsError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(PhosphorIcons.warning, size: 40, color: colors.danger),
            const SizedBox(height: 12),
            Text(
              'Couldn\'t load payment methods.',
              style: AppTypography.ui(
                color: colors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// --- CASH: amount tendered, with an exact-amount shortcut ---------------

/// Root-level single Cash tender: how much the customer physically
/// handed over, with a live-formatted amount field, a one-tap "Exact
/// amount" shortcut for the common case where the customer pays exactly
/// what's owed, and a change-due readout once a valid amount is in.
class _CashScreen extends ConsumerStatefulWidget {
  const _CashScreen();

  @override
  ConsumerState<_CashScreen> createState() => _CashScreenState();
}

class _CashScreenState extends ConsumerState<_CashScreen> {
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    final existing = ref.read(paymentControllerProvider).cashAmountTendered;
    _amountController = TextEditingController(
      text: existing == null ? '' : formatAmountForField(existing),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final total = ref.watch(dashboardControllerProvider).total;
    final paymentState = ref.watch(paymentControllerProvider);
    final notifier = ref.read(paymentControllerProvider.notifier);
    final changeDue = paymentState.cashChangeDue(total);
    final tendered = paymentState.cashAmountTendered;
    final isShort = tendered != null && tendered - total < -0.01;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Amount tendered',
            style: AppTypography.ui(
              color: colors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: primaryTapTarget + 8,
            child: TextField(
              controller: _amountController,
              autofocus: true,
              textAlign: TextAlign.right,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: const [AmountInputFormatter()],
              style: AppTypography.display(
                color: colors.textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                prefixText: '₱ ',
                filled: true,
                fillColor: colors.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (text) {
                notifier.setCashAmountTendered(parseAmountField(text));
              },
            ),
          ),
          const SizedBox(height: 14),
          // One-tap exact-amount shortcut — the dominant real-world
          // case is a customer handing over precisely what's owed, and
          // typing that figure out digit by digit on a touch keyboard
          // is pure friction for something this common.
          SizedBox(
            width: double.infinity,
            height: primaryTapTarget,
            child: OutlinedButton(
              onPressed: () {
                notifier.setCashExactAmount(total);
                _amountController.text = formatAmountForField(total);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.primary,
                side: BorderSide(color: colors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'EXACT AMOUNT (₱${formatAmountForField(total)})',
                style: AppTypography.ui(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: changeDue != null
                  ? colors.primaryContainer
                  : colors.surfaceVariant,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              changeDue != null
                  ? (changeDue < 0.01
                        ? 'No change due'
                        : 'Change due: ₱${formatAmountForField(changeDue)}')
                  : isShort
                  ? 'Short by ₱${formatAmountForField(total - tendered!)}'
                  : 'Enter the amount the customer is paying with.',
              textAlign: TextAlign.center,
              style: AppTypography.ui(
                color: changeDue != null
                    ? colors.primary
                    : isShort
                    ? colors.danger
                    : colors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: primaryTapTarget,
            child: ElevatedButton(
              onPressed: paymentState.cashIsReadyToConfirm(total)
                  ? () {
                      notifier.reset();
                      Navigator.of(context).pop();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.teal500,
                foregroundColor: colors.onPrimary,
                disabledBackgroundColor: colors.disabledFill,
                disabledForegroundColor: colors.textDisabled,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'Confirm payment',
                style: AppTypography.ui(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// --- SPLIT PAYMENT: choose CASH+E-PAYMENT or E-PAYMENT+E-PAYMENT --------

class _SplitChoiceOptions extends ConsumerWidget {
  const _SplitChoiceOptions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(paymentControllerProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _CubeButton(
              label: 'Cash + E-Payment',
              subtitle: 'One cash tender, one E-payment tender',
              icon: PhosphorIcons.moneyWavy,
              onTap: () => notifier.chooseSplitKind(SplitKind.cashAndEPayment),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: _CubeButton(
              label: 'E-Payment + E-Payment',
              subtitle: 'Two separate E-payment tenders',
              icon: PhosphorIcons.deviceMobile,
              onTap: () =>
                  notifier.chooseSplitKind(SplitKind.ePaymentAndEPayment),
            ),
          ),
        ],
      ),
    );
  }
}

/// --- Split slot layouts ----------------------------------------------

/// Renders the two slots for whichever split kind is active, plus a
/// remaining/settled banner and the Confirm button.
class _SplitLayout extends ConsumerWidget {
  const _SplitLayout({required this.kind});

  final SplitKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final total = ref.watch(dashboardControllerProvider).total;
    final paymentState = ref.watch(paymentControllerProvider);
    final notifier = ref.read(paymentControllerProvider.notifier);
    final remaining = total - paymentState.splitAssignedTotal;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Side-by-side, not stacked — the modal is wide enough now
          // (sized for a 14" landscape terminal) that laying both
          // tenders out horizontally keeps every field within a short
          // reach and avoids a tall, scroll-heavy column of two full
          // dropdown+reference+amount blocks.
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: kind == SplitKind.cashAndEPayment
                      ? _CashRow(total: total)
                      : const _EPaymentBlock(index: 0, title: 'E-Payment 1'),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _EPaymentBlock(
                    index: 1,
                    title: kind == SplitKind.cashAndEPayment
                        ? 'E-Payment'
                        : 'E-Payment 2',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _RemainingBanner(remaining: remaining),
          if (!paymentState.isSplitReady &&
              paymentState.splitSlots[0].method != null &&
              paymentState.splitSlots[1].method != null &&
              paymentState.splitSlots[0].method ==
                  paymentState.splitSlots[1].method) ...[
            const SizedBox(height: 14),
            _WarningBanner(
              text: 'Choose two different E-payment methods for the split.',
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: primaryTapTarget,
            child: ElevatedButton(
              onPressed: paymentState.splitIsReadyToConfirm(total)
                  ? () {
                      notifier.reset();
                      Navigator.of(context).pop();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.teal500,
                foregroundColor: colors.onPrimary,
                disabledBackgroundColor: colors.disabledFill,
                disabledForegroundColor: colors.textDisabled,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'Confirm payment',
                style: AppTypography.ui(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The fixed Cash row for the Cash+E-Payment split: label on the left
/// (not a dropdown — Cash is the only thing this slot can ever be),
/// amount field on the right, per the "Cash with amount on its right"
/// layout.
class _CashRow extends ConsumerStatefulWidget {
  const _CashRow({required this.total});

  final double total;

  @override
  ConsumerState<_CashRow> createState() => _CashRowState();
}

class _CashRowState extends ConsumerState<_CashRow> {
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    final existing = ref.read(paymentControllerProvider).splitSlots[0].amount;
    _amountController = TextEditingController(
      text: existing == null ? '' : formatAmountForField(existing),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final notifier = ref.read(paymentControllerProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cash',
            style: AppTypography.ui(
              color: colors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          // Cash's fixed identity, shown the same way a dropdown would
          // show a picked value — reinforces that this slot has nothing
          // to choose, only an amount to enter.
          Container(
            height: primaryTapTarget,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(PhosphorIcons.money, size: 24, color: colors.primary),
                const SizedBox(width: 12),
                Text(
                  'Cash',
                  style: AppTypography.ui(
                    color: colors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Amount, on its own full-width row to its right of the
          // implicit "Cash" label above — per the cash-slot layout: the
          // method reads first, its amount follows immediately after.
          SizedBox(
            width: double.infinity,
            height: primaryTapTarget,
            child: TextField(
              controller: _amountController,
              textAlign: TextAlign.right,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: const [AmountInputFormatter()],
              style: AppTypography.ui(
                color: colors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                prefixText: '₱ ',
                labelText: 'Amount',
                filled: true,
                fillColor: colors.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (text) {
                notifier.setSplitSlotAmount(0, parseAmountField(text));
              },
            ),
          ),
          const SizedBox(height: 12),
          // Auto-fills whatever's left of the charge total after the
          // other (E-payment) slot, so a cashier taking exact cash
          // doesn't have to type the figure out digit by digit on a
          // touch keyboard — the most common cash case by far is
          // "customer hands over exactly what's owed on this slot".
          SizedBox(
            width: double.infinity,
            height: primaryTapTarget,
            child: OutlinedButton(
              onPressed: () {
                notifier.fillRemainingAmount(0, widget.total);
                final updated = ref
                    .read(paymentControllerProvider)
                    .splitSlots[0]
                    .amount;
                _amountController.text = updated == null
                    ? ''
                    : formatAmountForField(updated);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.primary,
                side: BorderSide(color: colors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'EXACT AMOUNT',
                style: AppTypography.ui(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One E-payment split block: method dropdown, Reference ID, Amount.
/// Used for the single E-payment slot in Cash+E-Payment (`index: 1`) and
/// for both slots in E-Payment+E-Payment (`index: 0` and `index: 1`).
class _EPaymentBlock extends ConsumerStatefulWidget {
  const _EPaymentBlock({required this.index, required this.title});

  final int index;
  final String title;

  @override
  ConsumerState<_EPaymentBlock> createState() => _EPaymentBlockState();
}

class _EPaymentBlockState extends ConsumerState<_EPaymentBlock> {
  late final TextEditingController _amountController;
  late final TextEditingController _referenceController;

  @override
  void initState() {
    super.initState();
    final slot = ref.read(paymentControllerProvider).splitSlots[widget.index];
    _amountController = TextEditingController(
      text: slot.amount == null ? '' : formatAmountForField(slot.amount!),
    );
    _referenceController = TextEditingController(text: slot.referenceId ?? '');
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final notifier = ref.read(paymentControllerProvider.notifier);
    final ePaymentMethods = ref.watch(ePaymentMethodsProvider);

    final slot = ref.watch(
      paymentControllerProvider.select((s) => s.splitSlots[widget.index]),
    );
    // The other slot's method, when both slots are free E-payment
    // choices (E-Payment + E-Payment) — excluded from this dropdown so
    // the two slots can't both be pushed onto the same E-payment method.
    // Not relevant for the Cash+E-Payment shape (slot 0 is fixed Cash,
    // never an E-payment), so this only filters anything out when both
    // slots are genuinely E-payment slots.
    final otherMethod = ref.watch(
      paymentControllerProvider.select(
        (s) => s.splitSlots[widget.index == 0 ? 1 : 0].method,
      ),
    );
    final availableMethods = ePaymentMethods
        .where(
          (m) => otherMethod == null || otherMethod.isCash || m != otherMethod,
        )
        .toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: AppTypography.ui(
              color: colors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: primaryTapTarget,
            child: DropdownButtonFormField<PaymentMethod>(
              initialValue:
                  slot.method != null && availableMethods.contains(slot.method)
                  ? slot.method
                  : null,
              hint: const Text('Choose E-payment method'),
              isExpanded: true,
              style: AppTypography.ui(color: colors.textPrimary, fontSize: 16),
              decoration: InputDecoration(
                filled: true,
                fillColor: colors.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: [
                for (final method in availableMethods)
                  DropdownMenuItem(value: method, child: Text(method.label)),
              ],
              onChanged: (method) {
                if (method != null) {
                  notifier.setSplitSlotMethod(widget.index, method);
                  // A fresh method means the old reference id no longer
                  // applies — clear the field to match the controller
                  // clearing it in state.
                  _referenceController.clear();
                }
              },
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: primaryTapTarget,
            child: TextField(
              controller: _referenceController,
              style: AppTypography.ui(color: colors.textPrimary, fontSize: 16),
              decoration: InputDecoration(
                labelText: 'Reference ID',
                filled: true,
                fillColor: colors.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (text) =>
                  notifier.setSplitSlotReferenceId(widget.index, text),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: primaryTapTarget,
            child: TextField(
              controller: _amountController,
              textAlign: TextAlign.right,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: const [AmountInputFormatter()],
              style: AppTypography.ui(
                color: colors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                prefixText: '₱ ',
                labelText: 'Amount',
                filled: true,
                fillColor: colors.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (text) {
                notifier.setSplitSlotAmount(
                  widget.index,
                  parseAmountField(text),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Stacked below the amount field rather than squeezed beside
          // it — in the now-narrower Expanded column this keeps REST at
          // full tap-target width instead of shrinking it to fit next
          // to the field.
          SizedBox(
            width: double.infinity,
            height: primaryTapTarget,
            child: OutlinedButton(
              onPressed: () {
                ref
                    .read(paymentControllerProvider.notifier)
                    .fillRemainingAmount(
                      widget.index,
                      ref.read(dashboardControllerProvider).total,
                    );
                final updated = ref
                    .read(paymentControllerProvider)
                    .splitSlots[widget.index]
                    .amount;
                _amountController.text = updated == null
                    ? ''
                    : formatAmountForField(updated);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.primary,
                side: BorderSide(color: colors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'FILL REMAINING',
                style: AppTypography.ui(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// --- Shared small banners --------------------------------------------

class _RemainingBanner extends StatelessWidget {
  const _RemainingBanner({required this.remaining});

  final double remaining;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isSettled = remaining.abs() < 0.01;
    final isOver = remaining < -0.01;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isSettled ? colors.primaryContainer : colors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        isSettled
            ? 'Fully covered'
            : isOver
            ? 'Over by ₱${formatAmountForField(-remaining)}'
            : 'Remaining: ₱${formatAmountForField(remaining)}',
        textAlign: TextAlign.center,
        style: AppTypography.ui(
          color: isSettled
              ? colors.primary
              : isOver
              ? colors.danger
              : colors.textSecondary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: colors.danger.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.danger.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(PhosphorIcons.warning, size: 22, color: colors.danger),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTypography.ui(color: colors.danger, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
