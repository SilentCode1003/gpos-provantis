// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/send_ereceipt_sheet.dart
import 'package:flutter/material.dart';

import 'package:gpos_provantis/src/features/dashboard/presentation/widgets/dashboardWidgets/others_sheet/pos_form_sheet.dart';

/// --- Send e-receipt sheet: customer email ----------------------------------
///
/// PLACEHOLDER: submit currently does nothing. Wire the real send call into
/// [_onSubmit] later.
class SendEReceiptSheet extends StatefulWidget {
  const SendEReceiptSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showPosFormSheet(context, child: const SendEReceiptSheet());
  }

  @override
  State<SendEReceiptSheet> createState() => _SendEReceiptSheetState();
}

class _SendEReceiptSheetState extends State<SendEReceiptSheet> {
  final _emailController = TextEditingController();

  /// Only show the "invalid email" error after the cashier has typed
  /// something AND then left the field / hit done — flashing an error at
  /// the first keystroke is hostile on a touchscreen.
  bool _showError = false;

  // Deliberately loose: catches typos like "john@" or "john.gmail.com"
  // without rejecting unusual-but-valid addresses. The server is the real
  // validator.
  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        // Clear a stale error as soon as the input becomes valid.
        if (_isValid) _showError = false;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String get _email => _emailController.text.trim();
  bool get _isValid => _emailPattern.hasMatch(_email);

  void _onSubmit() {
    if (!_isValid) {
      setState(() => _showError = true);
      return;
    }
    // TODO: implement sending the e-receipt to `_email`.
    // Intentionally a no-op for now — the sheet stays open.
  }

  @override
  Widget build(BuildContext context) {
    return PosFormSheet(
      title: 'Send e-receipt',
      subtitle: 'Enter the email address to send the receipt to',
      icon: Icons.forward_to_inbox_rounded,
      submitLabel: 'SEND E-RECEIPT',
      // Button stays tappable once there's any text, so tapping it with a
      // malformed address surfaces the error instead of silently doing
      // nothing.
      submitEnabled: _email.isNotEmpty,
      onSubmit: _onSubmit,
      children: [
        PosTextField(
          label: 'EMAIL',
          hint: 'customer@example.com',
          icon: Icons.alternate_email_rounded,
          controller: _emailController,
          autofocus: true,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.email],
          errorText: _showError ? 'Enter a valid email address' : null,
          onSubmitted: (_) => _onSubmit(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
