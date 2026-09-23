// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/payment_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/core/database/providers/payments_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/daos/pos_detail_id_dao.dart'
    show PosDetailIdUnavailableException;
import '../../controllers/dashboard_controller.dart';
import '../../controllers/payments_controller.dart';
import 'package:gpos_provantis/src/core/printutil/receipt_generator.dart'
    show ReceiptGenerator, ReceiptPrintException;
import 'amount_input_formatter.dart';
import 'amount_numpad.dart';
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
          // being squeezed into a narrow column. Widened from the
          // original 860 once the amount-entry steps gained a fixed
          // numpad rail (see _NumpadRail, now 380px) — without the
          // extra width, the two side-by-side blocks on the split
          // screens would be left with too little room once the rail
          // and its own padding come out of the total. maxHeight is
          // clamped against whatever room is left once the keyboard
          // (if any) and the dialog's own inset padding are accounted
          // for, so it shrinks to fit rather than overflowing off-screen.
          constraints: BoxConstraints(
            maxWidth: 1160,
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
      case PaymentStep.ePaymentConfirm:
        return 'Confirm payment';
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
      case PaymentStep.ePaymentConfirm:
        return const _EPaymentConfirmScreen();
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
              onTap: () => notifier.selectEPaymentMethod(method),
            );
          },
        );
      },
    );
  }
}

/// --- E-PAYMENT CONFIRM: single method, reference id, full total ---------
///
/// Reached by tapping a tile on `_EPaymentsList` — `selectedMethod` is
/// already set by that tap (see `PaymentController.selectEPaymentMethod`)
/// before this screen ever builds. No amount field: a single E-payment
/// tender is always the full charge total, there's no tendered/change
/// concept the way Cash has. Styling (field decoration, button) mirrors
/// `_CashScreen` and `_EPaymentBlock`'s Reference ID field for visual
/// consistency across the modal's screens.
class _EPaymentConfirmScreen extends ConsumerStatefulWidget {
  const _EPaymentConfirmScreen();

  @override
  ConsumerState<_EPaymentConfirmScreen> createState() =>
      _EPaymentConfirmScreenState();
}

class _EPaymentConfirmScreenState
    extends ConsumerState<_EPaymentConfirmScreen> {
  late final TextEditingController _referenceController;

  @override
  void initState() {
    super.initState();
    final existing = ref
        .read(paymentControllerProvider)
        .singleEPaymentReferenceId;
    _referenceController = TextEditingController(text: existing ?? '');
  }

  @override
  void dispose() {
    _referenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final total = ref.watch(dashboardControllerProvider).total;
    final paymentState = ref.watch(paymentControllerProvider);
    final notifier = ref.read(paymentControllerProvider.notifier);
    final method = paymentState.selectedMethod;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              '${method?.label ?? ''} — ₱${formatAmountForField(total)}',
              textAlign: TextAlign.center,
              style: AppTypography.ui(
                color: colors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Reference ID',
            style: AppTypography.ui(
              color: colors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
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
              onChanged: notifier.setSingleEPaymentReferenceId,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: primaryTapTarget,
            child: ElevatedButton(
              onPressed: paymentState.singleEPaymentIsReadyToConfirm
                  ? () async {
                      try {
                        await ref
                            .read(dashboardControllerProvider.notifier)
                            .createSaleFromEPayment(paymentState);
                      } on PosDetailIdUnavailableException catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.message)));
                        }
                        return;
                      } on PosIdentityUnavailableException catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.message)));
                        }
                        return;
                      } on ReceiptPrintException catch (e) {
                        // Sale is already saved by this point — only
                        // printing failed, so warn but still close out
                        // the modal below rather than blocking the
                        // cashier from starting the next sale.
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.message)));
                        }
                      }
                      notifier.reset();
                      if (context.mounted) Navigator.of(context).pop();
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

  // canRequestFocus: false is the actual fix for the numpad-only input
  // model — without it, tapping the readOnly field still hands it real
  // platform text-input focus, and on Android/Windows that focus can
  // both summon the OS keyboard AND race with/clobber the numpad's own
  // controller.value writes as the platform IME syncs back against a
  // field it thinks it owns. A non-focusable FocusNode keeps the field
  // interactive (onTap still fires, cursor still shows) without ever
  // handing it real input focus.
  final FocusNode _amountFocusNode = FocusNode(canRequestFocus: false);

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
    _amountFocusNode.dispose();
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

    // Split into a scrollable left column (everything except the
    // numpad) and a fixed-width numpad rail on the right that's part of
    // this Row, not the ScrollView — so it never scrolls out of view no
    // matter how tall the left side gets. This mirrors how a physical
    // POS terminal's numeric pad is a fixed panel, not something that
    // moves around with the receipt above it.
    //
    // The outer modal Column sizes itself to content (mainAxisSize.min)
    // so steps like the root cubes don't force the dialog to its full
    // maxHeight — but that means a bare Row here, under a loose
    // Flexible, would have no intrinsic height to stretch its
    // CrossAxisAlignment.stretch children into and could collapse.
    // ConstrainedBox with a sensible minHeight gives it one, without
    // forcing every other step to the same fixed height.
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 620),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                      focusNode: _amountFocusNode,
                      // readOnly stops Android/Windows from summoning the
                      // OS soft keyboard on focus — all input for this
                      // field comes from the AmountNumpad rail instead.
                      // showCursor keeps it looking and feeling like a
                      // live, editable field. focusNode above additionally
                      // stops the field from ever taking real platform
                      // focus at all (see _amountFocusNode's doc comment)
                      // — readOnly alone wasn't reliably enough to keep
                      // the OS keyboard and IME fully out of the picture.
                      readOnly: true,
                      showCursor: true,
                      textAlign: TextAlign.right,
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
                    ),
                  ),
                  const SizedBox(height: 16),
                  // One-tap exact-amount shortcut — the dominant
                  // real-world case is a customer handing over precisely
                  // what's owed, and keying that figure in digit by digit
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
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
                          ? () async {
                              try {
                                await ref
                                    .read(dashboardControllerProvider.notifier)
                                    .createSaleFromCash();
                              } on PosDetailIdUnavailableException catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.message)),
                                  );
                                }
                                return;
                              } on PosIdentityUnavailableException catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.message)),
                                  );
                                }
                                return;
                              } on ReceiptPrintException catch (e) {
                                // Sale is already saved — only printing
                                // failed. Warn, but still close out the
                                // modal below.
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.message)),
                                  );
                                }
                              }
                              notifier.reset();
                              if (context.mounted) Navigator.of(context).pop();
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
            ),
          ),
          _NumpadRail(
            controller: _amountController,
            onChanged: notifier.setCashAmountTendered,
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
/// Owns both split slots' amount controllers and tracks which one is
/// currently "active" (last tapped) — the on-screen numpad below the
/// two blocks always drives whichever one that is. A ConsumerWidget
/// couldn't hold this: two amount fields are visible at once here, so
/// "which field does the shared numpad type into" is real state that
/// has to live above both fields, not inside either one individually.
class _SplitLayout extends ConsumerStatefulWidget {
  const _SplitLayout({required this.kind});

  final SplitKind kind;

  @override
  ConsumerState<_SplitLayout> createState() => _SplitLayoutState();
}

class _SplitLayoutState extends ConsumerState<_SplitLayout> {
  late final TextEditingController _slot0AmountController;
  late final TextEditingController _slot1AmountController;

  // canRequestFocus: false, same reasoning as _CashScreenState's
  // _amountFocusNode — stops these readOnly fields from ever taking
  // real platform text-input focus, which is what let the OS
  // keyboard/IME interfere with the numpad's own writes to the
  // controller. Owned here (not inside _CashRow/_EPaymentBlock) for the
  // same reason the controllers are: FocusNode needs a stable
  // create-once/dispose-once lifecycle, which the stateless
  // _CashRow/_EPaymentBlock can't provide on their own.
  final FocusNode _slot0FocusNode = FocusNode(canRequestFocus: false);
  final FocusNode _slot1FocusNode = FocusNode(canRequestFocus: false);

  /// Which slot (0 or 1) the numpad is currently typing into. Starts on
  /// slot 0 so the numpad is immediately usable without an extra tap —
  /// the cashier's very first action on this screen is almost always
  /// entering the first slot's amount.
  int _activeSlot = 0;

  @override
  void initState() {
    super.initState();
    final slots = ref.read(paymentControllerProvider).splitSlots;
    _slot0AmountController = TextEditingController(
      text: slots[0].amount == null
          ? ''
          : formatAmountForField(slots[0].amount!),
    );
    _slot1AmountController = TextEditingController(
      text: slots[1].amount == null
          ? ''
          : formatAmountForField(slots[1].amount!),
    );
  }

  @override
  void dispose() {
    _slot0AmountController.dispose();
    _slot1AmountController.dispose();
    _slot0FocusNode.dispose();
    _slot1FocusNode.dispose();
    super.dispose();
  }

  TextEditingController get _activeController =>
      _activeSlot == 0 ? _slot0AmountController : _slot1AmountController;

  void _handleNumpadChanged(double? amount) {
    ref
        .read(paymentControllerProvider.notifier)
        .setSplitSlotAmount(_activeSlot, amount);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final total = ref.watch(dashboardControllerProvider).total;
    final paymentState = ref.watch(paymentControllerProvider);
    final notifier = ref.read(paymentControllerProvider.notifier);
    final remaining = total - paymentState.splitAssignedTotal;

    // Same fixed-rail shape as _CashScreen: a scrollable left column for
    // the two slot blocks + banners + confirm, and a numpad rail on the
    // right that stays put regardless of how tall the left side gets.
    // Both slots share the one rail — which slot it currently drives is
    // shown by the label above the numpad and by the highlighted border
    // on whichever block is active (see _CashRow/_EPaymentBlock's
    // isActive). Wrapped in a minHeight ConstrainedBox for the same
    // reason _CashScreen is — see that screen's build() for why a bare
    // Row here could otherwise collapse under a loose Flexible.
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 620),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Side-by-side, not stacked — the modal is wide enough
                  // now (sized for a 14" landscape terminal) that laying
                  // both tenders out horizontally keeps every field
                  // within a short reach and avoids a tall, scroll-heavy
                  // column of two full dropdown+reference+amount blocks.
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: widget.kind == SplitKind.cashAndEPayment
                              ? _CashRow(
                                  total: total,
                                  amountController: _slot0AmountController,
                                  amountFocusNode: _slot0FocusNode,
                                  isActive: _activeSlot == 0,
                                  onActivate: () =>
                                      setState(() => _activeSlot = 0),
                                )
                              : _EPaymentBlock(
                                  index: 0,
                                  title: 'E-Payment 1',
                                  amountController: _slot0AmountController,
                                  amountFocusNode: _slot0FocusNode,
                                  isActive: _activeSlot == 0,
                                  onActivate: () =>
                                      setState(() => _activeSlot = 0),
                                ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _EPaymentBlock(
                            index: 1,
                            title: widget.kind == SplitKind.cashAndEPayment
                                ? 'E-Payment'
                                : 'E-Payment 2',
                            amountController: _slot1AmountController,
                            amountFocusNode: _slot1FocusNode,
                            isActive: _activeSlot == 1,
                            onActivate: () => setState(() => _activeSlot = 1),
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
                      text:
                          'Choose two different E-payment methods for the split.',
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: primaryTapTarget,
                    child: ElevatedButton(
                      onPressed: paymentState.splitIsReadyToConfirm(total)
                          ? () async {
                              // Only Cash + one E-payment is wired up to
                              // actually create a sale right now —
                              // E-payment + E-payment isn't handled yet
                              // (see DashboardController's "SALE
                              // CREATION" doc comment).
                              if (paymentState.splitKind ==
                                  SplitKind.cashAndEPayment) {
                                try {
                                  await ref
                                      .read(
                                        dashboardControllerProvider.notifier,
                                      )
                                      .createSaleFromCashEPaymentSplit(
                                        paymentState,
                                      );
                                } on PosDetailIdUnavailableException catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.message)),
                                    );
                                  }
                                  return;
                                } on PosIdentityUnavailableException catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.message)),
                                    );
                                  }
                                  return;
                                } on ReceiptPrintException catch (e) {
                                  // Sale is already saved — only
                                  // printing failed. Warn, but still
                                  // close out the modal below.
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.message)),
                                    );
                                  }
                                }
                              }
                              notifier.reset();
                              if (context.mounted) Navigator.of(context).pop();
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
            ),
          ),
          _NumpadRail(
            controller: _activeController,
            onChanged: _handleNumpadChanged,
            // Only the split rail needs this label — with two live
            // amount fields on screen, the cashier needs an explicit,
            // always-visible answer to "which one am I about to type
            // into", not just the tapped field's highlighted border
            // (easy to miss at a glance, especially right after
            // switching).
            activeSlotLabel: _activeSlot == 0
                ? (widget.kind == SplitKind.cashAndEPayment
                      ? 'Typing into: Cash'
                      : 'Typing into: E-Payment 1')
                : (widget.kind == SplitKind.cashAndEPayment
                      ? 'Typing into: E-Payment'
                      : 'Typing into: E-Payment 2'),
          ),
        ],
      ),
    );
  }
}

/// The fixed Cash row for the Cash+E-Payment split: label on the left
/// (not a dropdown — Cash is the only thing this slot can ever be),
/// amount field on the right, per the "Cash with amount on its right"
/// layout. The amount field's controller and numpad-activation are
/// owned by the parent `_SplitLayout` (see `_activeController` there),
/// not by this widget, since the numpad is shared across both slots.
class _CashRow extends ConsumerWidget {
  const _CashRow({
    required this.total,
    required this.amountController,
    required this.amountFocusNode,
    required this.isActive,
    required this.onActivate,
  });

  final double total;
  final TextEditingController amountController;
  final FocusNode amountFocusNode;
  final bool isActive;
  final VoidCallback onActivate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isActive ? colors.primary : colors.border,
          width: isActive ? 2 : 1.5,
        ),
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
          // Tapping the field is what tells the shared numpad below to
          // start driving this slot instead of the other one, via
          // TextField's own onTap — no wrapping GestureDetector needed
          // (and one caused real problems: stacking a GestureDetector
          // around a TextField makes both compete to handle the same
          // tap, and depending on hit-test order, that could either
          // swallow the tap before onActivate ran or let the field
          // slip past readOnly and grab real platform focus anyway).
          // amountFocusNode (canRequestFocus: false, owned by
          // _SplitLayoutState) is what actually guarantees this field
          // can never take real text-input focus, keeping it fully
          // numpad-driven instead of racing with the OS keyboard/IME.
          SizedBox(
            width: double.infinity,
            height: primaryTapTarget,
            child: TextField(
              controller: amountController,
              focusNode: amountFocusNode,
              readOnly: true,
              showCursor: true,
              onTap: onActivate,
              textAlign: TextAlign.right,
              style: AppTypography.ui(
                color: colors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                prefixText: '₱ ',
                labelText: 'Amount',
                filled: true,
                fillColor: isActive
                    ? colors.primaryContainer.withValues(alpha: 0.4)
                    : colors.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Auto-fills whatever's left of the charge total after the
          // other (E-payment) slot, so a cashier taking exact cash
          // doesn't have to key the figure in for something this
          // common: the customer handing over exactly what's owed on
          // this slot.
          SizedBox(
            width: double.infinity,
            height: primaryTapTarget,
            child: OutlinedButton(
              onPressed: () {
                onActivate();
                ref
                    .read(paymentControllerProvider.notifier)
                    .fillRemainingAmount(0, total);
                final updated = ref
                    .read(paymentControllerProvider)
                    .splitSlots[0]
                    .amount;
                amountController.text = updated == null
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
/// The amount field's controller and numpad-activation are owned by the
/// parent `_SplitLayout`; this widget still owns its own Reference ID
/// controller, since that field isn't numpad-driven and each block's
/// reference text is genuinely independent of the other's.
class _EPaymentBlock extends ConsumerStatefulWidget {
  const _EPaymentBlock({
    required this.index,
    required this.title,
    required this.amountController,
    required this.amountFocusNode,
    required this.isActive,
    required this.onActivate,
  });

  final int index;
  final String title;
  final TextEditingController amountController;
  final FocusNode amountFocusNode;
  final bool isActive;
  final VoidCallback onActivate;

  @override
  ConsumerState<_EPaymentBlock> createState() => _EPaymentBlockState();
}

class _EPaymentBlockState extends ConsumerState<_EPaymentBlock> {
  late final TextEditingController _referenceController;

  @override
  void initState() {
    super.initState();
    final slot = ref.read(paymentControllerProvider).splitSlots[widget.index];
    _referenceController = TextEditingController(text: slot.referenceId ?? '');
  }

  @override
  void dispose() {
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
        border: Border.all(
          color: widget.isActive ? colors.primary : colors.border,
          width: widget.isActive ? 2 : 1.5,
        ),
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
          // readOnly + tap-to-activate, same as the Cash slot's amount
          // field — this field's actual input comes from the shared
          // numpad below both blocks, keyed to whichever slot was last
          // tapped (see _SplitLayoutState._activeSlot). No wrapping
          // GestureDetector (TextField.onTap already fires reliably on
          // its own, and stacking one around a TextField only creates a
          // tap-handling race); amountFocusNode (canRequestFocus: false)
          // is what actually stops this field from taking real platform
          // focus — see the matching comment in _CashRow for the full
          // reasoning.
          SizedBox(
            width: double.infinity,
            height: primaryTapTarget,
            child: TextField(
              controller: widget.amountController,
              focusNode: widget.amountFocusNode,
              readOnly: true,
              showCursor: true,
              onTap: widget.onActivate,
              textAlign: TextAlign.right,
              style: AppTypography.ui(
                color: colors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                prefixText: '₱ ',
                labelText: 'Amount',
                filled: true,
                fillColor: widget.isActive
                    ? colors.primaryContainer.withValues(alpha: 0.4)
                    : colors.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Stacked below the amount field rather than squeezed beside
          // it — in the now-narrower Expanded column this keeps FILL
          // REMAINING at full tap-target width instead of shrinking it
          // to fit next to the field.
          SizedBox(
            width: double.infinity,
            height: primaryTapTarget,
            child: OutlinedButton(
              onPressed: () {
                widget.onActivate();
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
                widget.amountController.text = updated == null
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

/// --- Numpad rail ---------------------------------------------------

/// A fixed-width panel that pins an `AmountNumpad` to the right edge of
/// whichever screen hosts it, outside that screen's own scrollable
/// content. It never scrolls — the numpad is a permanent part of the
/// layout the same way a physical POS terminal's number pad is a fixed
/// panel, not something that moves around depending on how much other
/// content is above it. A vertical divider marks the boundary so the
/// two regions (scrollable content vs. fixed numpad) read as distinct
/// even though they share one background color.
class _NumpadRail extends StatelessWidget {
  const _NumpadRail({
    required this.controller,
    required this.onChanged,
    this.activeSlotLabel,
  });

  final TextEditingController controller;
  final ValueChanged<double?> onChanged;

  /// Optional header text shown above the numpad — used on the split
  /// screens, where two amount fields are visible at once, to make
  /// "which one is this numpad about to type into" unambiguous even
  /// before the cashier looks closely at which block has the
  /// highlighted border. Omitted on single-field screens (like
  /// _CashScreen) where there's nothing to disambiguate.
  final String? activeSlotLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      // Widened from the original 320 — the numpad itself now fills
      // whatever width/height this rail gives it (see AmountNumpad),
      // so a narrow rail directly limited how large each key could be.
      // 380 keeps keys comfortably above the touch-target floor even
      // accounting for the rail's own padding and the gaps between
      // keys.
      width: 380,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceVariant.withValues(alpha: 0.3),
        border: Border(left: BorderSide(color: colors.borderSubtle)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (activeSlotLabel != null) ...[
            Text(
              activeSlotLabel!,
              textAlign: TextAlign.center,
              style: AppTypography.ui(
                color: colors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
          ],
          // Expanded, not just placed in the Column, so the numpad
          // claims all the rail's remaining height (the label above
          // takes only what it needs) rather than sizing to its own
          // minimum and leaving empty space above/below it — that gap
          // was exactly what made the numpad look small before.
          Expanded(
            child: AmountNumpad(controller: controller, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}
