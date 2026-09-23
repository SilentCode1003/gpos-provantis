// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/discount_picker_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/providers/discounts_dao_provider.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'dashboard_constants.dart';

/// Opens the discount picker as a modal bottom sheet and applies
/// whichever discount the cashier taps. Returns once the sheet is
/// dismissed (either by a pick or by the cashier backing out) — callers
/// don't need to do anything with the result themselves, since applying
/// the discount happens inside the sheet via `dashboardControllerProvider`.
Future<void> showDiscountPickerSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _DiscountPickerSheet(),
  );
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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.borderSubtle,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
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
                            // Push the ID + Fullname sheet on top; it
                            // applies the discount itself on confirm
                            // (see _CustomerInfoSheet) and pops back
                            // out through both sheets. If the cashier
                            // backs out instead, nothing is applied and
                            // only the customer-info sheet closes,
                            // leaving the discount list open underneath.
                            // Not awaited here — onPick is a plain
                            // synchronous callback (ValueChanged), and
                            // nothing downstream needs to know when the
                            // second sheet finishes closing.
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
                loading: () => const Center(child: CircularProgressIndicator()),
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
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
      child: Row(
        children: [
          Text(
            'Apply discount',
            style: AppTypography.display(
              color: colors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          // Only offered once a discount is actually applied — nothing
          // to clear otherwise, so the affordance stays hidden rather
          // than rendered-and-disabled (same pattern as the cart's own
          // "Remove all").
          if (hasDiscount) _RemoveDiscountButton(onTap: onClear),
        ],
      ),
    );
  }
}

/// "Remove discount" — deliberately built as its own small pill (rounded
/// container + icon + label) rather than a bare `TextButton`, so it reads
/// as a real control sitting in the header, not a stray line of text
/// floating next to the title. Same "contained chip" language the
/// discount tiles below use for their rate badge, just sized down and
/// given a tap ripple — a plain text button here got lost next to
/// 'Apply discount' since nothing gave it any visual weight of its own.
class _RemoveDiscountButton extends StatelessWidget {
  const _RemoveDiscountButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.dangerContainer.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: discounts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 2),
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
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${discount.rate}%',
                  style: AppTypography.ui(
                    color: colors.textPrimary,
                    fontSize: 13,
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
                        fontSize: 15,
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
              if (isSelected)
                Icon(
                  PhosphorIcons.checkCircle,
                  color: colors.primary,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyDiscounts extends StatelessWidget {
  const _EmptyDiscounts();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(PhosphorIcons.percent, size: 44, color: colors.textDisabled),
            const SizedBox(height: 14),
            Text(
              'No discounts available',
              style: AppTypography.display(
                color: colors.textSecondary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Discounts synced from the server will show up here.',
              textAlign: TextAlign.center,
              style: AppTypography.ui(color: colors.textDisabled, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(PhosphorIcons.warningCircle, size: 44, color: colors.danger),
            const SizedBox(height: 14),
            Text(
              'Couldn\u2019t load discounts',
              style: AppTypography.display(
                color: colors.textSecondary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.ui(color: colors.textDisabled, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

/// --- CUSTOMER INFO: ID + Fullname prompt for PWD/Senior discounts -------
///
/// Opened on top of the discount list (as a second sheet, not a
/// replacement of it) when the tapped discount requires customer info —
/// see `DashboardController.discountRequiresCustomerInfo`. Both fields
/// are required before "Apply discount" enables; confirming applies the
/// discount with the entered info and closes both this sheet and the
/// discount list underneath. Backing out (the header's X) closes only
/// this sheet, leaving the discount list open with nothing applied.
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
    // Resolve the navigator once, before popping anything — after the
    // first pop, this sheet's own `context` belongs to a widget that's
    // being torn down, so re-resolving Navigator.of(context) a second
    // time against it would be reading from a context mid-removal.
    // popUntil walks back to (and stops just past) the discount-list
    // sheet in one call using the navigator captured up front, rather
    // than issuing two separate pops against a context that's already
    // gone stale after the first one.
    final navigator = Navigator.of(context);
    navigator.pop(); // this sheet
    navigator.pop(); // the discount-list sheet underneath
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      // Lifts the sheet clear of the on-screen keyboard, same pattern
      // Flutter's own examples use for a bottom-sheet text form — the
      // sheet's bottom padding grows by exactly the keyboard's height.
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.borderSubtle,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.discount.name,
                      style: AppTypography.display(
                        color: colors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Material(
                    color: colors.surfaceVariant,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      customBorder: const CircleBorder(),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          PhosphorIcons.x,
                          size: 20,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: colors.borderSubtle),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This discount requires the customer\u2019s ID and full '
                    'name on record.',
                    style: AppTypography.ui(
                      color: colors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'ID number',
                    style: AppTypography.ui(
                      color: colors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: primaryTapTarget,
                    child: TextField(
                      controller: _idController,
                      textCapitalization: TextCapitalization.characters,
                      style: AppTypography.ui(
                        color: colors.textPrimary,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'e.g. 1234-5678-9012',
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
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Full name',
                    style: AppTypography.ui(
                      color: colors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: primaryTapTarget,
                    child: TextField(
                      controller: _fullNameController,
                      textCapitalization: TextCapitalization.words,
                      style: AppTypography.ui(
                        color: colors.textPrimary,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'e.g. Juan Dela Cruz',
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
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: primaryTapTarget,
                    child: ElevatedButton(
                      onPressed: _isReady ? _confirm : null,
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
                        'Apply discount',
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
          ],
        ),
      ),
    );
  }
}
