import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/core/database/providers/user_data_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/repository/refund_repository.dart'
    show RefundOutcome, RefundStatus;
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/refunds_controller.dart';
import 'pos_form_sheet.dart';

class RefundSheet extends ConsumerStatefulWidget {
  const RefundSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showPosFormSheet(context, child: const RefundSheet());
  }

  @override
  ConsumerState<RefundSheet> createState() => _RefundSheetState();
}

class _RefundSheetState extends ConsumerState<RefundSheet> {
  final _orController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _descriptionFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _orController.addListener(_refresh);
    _descriptionController.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _orController.dispose();
    _descriptionController.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _orController.text.trim().isNotEmpty &&
      _descriptionController.text.trim().isNotEmpty;

  Future<void> _onSubmit() async {
    final detailId = _orController.text.trim();
    final reason = _descriptionController.text.trim();
    debugPrint('Refunds: submit tapped (OR="$detailId")');
    if (detailId.isEmpty || reason.isEmpty) return;

    final confirmed = await _confirm(detailId);
    debugPrint('Refunds: confirmation result = $confirmed');
    if (confirmed != true || !mounted) return;

    await ref
        .read(refundsControllerProvider.notifier)
        .submit(detailId: detailId, reason: reason);
  }

  Future<bool?> _confirm(String detailId) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Refund this sale?'),
        content: Text(
          'OR $detailId will be marked as refunded and its items returned '
          'to stock. This can\'t be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Refund'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Clear the form once a refund goes through.
    ref.listen(refundsControllerProvider, (previous, next) {
      final outcome = next.outcome;
      if (outcome != null &&
          outcome != previous?.outcome &&
          outcome.isSuccess) {
        _orController.clear();
        _descriptionController.clear();
      }
    });

    final state = ref.watch(refundsControllerProvider);
    final cashier = ref.watch(userDataProvider).value?.fullName;
    final hasCashier =
        cashier != null && cashier.isNotEmpty && cashier != 'INVALID USER';

    return PosFormSheet(
      title: 'Refund',
      subtitle: 'Enter the OR number and the reason for the refund',
      icon: Icons.assignment_return_rounded,
      accent: colors.refund,
      onAccent: colors.onRefund,
      submitLabel: state.isSubmitting ? 'PROCESSING...' : 'PROCESS REFUND',
      submitEnabled: _canSubmit && hasCashier && !state.isSubmitting,
      onSubmit: _onSubmit,
      children: [
        if (state.isSubmitting) ...[
          const LinearProgressIndicator(),
          const SizedBox(height: 16),
        ],
        if (state.outcome != null) ...[
          _OutcomeBanner(
            outcome: state.outcome!,
            onDismiss: () =>
                ref.read(refundsControllerProvider.notifier).dismissOutcome(),
          ),
          const SizedBox(height: 20),
        ],
        PosTextField(
          label: 'OR NUMBER',
          hint: 'e.g. 000123',
          icon: Icons.tag_rounded,
          controller: _orController,
          autofocus: true,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          textInputAction: TextInputAction.next,

          onSubmitted: (_) => _descriptionFocus.requestFocus(),
        ),
        const SizedBox(height: 20),
        PosTextField(
          label: 'DESCRIPTION',
          hint: 'Reason for the refund',
          icon: Icons.notes_rounded,
          controller: _descriptionController,
          focusNode: _descriptionFocus,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,

          textInputAction: TextInputAction.newline,
          minLines: 3,
          maxLines: 4,
        ),
        const SizedBox(height: 12),
        Text(
          hasCashier ? 'Processed by $cashier' : 'No user is logged in',
          style: AppTypography.ui(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: hasCashier ? colors.textSecondary : colors.danger,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _OutcomeBanner extends StatelessWidget {
  const _OutcomeBanner({required this.outcome, required this.onDismiss});

  final RefundOutcome outcome;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final Color tone;
    final IconData icon;
    switch (outcome.status) {
      case RefundStatus.success:
        tone = colors.success;
        icon = Icons.check_circle_rounded;
      case RefundStatus.alreadyRefunded:
      case RefundStatus.receiptNotFound:
        tone = colors.primary;
        icon = Icons.info_rounded;
      case RefundStatus.failed:
        tone = colors.danger;
        icon = Icons.error_rounded;
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
      decoration: BoxDecoration(
        color: tone.withAlpha(30),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: tone),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: tone),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                outcome.message,
                style: AppTypography.ui(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Dismiss',
            onPressed: onDismiss,
            icon: Icon(Icons.close_rounded, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
