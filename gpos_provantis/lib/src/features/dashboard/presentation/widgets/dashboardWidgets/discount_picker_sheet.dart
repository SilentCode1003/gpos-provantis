import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/providers/discounts_dao_provider.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'dashboard_constants.dart';

const double _sheetRadius = 28;

Future<void> showDiscountPickerSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _DiscountPickerSheet(),
  );
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 44,
      height: 5,
      decoration: BoxDecoration(
        color: colors.border,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _DiscountPickerSheet extends ConsumerWidget {
  const _DiscountPickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final discountsAsync = ref.watch(discountsProvider);
    final state = ref.watch(dashboardControllerProvider);
    final notifier = ref.read(dashboardControllerProvider.notifier);

    return FractionallySizedBox(
      heightFactor: 0.75,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(_sheetRadius),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const _SheetHandle(),
            _Header(
              hasDiscount: state.hasDiscount,
              onClear: () {
                notifier.clearDiscount();
                Navigator.of(context).pop();
              },
            ),
            Divider(height: 1, color: colors.borderSubtle),
            Expanded(
              child: discountsAsync.when(
                data: (discounts) => discounts.isEmpty
                    ? const _EmptyDiscounts()
                    : _DiscountList(
                        discounts: discounts,
                        selectedDiscountId: state.selectedDiscount?.discountId,
                        onPick: (discount) {
                          if (notifier.discountRequiresCustomerInfo(discount)) {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) =>
                                  _CustomerInfoSheet(discount: discount),
                            );
                            return;
                          }
                          notifier.applyDiscount(discount);
                          Navigator.of(context).pop();
                        },
                      ),
                loading: () => Center(
                  child: CircularProgressIndicator(color: colors.primary),
                ),
                error: (error, _) => _ErrorState(message: '$error'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.hasDiscount, required this.onClear});

  final bool hasDiscount;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Apply discount',
                  style: AppTypography.display(
                    color: colors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Choose one for this sale',
                  style: AppTypography.ui(
                    color: colors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (hasDiscount) _RemoveDiscountButton(onTap: onClear),
        ],
      ),
    );
  }
}

class _RemoveDiscountButton extends StatelessWidget {
  const _RemoveDiscountButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.danger.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(PhosphorIcons.x, size: 14, color: colors.danger),
              const SizedBox(width: 6),
              Text(
                'Remove',
                style: AppTypography.ui(
                  color: colors.danger,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// List
// ─────────────────────────────────────────────────────────────────────────────

class _DiscountList extends StatelessWidget {
  const _DiscountList({
    required this.discounts,
    required this.selectedDiscountId,
    required this.onPick,
  });

  final List<DiscountsTableData> discounts;
  final int? selectedDiscountId;
  final ValueChanged<DiscountsTableData> onPick;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      itemCount: discounts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final discount = discounts[index];
        return _DiscountTile(
          discount: discount,
          isSelected: discount.discountId == selectedDiscountId,
          onTap: () => onPick(discount),
        );
      },
    );
  }
}

class _DiscountTile extends StatelessWidget {
  const _DiscountTile({
    required this.discount,
    required this.isSelected,
    required this.onTap,
  });

  final DiscountsTableData discount;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: isSelected
          ? colors.primaryContainer.withValues(alpha: 0.4)
          : colors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: isSelected
            ? BorderSide(color: colors.primary, width: 1.5)
            : BorderSide(color: colors.border.withValues(alpha: 0.6)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: colors.primary.withValues(alpha: 0.12),
        highlightColor: colors.primary.withValues(alpha: 0.06),
        child: Container(
          constraints: const BoxConstraints(minHeight: primaryTapTarget),
          padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : colors.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '${discount.rate}%',
                  style: AppTypography.display(
                    color: isSelected
                        ? colors.onPrimary
                        : colors.onPrimaryContainer,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      discount.name,
                      style: AppTypography.ui(
                        color: colors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (discount.description.trim().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        discount.description,
                        maxLines: 1,
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
              if (isSelected) ...[
                const SizedBox(width: 8),
                Icon(
                  PhosphorIcons.checkCircle,
                  color: colors.primary,
                  size: 26,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty / error
// ─────────────────────────────────────────────────────────────────────────────

class _SheetMessage extends StatelessWidget {
  const _SheetMessage({
    required this.icon,
    required this.title,
    required this.body,
    this.isError = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isError
                    ? colors.danger.withValues(alpha: 0.12)
                    : colors.primaryContainer,
              ),
              child: Icon(
                icon,
                size: 36,
                color: isError ? colors.danger : colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.display(
                color: colors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              body,
              textAlign: TextAlign.center,
              style: AppTypography.ui(
                color: colors.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyDiscounts extends StatelessWidget {
  const _EmptyDiscounts();

  @override
  Widget build(BuildContext context) {
    return _SheetMessage(
      icon: PhosphorIcons.percent,
      title: 'No discounts available',
      body: 'Discounts synced from the server will show up here.',
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return _SheetMessage(
      icon: PhosphorIcons.warningCircle,
      title: 'Couldn\u2019t load discounts',
      body: message,
      isError: true,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Customer info (for discounts that need an ID on record)
// ─────────────────────────────────────────────────────────────────────────────

class _CustomerInfoSheet extends ConsumerStatefulWidget {
  const _CustomerInfoSheet({required this.discount});

  final DiscountsTableData discount;

  @override
  ConsumerState<_CustomerInfoSheet> createState() => _CustomerInfoSheetState();
}

class _CustomerInfoSheetState extends ConsumerState<_CustomerInfoSheet> {
  final _idController = TextEditingController();
  final _fullNameController = TextEditingController();

  bool get _isReady =>
      _idController.text.trim().isNotEmpty &&
      _fullNameController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _idController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  void _confirm() {
    final notifier = ref.read(dashboardControllerProvider.notifier);
    notifier.applyDiscount(
      widget.discount,
      customerInfo: DiscountCustomerInfo(
        id: _idController.text.trim(),
        fullName: _fullNameController.text.trim(),
      ),
    );

    final navigator = Navigator.of(context);
    navigator.pop(); // this sheet
    navigator.pop(); // the discount-list sheet underneath
  }

  InputDecoration _decoration(AppColors colors, String hint) {
    final noBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    );

    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.ui(color: colors.textDisabled, fontSize: 16),
      filled: true,
      fillColor: colors.surfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      border: noBorder,
      enabledBorder: noBorder,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.primary, width: 1.5),
      ),
    );
  }

  Widget _label(AppColors colors, String text) {
    return Text(
      text,
      style: AppTypography.ui(
        color: colors.textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(_sheetRadius),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            const _SheetHandle(),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 12, 12),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${widget.discount.rate}%',
                      style: AppTypography.display(
                        color: colors.onPrimaryContainer,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.discount.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.display(
                        color: colors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      customBorder: const CircleBorder(),
                      child: SizedBox(
                        width: minTapTarget,
                        height: minTapTarget,
                        child: Center(
                          child: Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.surfaceVariant,
                            ),
                            child: Icon(
                              PhosphorIcons.x,
                              size: 20,
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: colors.borderSubtle),
            // Scrolls if the keyboard leaves too little room on small screens.
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colors.infoContainer.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        'This discount requires the customer\u2019s ID and '
                        'full name on record.',
                        style: AppTypography.ui(
                          color: colors.textPrimary,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _label(colors, 'ID number'),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: primaryTapTarget,
                      child: TextField(
                        controller: _idController,
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.next,
                        style: AppTypography.ui(
                          color: colors.textPrimary,
                          fontSize: 16,
                        ),
                        decoration: _decoration(colors, 'e.g. 1234-5678-9012'),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _label(colors, 'Full name'),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: primaryTapTarget,
                      child: TextField(
                        controller: _fullNameController,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        style: AppTypography.ui(
                          color: colors.textPrimary,
                          fontSize: 16,
                        ),
                        decoration: _decoration(colors, 'e.g. Juan Dela Cruz'),
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) {
                          if (_isReady) _confirm();
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: primaryTapTarget,
                      child: ElevatedButton(
                        onPressed: _isReady ? _confirm : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                          disabledBackgroundColor: colors.disabledFill,
                          disabledForegroundColor: colors.textDisabled,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Apply discount',
                          style: AppTypography.ui(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
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
    );
  }
}
