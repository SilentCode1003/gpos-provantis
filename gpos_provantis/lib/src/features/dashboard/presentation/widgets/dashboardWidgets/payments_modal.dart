import 'package:flutter/foundation.dart' show debugPrint;
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
import 'package:gpos_provantis/src/core/database/daos/duplicate_detail_id_exception.dart';
import 'amount_input_formatter.dart';
import 'amount_numpad.dart';
import 'dashboard_constants.dart';

Future<void> showPaymentModal(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _PaymentModal(),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Phone sizing
//
// Below the dashboard's split breakpoint the payment flow is a full-screen
// page instead of a centered dialog, and every screen stacks vertically: the
// numpad sits under the form instead of beside it. Wide layouts are unchanged.
// ─────────────────────────────────────────────────────────────────────────────

bool _isNarrow(BuildContext context) =>
    MediaQuery.sizeOf(context).width < splitLayoutBreakpoint;

/// Outer padding of the payment screens: 28 on tablets, 20 on phones.
double _bodyPadding(BuildContext context) => _isNarrow(context) ? 20 : 28;

/// Height of the numpad block under the form on a phone. Four rows of keys.
const double _phoneNumpadHeight = 264;

/// Field and button height inside the compact (phone) split blocks.
const double _compactFieldHeight = 60;

/// Runs a sale for all three confirm buttons: takes the submit lock, shows
/// the right message if it fails, and closes the modal once the sale is saved.
Future<void> _submitPayment({
  required BuildContext context,
  required WidgetRef ref,
  required Future<void> Function() createSale,
}) async {
  final notifier = ref.read(paymentControllerProvider.notifier);
  if (!notifier.beginSubmit()) return;

  void toast(String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  var saleRecorded = false;
  try {
    await createSale();
    saleRecorded = true;
  } on ReceiptPrintException catch (e) {
    // The sale is saved; only the receipt failed to print.
    saleRecorded = true;
    toast(e.message);
  } on SaleAlreadyInProgressException {
    // Another submit owns the sale; nothing more to do.
  } on EmptyCartException catch (e) {
    toast(e.message);
  } on DuplicateDetailIdException {
    toast('That receipt number was already used. Please confirm again.');
  } on PosDetailIdUnavailableException catch (e) {
    toast(e.message);
  } on PosIdentityUnavailableException catch (e) {
    toast(e.message);
  } catch (e, st) {
    debugPrint('Payment failed: $e\n$st');
    toast('Payment could not be completed. Please try again.');
  }

  if (saleRecorded) {
    notifier.reset();
    if (context.mounted) Navigator.of(context).pop();
  } else {
    notifier.endSubmit();
  }
}

class _ConfirmButtonLabel extends StatelessWidget {
  const _ConfirmButtonLabel({required this.isSubmitting});

  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    if (isSubmitting) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: context.colors.onPrimary,
        ),
      );
    }
    return Text(
      'Confirm payment',
      style: AppTypography.ui(fontSize: 17, fontWeight: FontWeight.w600),
    );
  }
}

/// The big green "Confirm payment" button. Same look on every screen; the
/// screens only differ in when it is enabled and what it runs.
class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.onPressed, required this.isSubmitting});

  final VoidCallback? onPressed;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      width: double.infinity,
      height: primaryTapTarget,
      child: ElevatedButton(
        onPressed: onPressed,
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
        child: _ConfirmButtonLabel(isSubmitting: isSubmitting),
      ),
    );
  }
}

class _PaymentModal extends ConsumerWidget {
  const _PaymentModal();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final step = ref.watch(paymentControllerProvider.select((s) => s.step));
    final isSubmitting = ref.watch(
      paymentControllerProvider.select((s) => s.isSubmitting),
    );

    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    // Phone: the payment flow takes over the whole screen.
    if (_isNarrow(context)) {
      return PopScope(
        // Don't let the system back button close the page mid-payment.
        canPop: !isSubmitting,
        child: Material(
          color: colors.surface,
          child: SizedBox.expand(
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(bottom: keyboardInset),
              // Ignore every tap (back, fields, numpad) while saving.
              child: IgnorePointer(
                ignoring: isSubmitting,
                child: Column(
                  children: [
                    _ModalHeader(step: step),
                    Expanded(child: _ModalBody(step: step)),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: PopScope(
        // Don't let the system back button close the modal mid-payment.
        canPop: !isSubmitting,
        child: Dialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          insetPadding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 1160,
              maxHeight:
                  (MediaQuery.sizeOf(context).height - keyboardInset - 64)
                      .clamp(320, 720),
            ),
            // Ignore every tap (back, close, fields, numpad) while saving.
            child: IgnorePointer(
              ignoring: isSubmitting,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ModalHeader(step: step),
                  Flexible(child: _ModalBody(step: step)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModalHeader extends ConsumerWidget {
  const _ModalHeader({required this.step});

  final PaymentStep step;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final total = ref.watch(dashboardControllerProvider.select((s) => s.total));
    final notifier = ref.read(paymentControllerProvider.notifier);
    final isRoot = step == PaymentStep.root;
    final narrow = _isNarrow(context);
    final buttonSize = narrow ? minTapTarget : primaryTapTarget;

    return Container(
      padding: narrow
          ? const EdgeInsets.fromLTRB(12, 10, 16, 10)
          : const EdgeInsets.fromLTRB(16, 16, 28, 16),
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
                width: buttonSize,
                height: buttonSize,
                child: Icon(
                  isRoot ? PhosphorIcons.x : PhosphorIcons.arrowLeft,
                  size: narrow ? 24 : 26,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),
          SizedBox(width: narrow ? 12 : 16),
          Expanded(
            child: Text(
              _titleFor(step),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.display(
                color: colors.textPrimary,
                fontSize: narrow ? 19 : 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '₱${formatAmountForField(total)}',
            style: AppTypography.display(
              color: colors.textPrimary,
              fontSize: narrow ? 20 : 22,
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

class _RootOptions extends ConsumerWidget {
  const _RootOptions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(paymentControllerProvider.notifier);

    // Phone: three wide rows instead of three squares side by side.
    if (_isNarrow(context)) {
      return ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _OptionRow(
            label: 'E-Payments',
            icon: PhosphorIcons.deviceMobile,
            onTap: notifier.openEPaymentsList,
          ),
          const SizedBox(height: 14),
          _OptionRow(
            label: 'Cash',
            icon: PhosphorIcons.money,
            onTap: notifier.openCash,
          ),
          const SizedBox(height: 14),
          _OptionRow(
            label: 'Split Payment',
            icon: PhosphorIcons.arrowsSplit,
            onTap: notifier.openSplitChoice,
          ),
        ],
      );
    }

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

/// Phone version of [_CubeButton]: a full-width row with the icon on the left
/// and a chevron on the right, so long labels like "E-Payment + E-Payment"
/// fit on one line.
class _OptionRow extends StatelessWidget {
  const _OptionRow({
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

    return Material(
      color: colors.surfaceVariant,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          constraints: const BoxConstraints(minHeight: 88),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.border, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 28, color: colors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.ui(
                        color: colors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        subtitle!,
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
              const SizedBox(width: 8),
              Icon(
                PhosphorIcons.caretRight,
                size: 18,
                color: colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EPaymentsList extends ConsumerWidget {
  const _EPaymentsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final notifier = ref.read(paymentControllerProvider.notifier);
    final narrow = _isNarrow(context);

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

        return GridView.builder(
          padding: EdgeInsets.all(_bodyPadding(context)),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            // Phone: two per row, a little wider than tall, so the labels
            // aren't squeezed into three narrow squares.
            crossAxisCount: narrow ? 2 : 3,
            mainAxisSpacing: narrow ? 14 : 20,
            crossAxisSpacing: narrow ? 14 : 20,
            childAspectRatio: narrow ? 1.1 : 1,
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
    final total = ref.watch(dashboardControllerProvider.select((s) => s.total));
    final paymentState = ref.watch(paymentControllerProvider);
    final notifier = ref.read(paymentControllerProvider.notifier);
    final method = paymentState.selectedMethod;

    return SingleChildScrollView(
      padding: EdgeInsets.all(_bodyPadding(context)),
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
          _ConfirmButton(
            isSubmitting: paymentState.isSubmitting,
            onPressed: paymentState.singleEPaymentIsReadyToConfirm
                ? () => _submitPayment(
                    context: context,
                    ref: ref,
                    createSale: () => ref
                        .read(dashboardControllerProvider.notifier)
                        .createSaleFromEPayment(paymentState),
                  )
                : null,
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

class _CashScreen extends ConsumerStatefulWidget {
  const _CashScreen();

  @override
  ConsumerState<_CashScreen> createState() => _CashScreenState();
}

class _CashScreenState extends ConsumerState<_CashScreen> {
  late final TextEditingController _amountController;

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
    final total = ref.watch(dashboardControllerProvider.select((s) => s.total));
    final paymentState = ref.watch(paymentControllerProvider);
    final notifier = ref.read(paymentControllerProvider.notifier);
    final changeDue = paymentState.cashChangeDue(total);
    final tendered = paymentState.cashAmountTendered;
    final isShort = tendered != null && tendered - total < -0.01;

    // Everything except the confirm button. On a tablet the button scrolls
    // with these; on a phone it is pinned under the numpad.
    final fields = <Widget>[
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
            style: AppTypography.ui(fontSize: 15, fontWeight: FontWeight.w600),
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
    ];

    final confirmButton = _ConfirmButton(
      isSubmitting: paymentState.isSubmitting,
      onPressed: paymentState.cashIsReadyToConfirm(total)
          ? () => _submitPayment(
              context: context,
              ref: ref,
              createSale: () => ref
                  .read(dashboardControllerProvider.notifier)
                  .createSaleFromCash(),
            )
          : null,
    );

    final numpad = _NumpadRail(
      controller: _amountController,
      onChanged: notifier.setCashAmountTendered,
    );

    // Phone: form on top (scrolls if the screen is short), numpad and the
    // confirm button pinned underneath.
    if (_isNarrow(context)) {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: fields,
              ),
            ),
          ),
          numpad,
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: confirmButton,
          ),
        ],
      );
    }

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
                  ...fields,
                  const SizedBox(height: 24),
                  confirmButton,
                ],
              ),
            ),
          ),
          numpad,
        ],
      ),
    );
  }
}

class _SplitChoiceOptions extends ConsumerWidget {
  const _SplitChoiceOptions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(paymentControllerProvider.notifier);

    if (_isNarrow(context)) {
      return ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _OptionRow(
            label: 'Cash + E-Payment',
            subtitle: 'One cash tender, one E-payment tender',
            icon: PhosphorIcons.moneyWavy,
            onTap: () => notifier.chooseSplitKind(SplitKind.cashAndEPayment),
          ),
          const SizedBox(height: 14),
          _OptionRow(
            label: 'E-Payment + E-Payment',
            subtitle: 'Two separate E-payment tenders',
            icon: PhosphorIcons.deviceMobile,
            onTap: () =>
                notifier.chooseSplitKind(SplitKind.ePaymentAndEPayment),
          ),
        ],
      );
    }

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

class _SplitLayout extends ConsumerStatefulWidget {
  const _SplitLayout({required this.kind});

  final SplitKind kind;

  @override
  ConsumerState<_SplitLayout> createState() => _SplitLayoutState();
}

class _SplitLayoutState extends ConsumerState<_SplitLayout> {
  late final TextEditingController _slot0AmountController;
  late final TextEditingController _slot1AmountController;

  final FocusNode _slot0FocusNode = FocusNode(canRequestFocus: false);
  final FocusNode _slot1FocusNode = FocusNode(canRequestFocus: false);

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

  /// Makes [slot] the one the numpad types into. Also drops focus from a
  /// reference-ID field, so on a phone the keyboard closes and the numpad
  /// comes back.
  void _activate(int slot) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _activeSlot = slot);
  }

  String get _slot0Title =>
      widget.kind == SplitKind.cashAndEPayment ? 'Cash' : 'E-Payment 1';

  String get _slot1Title =>
      widget.kind == SplitKind.cashAndEPayment ? 'E-Payment' : 'E-Payment 2';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final total = ref.watch(dashboardControllerProvider.select((s) => s.total));
    final paymentState = ref.watch(paymentControllerProvider);
    final remaining = total - paymentState.splitAssignedTotal;
    final narrow = _isNarrow(context);

    final slot0 = widget.kind == SplitKind.cashAndEPayment
        ? _CashRow(
            total: total,
            amountController: _slot0AmountController,
            amountFocusNode: _slot0FocusNode,
            isActive: _activeSlot == 0,
            onActivate: () => _activate(0),
            compact: narrow,
          )
        : _EPaymentBlock(
            index: 0,
            title: 'E-Payment 1',
            amountController: _slot0AmountController,
            amountFocusNode: _slot0FocusNode,
            isActive: _activeSlot == 0,
            onActivate: () => _activate(0),
            compact: narrow,
          );

    final slot1 = _EPaymentBlock(
      index: 1,
      title: widget.kind == SplitKind.cashAndEPayment
          ? 'E-Payment'
          : 'E-Payment 2',
      amountController: _slot1AmountController,
      amountFocusNode: _slot1FocusNode,
      isActive: _activeSlot == 1,
      onActivate: () => _activate(1),
      compact: narrow,
    );

    final confirmButton = _ConfirmButton(
      isSubmitting: paymentState.isSubmitting,
      onPressed: paymentState.splitIsReadyToConfirm(total)
          ? () => _submitPayment(
              context: context,
              ref: ref,
              // Both kinds of split create a sale; they differ
              // only in which payments are involved.
              createSale: () {
                final dashboard = ref.read(
                  dashboardControllerProvider.notifier,
                );
                return paymentState.splitKind == SplitKind.cashAndEPayment
                    ? dashboard.createSaleFromCashEPaymentSplit(paymentState)
                    : dashboard.createSaleFromEPaymentSplit(paymentState);
              },
            )
          : null,
    );

    final numpad = _NumpadRail(
      controller: _activeController,
      onChanged: _handleNumpadChanged,

      activeSlotLabel: _activeSlot == 0
          ? (widget.kind == SplitKind.cashAndEPayment
                ? 'Typing into: Cash'
                : 'Typing into: E-Payment 1')
          : (widget.kind == SplitKind.cashAndEPayment
                ? 'Typing into: E-Payment'
                : 'Typing into: E-Payment 2'),
    );

    // Phone: two tabs on top show both amounts and pick which tender is being
    // edited. Only that tender's fields are shown (the other stays alive but
    // takes no room), so the form and the numpad fit on one screen.
    if (narrow) {
      String amountOf(int index) {
        final amount = paymentState.splitSlots[index].amount;
        return amount == null ? 'Not set' : '₱${formatAmountForField(amount)}';
      }

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: _SlotTab(
                    title: _slot0Title,
                    amount: amountOf(0),
                    isActive: _activeSlot == 0,
                    onTap: () => _activate(0),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SlotTab(
                    title: _slot1Title,
                    amount: amountOf(1),
                    isActive: _activeSlot == 1,
                    onTap: () => _activate(1),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Offstage(offstage: _activeSlot != 0, child: slot0),
                  Offstage(offstage: _activeSlot != 1, child: slot1),
                  const SizedBox(height: 14),
                  _RemainingBanner(remaining: remaining),
                ],
              ),
            ),
          ),
          numpad,
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: confirmButton,
          ),
        ],
      );
    }

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
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: slot0),
                        const SizedBox(width: 20),
                        Expanded(child: slot1),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _RemainingBanner(remaining: remaining),
                  const SizedBox(height: 24),
                  confirmButton,
                ],
              ),
            ),
          ),
          numpad,
        ],
      ),
    );
  }
}

/// Phone split screen: a tab per tender showing its name and amount.
class _SlotTab extends StatelessWidget {
  const _SlotTab({
    required this.title,
    required this.amount,
    required this.isActive,
    required this.onTap,
  });

  final String title;
  final String amount;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: isActive
          ? colors.primaryContainer.withValues(alpha: 0.4)
          : colors.surfaceVariant,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: primaryTapTarget,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive ? colors.primary : colors.border,
              width: isActive ? 2 : 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.ui(
                  color: colors.textSecondary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                amount,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.ui(
                  color: colors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CashRow extends ConsumerWidget {
  const _CashRow({
    required this.total,
    required this.amountController,
    required this.amountFocusNode,
    required this.isActive,
    required this.onActivate,
    this.compact = false,
  });

  final double total;
  final TextEditingController amountController;
  final FocusNode amountFocusNode;
  final bool isActive;
  final VoidCallback onActivate;

  /// Phone version: no title or "Cash" chip (the tab above says it), and the
  /// exact-amount button sits beside the field instead of under it.
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    final amountField = TextField(
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );

    void fillExact() {
      onActivate();
      ref
          .read(paymentControllerProvider.notifier)
          .fillRemainingAmount(0, total);
      final updated = ref.read(paymentControllerProvider).splitSlots[0].amount;
      amountController.text = updated == null
          ? ''
          : formatAmountForField(updated);
    }

    if (compact) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isActive ? colors.primary : colors.border,
            width: isActive ? 2 : 1.5,
          ),
        ),
        child: SizedBox(
          height: _compactFieldHeight,
          child: Row(
            children: [
              Expanded(child: amountField),
              const SizedBox(width: 10),
              SizedBox(
                width: 112,
                child: OutlinedButton(
                  onPressed: fillExact,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.primary,
                    side: BorderSide(color: colors.primary, width: 1.5),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'EXACT AMOUNT',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: AppTypography.ui(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

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

          SizedBox(
            width: double.infinity,
            height: primaryTapTarget,
            child: amountField,
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: primaryTapTarget,
            child: OutlinedButton(
              onPressed: fillExact,
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

class _EPaymentBlock extends ConsumerStatefulWidget {
  const _EPaymentBlock({
    required this.index,
    required this.title,
    required this.amountController,
    required this.amountFocusNode,
    required this.isActive,
    required this.onActivate,
    this.compact = false,
  });

  final int index;
  final String title;
  final TextEditingController amountController;
  final FocusNode amountFocusNode;
  final bool isActive;
  final VoidCallback onActivate;

  /// Phone version: no title (the tab above says it), shorter fields, and the
  /// fill-remaining button sits beside the amount field.
  final bool compact;

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

  void _fillRemaining() {
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
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final notifier = ref.read(paymentControllerProvider.notifier);
    final ePaymentMethods = ref.watch(ePaymentMethodsProvider);
    final compact = widget.compact;
    final fieldHeight = compact ? _compactFieldHeight : primaryTapTarget;
    final gap = compact ? 12.0 : 14.0;

    final slot = ref.watch(
      paymentControllerProvider.select((s) => s.splitSlots[widget.index]),
    );

    // Same method is allowed in both slots, so no filtering against the other slot.
    final availableMethods = ePaymentMethods;

    final amountField = TextField(
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );

    return Container(
      padding: EdgeInsets.all(compact ? 16 : 20),
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
          if (!compact) ...[
            Text(
              widget.title,
              style: AppTypography.ui(
                color: colors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
          ],
          SizedBox(
            height: fieldHeight,
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

                  _referenceController.clear();
                }
              },
            ),
          ),
          SizedBox(height: gap),
          SizedBox(
            width: double.infinity,
            height: fieldHeight,
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
          SizedBox(height: gap),

          if (compact)
            SizedBox(
              height: fieldHeight,
              child: Row(
                children: [
                  Expanded(child: amountField),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 112,
                    child: OutlinedButton(
                      onPressed: _fillRemaining,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.primary,
                        side: BorderSide(color: colors.primary, width: 1.5),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'FILL REMAINING',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: AppTypography.ui(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else ...[
            SizedBox(
              width: double.infinity,
              height: primaryTapTarget,
              child: amountField,
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: primaryTapTarget,
              child: OutlinedButton(
                onPressed: _fillRemaining,
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
        ],
      ),
    );
  }
}

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

/// The numpad. A 380px column beside the form on a tablet; a fixed-height
/// block under the form on a phone (hidden while a text field has the
/// keyboard up, so the keyboard isn't fighting the numpad for room).
class _NumpadRail extends StatelessWidget {
  const _NumpadRail({
    required this.controller,
    required this.onChanged,
    this.activeSlotLabel,
  });

  final TextEditingController controller;
  final ValueChanged<double?> onChanged;

  final String? activeSlotLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (_isNarrow(context)) {
      if (MediaQuery.viewInsetsOf(context).bottom > 0) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: colors.surfaceVariant.withValues(alpha: 0.3),
          border: Border(top: BorderSide(color: colors.borderSubtle)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (activeSlotLabel != null) ...[
              Text(
                activeSlotLabel!,
                textAlign: TextAlign.center,
                style: AppTypography.ui(
                  color: colors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
            ],
            SizedBox(
              height: _phoneNumpadHeight,
              child: AmountNumpad(controller: controller, onChanged: onChanged),
            ),
          ],
        ),
      );
    }

    return Container(
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

          Expanded(
            child: AmountNumpad(controller: controller, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}
