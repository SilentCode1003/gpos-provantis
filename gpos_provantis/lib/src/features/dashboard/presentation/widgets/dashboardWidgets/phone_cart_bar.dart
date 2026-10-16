import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'cart_panel.dart';
import 'dashboard_constants.dart';
import 'money_format.dart';

const double _sheetRadius = 28;

/// Share of the screen the cart sheet fills. Leaves a sliver of the catalog
/// showing above it so it reads as a sheet, not a new page.
const double _cartSheetHeightFactor = 0.92;

/// Opens the full cart as a bottom sheet (phone layout only).
Future<void> showPhoneCartSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _PhoneCartSheet(),
  );
}

/// The cart on a phone: always docked at the bottom of the screen, showing how
/// many items are in the sale and the total. Tap it to open the full cart.
///
/// It stays visible while the product sheet is open, so the cashier can watch
/// the total grow as they add items.
class PhoneCartBar extends ConsumerWidget {
  const PhoneCartBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final itemCount = ref.watch(
      dashboardControllerProvider.select((s) => s.itemCount),
    );
    final total = ref.watch(dashboardControllerProvider.select((s) => s.total));
    final hasItems = itemCount > 0;

    final fg = hasItems ? colors.onPrimary : colors.textDisabled;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        // Same treatment as the cart footer on the wide layout.
        border: Border(
          top: BorderSide(
            color: colors.isDark ? colors.border : colors.borderSubtle,
          ),
        ),
        boxShadow: colors.isDark
            ? null
            : [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: colors.shadow.a * 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
      ),
      child: SizedBox(
        height: primaryTapTarget,
        child: Material(
          color: hasItems ? colors.primary : colors.disabledFill,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: hasItems ? () => showPhoneCartSheet(context) : null,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  if (hasItems)
                    Container(
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colors.onPrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        formatCount(itemCount),
                        style:
                            AppTypography.ui(
                              color: fg,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ).copyWith(
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                      ),
                    )
                  else
                    Icon(PhosphorIcons.shoppingCart, size: 24, color: fg),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      hasItems ? 'View cart' : 'Cart is empty',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.ui(
                        color: fg,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (hasItems) ...[
                    const SizedBox(width: 8),
                    Text(
                      formatPeso(total),
                      style:
                          AppTypography.ui(
                            color: fg,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ).copyWith(
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                    ),
                    const SizedBox(width: 8),
                    Icon(PhosphorIcons.caretUp, size: 18, color: fg),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhoneCartSheet extends ConsumerWidget {
  const _PhoneCartSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final route = ModalRoute.of(context);

    // Once the cart is empty (sale paid, or everything removed) there is
    // nothing left to do here, so the sheet closes itself.
    ref.listen<bool>(
      dashboardControllerProvider.select((s) => s.cartLines.isEmpty),
      (previous, isEmpty) {
        if (previous != false || !isEmpty) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted || route == null || !route.isActive) return;
          final navigator = Navigator.of(context);
          if (route.isCurrent) {
            navigator.pop();
          } else {
            // The payment dialog is still on top. A plain pop() would close
            // that dialog instead, so take this sheet out by itself.
            navigator.removeRoute(route);
          }
        });
      },
    );

    return FractionallySizedBox(
      heightFactor: _cartSheetHeightFactor,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(_sheetRadius),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Expanded(
              child: CartPanel(onClose: () => Navigator.of(context).pop()),
            ),
          ],
        ),
      ),
    );
  }
}
