import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/database/domain/email_dto.dart';
import 'package:gpos_provantis/src/core/database/providers/email_dao_provider.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import '../screens/settings_shared.dart';

final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

class EmailPanel extends ConsumerStatefulWidget {
  const EmailPanel();

  @override
  ConsumerState<EmailPanel> createState() => _EmailPanelState();
}

class _EmailPanelState extends ConsumerState<EmailPanel> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _smtpServerController = TextEditingController();

  bool _filled = false;
  bool _saving = false;
  bool _hidePassword = true;

  @override
  void initState() {
    super.initState();

    final current = ref.read(emailProvider).value;
    if (current != null) _fillFrom(EmailDto.fromTableData(current));

    ref.listenManual(emailProvider, (previous, next) {
      final row = next.value;
      if (!_filled && row != null) _fillFrom(EmailDto.fromTableData(row));
    });
  }

  void _fillFrom(EmailDto e) {
    _emailController.text = e.emailAddress;
    _passwordController.text = e.password;
    _smtpServerController.text = e.smtpServer;
    _filled = true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _smtpServerController.dispose();
    super.dispose();
  }

  /// Leaving every field empty is allowed (it clears the account). Filling in
  /// only some of them is not.
  bool get _allBlank =>
      _emailController.text.trim().isEmpty &&
      _passwordController.text.trim().isEmpty &&
      _smtpServerController.text.trim().isEmpty;

  String? _validateEmail(String? value) {
    final text = (value ?? '').trim();
    if (_allBlank) return null;
    if (text.isEmpty) return 'Enter the email address';
    if (!_emailPattern.hasMatch(text)) return 'Enter a valid email address';
    return null;
  }

  String? _validatePassword(String? value) {
    if (_allBlank) return null;
    if ((value ?? '').trim().isEmpty) return 'Enter the password';
    return null;
  }

  String? _validateSmtpServer(String? value) {
    final text = (value ?? '').trim();
    if (_allBlank) return null;
    if (text.isEmpty) return 'Enter the SMTP server';
    if (text.contains(RegExp(r'\s')) || text.contains('://')) {
      return 'Enter just the server name, e.g. smtp.gmail.com';
    }
    return null;
  }

  Future<void> _save() async {
    if (_saving) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      final dto = EmailDto(
        emailAddress: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        smtpServer: _smtpServerController.text.trim(),
      );
      await ref.read(emailDaoProvider).saveEmail(dto.toCompanion());

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email settings saved.')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Space.xxxl,
        Space.xxl,
        Space.xxxl,
        Space.xxxl,
      ),
      children: [
        const PanelHeader(
          title: 'Email',
          subtitle: 'The account used to email e-receipts to customers',
        ),
        const SizedBox(height: Space.xxl),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _ConfigFieldLabel('Email'),
              const SizedBox(height: Space.sm),
              _ConfigTextField(
                controller: _emailController,
                hintText: 'receipts@yourstore.com',
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              const SizedBox(height: Space.xxl),

              const _ConfigFieldLabel('Password'),
              const SizedBox(height: Space.sm),
              _ConfigTextField(
                controller: _passwordController,
                hintText: 'Email or app password',
                obscureText: _hidePassword,
                validator: _validatePassword,
                suffix: IconButton(
                  tooltip: _hidePassword ? 'Show password' : 'Hide password',
                  icon: Icon(
                    _hidePassword
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: colors.textSecondary,
                  ),
                  onPressed: () =>
                      setState(() => _hidePassword = !_hidePassword),
                ),
              ),
              const SizedBox(height: Space.xxl),

              const _ConfigFieldLabel('SMTP Server'),
              const SizedBox(height: Space.sm),
              _ConfigTextField(
                controller: _smtpServerController,
                hintText: 'smtp.gmail.com',
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                validator: _validateSmtpServer,
              ),
              const SizedBox(height: Space.sm),
              Text(
                'Receipts are sent on port 587 (STARTTLS).',
                style: AppTypography.ui(
                  fontSize: 13,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: Space.xxxl),

              _SaveConfigButton(onPressed: _save, saving: _saving),
            ],
          ),
        ),
      ],
    );
  }
}

class _ConfigFieldLabel extends StatelessWidget {
  const _ConfigFieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Text(
      text,
      style: AppTypography.ui(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: colors.textSecondary,
      ),
    );
  }
}

class _ConfigTextField extends StatelessWidget {
  const _ConfigTextField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.suffix,
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final Widget? suffix;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      // Credentials and server names: no autocorrect or suggestions.
      autocorrect: false,
      enableSuggestions: false,
      validator: validator,
      style: AppTypography.ui(fontSize: 18, color: colors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTypography.ui(fontSize: 18, color: colors.textDisabled),
        suffixIcon: suffix,
        filled: true,
        fillColor: colors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Space.xl,
          vertical: Space.xl,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.primary, width: 2.5),
        ),
      ),
    );
  }
}

class _SaveConfigButton extends StatelessWidget {
  const _SaveConfigButton({required this.onPressed, required this.saving});

  final VoidCallback onPressed;
  final bool saving;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: saving ? colors.primary.withValues(alpha: 0.6) : colors.primary,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: saving ? null : onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 72,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (saving)
                SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: colors.onPrimary,
                  ),
                )
              else
                Icon(Icons.check_rounded, size: 24, color: colors.onPrimary),
              const SizedBox(width: Space.md),
              Text(
                saving ? 'Saving...' : 'Save email settings',
                style: AppTypography.ui(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: colors.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
