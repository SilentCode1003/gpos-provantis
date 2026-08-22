// Location: src/features/dashboard/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import '../controllers/dashboard_controller.dart';

/// =========================================================================
/// DASHBOARD SCREEN — POS main screen. Split layout, no overlays for the
/// core cart/catalog flow. Built for a TOUCHSCREEN terminal, not a mouse-
/// driven desktop app — every tappable control on this screen is sized
/// and spaced for a fingertip, not a cursor. See TOUCH TARGETS below.
///
/// WHY NOT A BOTTOM SHEET FOR CATEGORIES: a cashier taps category ->
/// product -> category -> product in rapid repetition; a sheet adds an
/// open + dismiss transition to every single cycle and visually covers
/// the category buttons it needs tapped again next. The split panel
/// (category rail + product grid stacked in place, swapping content
/// directly) has zero transitions between taps. Left side (cart) is
/// completely unaffected by anything on the right, which was the one
/// hard constraint from the brief.
///
/// TOUCH TARGETS: every tappable element on this screen — buttons,
/// stepper +/-, remove icons, category tiles, product cards, top bar
/// actions, "Others" panel tiles — has a minimum 56x56 hit area, with
/// primary actions (Charge, category tiles, product cards, top bar
/// buttons) at 64px+. This is deliberately above the ~44-48px mouse/phone
/// convention: a fixed counter terminal gets tapped by an adult finger,
/// often quickly, sometimes at an angle. Spacing between adjacent
/// tappables is kept generous for the same reason — a slightly-off tap
/// should never land on the wrong control. If you're editing this file,
/// treat 56px as a hard floor for anything with an `onTap`/`onPressed`,
/// not a suggestion.
///
/// TOP BAR: persistent operational row above the category rail —
/// Start/End shift (mutually exclusive toggle), Cash drop, Reprint,
/// Settings, and "Others" (opens a 13-item grid of secondary actions:
/// discounts, payment methods, void sale, etc — see `_OthersSheet`).
/// "Others" uses a bottom sheet deliberately (unlike the category flow)
/// since these are one-off, low-frequency actions, not a rapid-repeat
/// loop — the transition cost that ruled out a sheet for categories
/// doesn't apply here.
///
/// NO PRODUCT IMAGES: product cards are text/label-forward (name + price
/// only, no image placeholder) per direction — bigger, clearer labels
/// instead of image real estate that isn't populated yet anyway.
///
/// LAYOUT: left panel = cart (fixed width, always visible, own scroll).
/// Right panel = top bar + category rail (always visible) above a
/// product grid (scrolls independently, swaps per category, no overlay).
/// Below the wide breakpoint, stacks vertically — a real touchscreen POS
/// terminal is realistically always landscape/tablet-sized, so the
/// narrow layout is a fallback, not the primary target.
///
/// PLACEHOLDER DATA: category/product/other-action content comes from
/// `DashboardController`'s hardcoded catalog — see that file's doc
/// comment. Only the data source is fake; the layout/interaction is real.
/// =========================================================================

const double _splitLayoutBreakpoint = 720;

/// Hard floor for any tappable control's hit area — see TOUCH TARGETS
/// above. Use this (or `_primaryTapTarget`) instead of guessing a size.
const double _minTapTarget = 56;

/// Floor for primary/high-frequency actions — category tiles, product
/// cards, top bar buttons, Charge.
const double _primaryTapTarget = 64;

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final isWide = MediaQuery.sizeOf(context).width >= _splitLayoutBreakpoint;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: isWide ? const _WideLayout() : const _NarrowLayout(),
      ),
    );
  }
}

/// --- Wide: cart left, top bar + category rail + product grid right --------

class _WideLayout extends StatelessWidget {
  const _WideLayout();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(flex: 2, child: _CartPanel()),
        Expanded(flex: 3, child: _CatalogPanel()),
      ],
    );
  }
}

/// --- Narrow: stacked fallback for phone-sized screens ----------------------

class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(flex: 2, child: _CartPanel()),
        Expanded(flex: 3, child: _CatalogPanel()),
      ],
    );
  }
}

/// --- Cart panel (left) -----------------------------------------------------

class _CartPanel extends ConsumerWidget {
  const _CartPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final state = ref.watch(dashboardControllerProvider);

    return Container(
      color: colors.surface,
      child: Column(
        children: [
          _CartHeader(itemCount: state.itemCount),
          Expanded(
            child: state.cartLines.isEmpty
                ? const _EmptyCart()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: state.cartLines.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: colors.borderSubtle),
                    itemBuilder: (context, index) {
                      return _CartLineTile(line: state.cartLines[index]);
                    },
                  ),
          ),
          _CartFooter(state: state),
        ],
      ),
    );
  }
}

class _CartHeader extends StatelessWidget {
  const _CartHeader({required this.itemCount});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Current sale',
            style: AppTypography.display(
              color: colors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          if (itemCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                style: AppTypography.ui(
                  color: colors.onPrimaryContainer,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 44,
              color: colors.textDisabled,
            ),
            const SizedBox(height: 14),
            Text(
              'Cart is empty',
              style: AppTypography.display(
                color: colors.textSecondary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap a product on the right to add it here.',
              textAlign: TextAlign.center,
              style: AppTypography.ui(color: colors.textDisabled, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartLineTile extends ConsumerWidget {
  const _CartLineTile({required this.line});

  final CartLine line;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final notifier = ref.read(dashboardControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.product.name,
                  style: AppTypography.ui(
                    color: colors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '\$${line.product.price.toStringAsFixed(2)} each',
                  style: AppTypography.ui(
                    color: colors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
                _QuantityStepper(
                  quantity: line.quantity,
                  onDecrement: () => notifier.decrementLine(line.product.id),
                  onIncrement: () => notifier.incrementLine(line.product.id),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${line.lineTotal.toStringAsFixed(2)}',
                style: AppTypography.ui(
                  color: colors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              // 56x56 hit area even though the glyph itself is small —
              // this is the "10x10 pixel X button" fixed. The icon stays
              // visually modest; the InkWell/tap area does not.
              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () => notifier.removeLine(line.product.id),
                  customBorder: const CircleBorder(),
                  child: const SizedBox(
                    width: _minTapTarget,
                    height: _minTapTarget,
                    child: Icon(Icons.close_rounded, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepperButton(icon: Icons.remove_rounded, onTap: onDecrement),
        SizedBox(
          width: 40,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: AppTypography.ui(
              color: colors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _StepperButton(icon: Icons.add_rounded, onTap: onIncrement),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.surfaceVariant,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: _minTapTarget,
          height: _minTapTarget,
          child: Icon(icon, size: 20, color: colors.textSecondary),
        ),
      ),
    );
  }
}

class _CartFooter extends ConsumerWidget {
  const _CartFooter({required this.state});

  final DashboardState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final notifier = ref.read(dashboardControllerProvider.notifier);
    final hasItems = state.cartLines.isNotEmpty;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.borderSubtle)),
      ),
      child: Column(
        children: [
          _TotalsRow(label: 'Subtotal', value: state.subtotal, colors: colors),
          const SizedBox(height: 4),
          _TotalsRow(label: 'Tax', value: state.tax, colors: colors),
          const SizedBox(height: 10),
          Divider(height: 1, color: colors.borderSubtle),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTypography.display(
                  color: colors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$${state.total.toStringAsFixed(2)}',
                style: AppTypography.display(
                  color: colors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: _primaryTapTarget,
                  child: OutlinedButton(
                    onPressed: hasItems ? notifier.toggleHold : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.held,
                      side: BorderSide(
                        color: hasItems ? colors.held : colors.border,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      state.isSaleHeld ? 'Held' : 'Hold sale',
                      style: AppTypography.ui(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: _primaryTapTarget,
                  child: ElevatedButton(
                    onPressed: hasItems ? () {} : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPalette.teal500,
                      foregroundColor: colors.onPrimary,
                      disabledBackgroundColor: colors.disabledFill,
                      disabledForegroundColor: colors.textDisabled,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Charge \$${state.total.toStringAsFixed(2)}',
                      style: AppTypography.ui(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TotalsRow extends StatelessWidget {
  const _TotalsRow({
    required this.label,
    required this.value,
    required this.colors,
  });

  final String label;
  final double value;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.ui(color: colors.textSecondary, fontSize: 14),
        ),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: AppTypography.ui(color: colors.textSecondary, fontSize: 14),
        ),
      ],
    );
  }
}

/// --- Catalog panel (right): top bar + category rail + product grid --------

class _CatalogPanel extends ConsumerWidget {
  const _CatalogPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    return Container(
      color: colors.background,
      child: const Column(
        children: [
          _TopBar(),
          _CategoryRail(),
          Expanded(child: _ProductGrid()),
        ],
      ),
    );
  }
}

/// --- Top bar: shift toggle, cash drop, reprint, settings, others ----------

class _TopBar extends ConsumerWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final state = ref.watch(dashboardControllerProvider);
    final notifier = ref.read(dashboardControllerProvider.notifier);
    final isShiftOpen = state.shiftStatus == ShiftStatus.open;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _TopBarButton(
              icon: isShiftOpen
                  ? Icons.stop_circle_outlined
                  : Icons.play_circle_outline_rounded,
              label: isShiftOpen ? 'End shift' : 'Start shift',
              emphasized: !isShiftOpen,
              onTap: notifier.toggleShift,
            ),
            const SizedBox(width: 10),
            _TopBarButton(
              icon: Icons.payments_outlined,
              label: 'Cash drop',
              enabled: isShiftOpen,
              onTap: () {},
            ),
            const SizedBox(width: 10),
            _TopBarButton(
              icon: Icons.print_outlined,
              label: 'Reprint',
              enabled: isShiftOpen,
              onTap: () {},
            ),
            const SizedBox(width: 10),
            _TopBarButton(
              icon: Icons.settings_outlined,
              label: 'Settings',
              onTap: () {},
            ),
            const SizedBox(width: 10),
            _TopBarButton(
              icon: Icons.apps_rounded,
              label: 'Others',
              enabled: isShiftOpen,
              onTap: () => _OthersSheet.show(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBarButton extends StatelessWidget {
  const _TopBarButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.emphasized = false,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool emphasized;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fill = emphasized ? AppPalette.teal500 : colors.surfaceVariant;
    final foreground = emphasized ? colors.onPrimary : colors.textPrimary;

    return Material(
      color: enabled ? fill : colors.disabledFill,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: _primaryTapTarget,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: enabled ? foreground : colors.textDisabled,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTypography.ui(
                  color: enabled ? foreground : colors.textDisabled,
                  fontSize: 14,
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

/// --- Others sheet: 13-item grid of secondary actions -----------------------
///
/// A bottom sheet is the right call here specifically because these are
/// one-off, low-frequency actions (discounts, void, returns, etc) rather
/// than the rapid tap-tap-tap loop that ruled out a sheet for categories.
/// Opens full-width (not right-panel-only) since it's launched from the
/// top bar, not from inside the category/product flow, and there's no
/// "covers the buttons I need to tap again immediately" problem here.
class _OthersSheet extends ConsumerWidget {
  const _OthersSheet();

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _OthersSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final controller = ref.watch(dashboardControllerProvider.notifier);
    final actions = controller.otherActions;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Text(
            'Other actions',
            style: AppTypography.display(
              color: colors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 160,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              return _OtherActionTile(action: actions[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _OtherActionTile extends StatelessWidget {
  const _OtherActionTile({required this.action});

  final OtherAction action;

  static const _iconMap = {
    'percent_rounded': Icons.percent_rounded,
    'credit_card_rounded': Icons.credit_card_rounded,
    'block_rounded': Icons.block_rounded,
    'search_rounded': Icons.search_rounded,
    'inbox_rounded': Icons.inbox_rounded,
    'person_search_rounded': Icons.person_search_rounded,
    'sticky_note_2_rounded': Icons.sticky_note_2_rounded,
    'assignment_return_rounded': Icons.assignment_return_rounded,
    'card_giftcard_rounded': Icons.card_giftcard_rounded,
    'receipt_long_rounded': Icons.receipt_long_rounded,
    'print_rounded': Icons.print_rounded,
    'summarize_rounded': Icons.summarize_rounded,
    'loyalty_rounded': Icons.loyalty_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final icon = _iconMap[action.icon] ?? Icons.touch_app_rounded;

    return Material(
      color: colors.surfaceVariant,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 26, color: colors.textPrimary),
              const SizedBox(height: 8),
              Text(
                action.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.ui(
                  color: colors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// --- Category rail ----------------------------------------------------------

class _CategoryRail extends ConsumerWidget {
  const _CategoryRail();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final controller = ref.watch(dashboardControllerProvider.notifier);
    final state = ref.watch(dashboardControllerProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: SizedBox(
        height: 96,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            final isSelected = category.id == state.selectedCategoryId;
            return _CategoryTile(
              category: category,
              isSelected: isSelected,
              onTap: () => controller.selectCategory(category.id),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  static const _iconMap = {
    'water_drop_rounded': Icons.water_drop_rounded,
    'account_balance_rounded': Icons.account_balance_rounded,
    'landscape_rounded': Icons.landscape_rounded,
    'chair_rounded': Icons.chair_rounded,
    'yard_rounded': Icons.yard_rounded,
    'park_rounded': Icons.park_rounded,
    'format_paint_rounded': Icons.format_paint_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final icon = _iconMap[category.icon] ?? Icons.category_rounded;

    return Material(
      color: isSelected ? AppPalette.teal500 : colors.surfaceVariant,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 116,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 26,
                color: isSelected ? colors.onPrimary : colors.textSecondary,
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.ui(
                  color: isSelected ? colors.onPrimary : colors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// --- Product grid: label-forward, no image placeholders --------------------

class _ProductGrid extends ConsumerWidget {
  const _ProductGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(dashboardControllerProvider.notifier);
    // Watching state (not just the notifier) so the grid rebuilds when
    // `selectedCategoryId` changes — that's the swap-in-place behavior
    // that replaces the bottom sheet for the category flow.
    ref.watch(dashboardControllerProvider);
    final products = controller.productsForSelectedCategory();

    if (products.isEmpty) {
      return const _EmptyCatalog();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.05,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _ProductCard(product: products[index]);
      },
    );
  }
}

class _EmptyCatalog extends StatelessWidget {
  const _EmptyCatalog();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Text(
        'No products in this category yet.',
        style: AppTypography.ui(color: colors.textDisabled, fontSize: 14),
      ),
    );
  }
}

/// No image placeholder — label-forward card per direction: bigger name
/// and price instead of an unpopulated image block. The whole card is one
/// large tap target (not just a small "add" button inside it), since
/// "tap the product to add it" is the entire interaction.
class _ProductCard extends ConsumerWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final notifier = ref.read(dashboardControllerProvider.notifier);
    final isLowStock = product.stock <= 5;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => notifier.addToCart(product),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(minHeight: _primaryTapTarget),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.borderSubtle, width: 1.5),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product.name,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.ui(
                  color: colors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: AppTypography.ui(
                      color: colors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isLowStock)
                    Text(
                      '${product.stock} left',
                      style: AppTypography.ui(
                        color: colors.warning,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
