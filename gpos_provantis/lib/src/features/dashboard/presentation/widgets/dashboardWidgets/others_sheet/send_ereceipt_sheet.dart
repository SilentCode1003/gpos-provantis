import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/send_ereceipt_controller.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/widgets/dashboardWidgets/others_sheet/pos_form_sheet.dart';

class SendEReceiptSheet extends ConsumerStatefulWidget {
  const SendEReceiptSheet({super.key, this.initialOrNumber = ''});

  /// Pre-fills the OR number, e.g. when opened from a receipt.
  final String initialOrNumber;

  static Future<void> show(
    BuildContext context, {
    String initialOrNumber = '',
  }) {
    return showPosFormSheet(
      context,
      child: SendEReceiptSheet(initialOrNumber: initialOrNumber),
    );
  }

  @override
  ConsumerState<SendEReceiptSheet> createState() => _SendEReceiptSheetState();
}

class _SendEReceiptSheetState extends ConsumerState<SendEReceiptSheet> {
  late final TextEditingController _orController;
  final _emailController = TextEditingController();

  SendEReceiptControllerProvider get _provider =>
      sendEReceiptControllerProvider(widget.initialOrNumber);

  @override
  void initState() {
    super.initState();
    _orController = TextEditingController(text: widget.initialOrNumber);
    // The controller ignores repeats (selection changes also fire this).
    _orController.addListener(
      () => ref.read(_provider.notifier).setOrNumber(_orController.text),
    );
    _emailController.addListener(
      () => ref.read(_provider.notifier).setEmail(_emailController.text),
    );
  }

  @override
  void dispose() {
    _orController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final sent = await ref.read(_provider.notifier).submit();
    if (sent && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final hasPrefilledOr = widget.initialOrNumber.isNotEmpty;

    return PosFormSheet(
      title: 'Send e-receipt',
      subtitle: 'Enter the OR number and the email address to send it to',
      icon: Icons.forward_to_inbox_rounded,
      submitLabel: state.isSending ? 'SENDING...' : 'SEND E-RECEIPT',

      submitEnabled: state.canSubmit,
      onSubmit: _onSubmit,
      children: [
        PosTextField(
          label: 'OR NUMBER',
          hint: 'OR number on the receipt',
          icon: Icons.receipt_long_rounded,
          controller: _orController,
          autofocus: !hasPrefilledOr,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          errorText: state.orError,
          onSubmitted: (_) => FocusScope.of(context).nextFocus(),
        ),
        const SizedBox(height: 16),
        PosTextField(
          label: 'EMAIL',
          hint: 'customer@example.com',
          icon: Icons.alternate_email_rounded,
          controller: _emailController,
          autofocus: hasPrefilledOr,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.email],
          errorText: state.emailError,
          onSubmitted: (_) => _onSubmit(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
