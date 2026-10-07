import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/core/database/domain/customer_dto.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/customer_controller.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/widgets/dashboardWidgets/others_sheet/pos_form_sheet.dart'
    show PosTextField;

/// How the customer prompt was answered. Closing the sheet without choosing
/// either is neither, and means "don't charge yet".
enum CustomerPromptOutcome { entered, skipped }

/// Shown when Charge is tapped, before payment: is this sale for an individual
/// or a company? The cashier fills the details in, or skips.
class CustomerPanel extends ConsumerStatefulWidget {
  const CustomerPanel({super.key});

  /// Runs the customer step of checkout and says whether to go on to payment.
  ///
  /// Returns true when there is nothing to ask (the store has the customer
  /// prompt switched off) or the cashier entered a customer or skipped. Returns
  /// false when the sheet was closed without choosing, so the cashier can tap
  /// Charge again.
  static Future<bool> promptBeforePayment(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final shouldPrompt = await ref
        .read(customerControllerProvider.notifier)
        .beginCheckout();

    if (!context.mounted) return false;
    if (!shouldPrompt) return true;

    final outcome = await showModalBottomSheet<CustomerPromptOutcome>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CustomerPanel(),
    );
    return outcome != null;
  }

  @override
  ConsumerState<CustomerPanel> createState() => _CustomerPanelState();
}

class _CustomerPanelState extends ConsumerState<CustomerPanel> {
  CustomerType _type = CustomerType.individual;

  final _purchaseOrder = TextEditingController();
  final _fullName = TextEditingController();
  final _company = TextEditingController();
  final _representative = TextEditingController();
  final _email = TextEditingController();
  final _mobile = TextEditingController();
  final _address = TextEditingController();

  final _emailFocus = FocusNode();
  final _mobileFocus = FocusNode();
  final _addressFocus = FocusNode();
  final _representativeFocus = FocusNode();
  final _fullNameFocus = FocusNode();

  List<TextEditingController> get _all => [
    _purchaseOrder,
    _fullName,
    _company,
    _representative,
    _email,
    _mobile,
    _address,
  ];

  @override
  void initState() {
    super.initState();
    for (final c in _all) {
      c.addListener(_refresh);
    }
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    for (final c in _all) {
      c.dispose();
    }
    _emailFocus.dispose();
    _mobileFocus.dispose();
    _addressFocus.dispose();
    _representativeFocus.dispose();
    _fullNameFocus.dispose();
    super.dispose();
  }

  bool get _canContinue {
    if (_type == CustomerType.individual) {
      return _fullName.text.trim().isNotEmpty;
    }
    return _company.text.trim().isNotEmpty &&
        _representative.text.trim().isNotEmpty;
  }

  void _continue() {
    if (!_canContinue) return;

    final isCompany = _type == CustomerType.company;
    ref
        .read(customerControllerProvider.notifier)
        .saveDraft(
          CustomerDraft(
            type: _type,
            company: isCompany ? _company.text : '',
            // For a company the "full name" is its representative.
            fullName: isCompany ? _representative.text : _fullName.text,
            email: _email.text,
            mobile: _mobile.text,
            address: _address.text,
            purchaseOrder: _purchaseOrder.text,
          ),
        );
    Navigator.of(context).pop(CustomerPromptOutcome.entered);
  }

  void _skip() {
    ref.read(customerControllerProvider.notifier).skip();
    Navigator.of(context).pop(CustomerPromptOutcome.skipped);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final showPurchaseOrder = ref.watch(
      customerControllerProvider.select((s) => s.showPurchaseOrder),
    );
    final isCompany = _type == CustomerType.company;

    // The keyboard height. The whole sheet is lifted by it, so the buttons stay
    // visible above the keyboard and only the fields in the middle scroll.
    final keyboard = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboard),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.border,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                _Header(onClose: () => Navigator.of(context).pop()),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: _TypeOption(
                          icon: Icons.person_rounded,
                          label: 'Individual',
                          selected: !isCompany,
                          onTap: () =>
                              setState(() => _type = CustomerType.individual),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _TypeOption(
                          icon: Icons.business_rounded,
                          label: 'Company',
                          selected: isCompany,
                          onTap: () =>
                              setState(() => _type = CustomerType.company),
                        ),
                      ),
                    ],
                  ),
                ),
                // Only this part scrolls, so a tall keyboard never hides the
                // buttons below it.
                Flexible(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                    child: Column(
                      children: [
                        if (showPurchaseOrder) ...[
                          PosTextField(
                            label: 'PURCHASE ORDER',
                            hint: 'PO number',
                            icon: Icons.tag_rounded,
                            controller: _purchaseOrder,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (isCompany) ...[
                          PosTextField(
                            label: 'COMPANY NAME',
                            hint: 'e.g. Microsoft',
                            icon: Icons.business_rounded,
                            controller: _company,
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) =>
                                _representativeFocus.requestFocus(),
                          ),
                          const SizedBox(height: 16),
                          PosTextField(
                            label: 'REPRESENTATIVE',
                            hint: 'Full name of the contact person',
                            icon: Icons.person_rounded,
                            controller: _representative,
                            focusNode: _representativeFocus,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) => _emailFocus.requestFocus(),
                          ),
                        ] else
                          PosTextField(
                            label: 'FULL NAME',
                            hint: 'e.g. Juan Dela Cruz',
                            icon: Icons.person_rounded,
                            controller: _fullName,
                            focusNode: _fullNameFocus,
                            autofocus: true,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) => _emailFocus.requestFocus(),
                          ),
                        const SizedBox(height: 16),
                        PosTextField(
                          label: 'EMAIL',
                          hint: 'name@example.com',
                          icon: Icons.email_rounded,
                          controller: _email,
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) => _mobileFocus.requestFocus(),
                        ),
                        const SizedBox(height: 16),
                        PosTextField(
                          label: 'MOBILE',
                          hint: '09XX XXX XXXX',
                          icon: Icons.phone_android_rounded,
                          controller: _mobile,
                          focusNode: _mobileFocus,
                          keyboardType: TextInputType.phone,
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) => _addressFocus.requestFocus(),
                        ),
                        const SizedBox(height: 16),
                        PosTextField(
                          label: 'ADDRESS',
                          hint: 'Street, barangay, city',
                          icon: Icons.location_on_rounded,
                          controller: _address,
                          focusNode: _addressFocus,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.newline,
                          minLines: 2,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: colors.borderSubtle)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 60,
                            child: OutlinedButton(
                              onPressed: _skip,
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                'SKIP',
                                style: AppTypography.ui(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 60,
                            child: FilledButton(
                              onPressed: _canContinue ? _continue : null,
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                'CONTINUE TO PAYMENT',
                                style: AppTypography.ui(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer',
                  style: AppTypography.display(
                    color: colors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Add a customer to this sale, or skip',
                  style: AppTypography.ui(
                    color: colors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            tooltip: 'Close',
            icon: const Icon(Icons.close_rounded),
            iconSize: 26,
            color: colors.textSecondary,
            style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
          ),
        ],
      ),
    );
  }
}

class _TypeOption extends StatelessWidget {
  const _TypeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: selected ? colors.primaryContainer : colors.surfaceVariant,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? colors.primary : colors.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: selected
                    ? colors.onPrimaryContainer
                    : colors.textSecondary,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: AppTypography.ui(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? colors.onPrimaryContainer
                      : colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
