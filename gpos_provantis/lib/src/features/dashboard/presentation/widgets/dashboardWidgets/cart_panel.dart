// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/cart_panel.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'dashboard_constants.dart';

/// --- Cart panel (left) -----------------------------------------------------

class CartPanel extends ConsumerWidget {
  const CartPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final state = ref.watch(dashboardControllerProvider);
    final notifier = ref.read(dashboardControllerProvider.notifier);

    return GestureDetector(
      // "Tap outside the sheet closes it" also means tapping over here
      // on the cart side, since the sheet only ever covers the right
      // panel. Only intercepts taps while the sheet is actually open, so
      // it never steals normal cart-line taps (stepper, remove, hold,
      // charge) the rest of the time.
      behavior: state.isCatalogSheetOpen
          ? HitTestBehavior.opaque
          : HitTestBehavior.deferToChild,
      onTap: state.isCatalogSheetOpen ? notifier.closeCatalogSheet : null,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
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
          ),
          // Darkens the cart in lockstep with the sheet opening — same
          // target opacity as the sheet's own scrim, same timing/curve
          // constants, so the two sides read as one continuous dimming
          // rather than two independently-timed effects. Purely visual;
          // the GestureDetector above (not this) handles the actual
          // dismiss tap, and IgnorePointer here keeps this layer out of
          // its way. Positioned.fill is required — without it (or
          // StackFit.expand on the Stack alone) a bare DecoratedBox has
          // no intrinsic size and paints at zero-by-zero, which is why
          // this wasn't visibly darkening anything before.
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: state.isCatalogSheetOpen ? 0.55 : 0.0,
                duration: state.isCatalogSheetOpen
                    ? catalogSheetOpenDuration
                    : catalogSheetCloseDuration,
                curve: state.isCatalogSheetOpen
                    ? Curves.easeOutCubic
                    : Curves.easeInCubic,
                child: const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black),
                ),
              ),
            ),
          ),
          // "Tap here to close" hint — subtle icon + label directly on
          // the scrim (no card/button chrome), just enough to make the
          // darkened cart legible as a dismiss surface. Purely visual
          // (IgnorePointer) since the GestureDetector wrapping the whole
          // Stack already owns the actual tap.
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: state.isCatalogSheetOpen ? 1.0 : 0.0,
                duration: state.isCatalogSheetOpen
                    ? catalogSheetOpenDuration
                    : catalogSheetCloseDuration,
                curve: state.isCatalogSheetOpen
                    ? Curves.easeOutCubic
                    : Curves.easeInCubic,
                child: const Center(child: _TapToCloseHint()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Subtle "tap to close" hint shown over the darkened cart while the
/// catalog sheet is open — no card, pill, or button chrome; just an
/// icon and label sitting directly on the dark scrim, the way a hint
/// (not a control) should read. `Colors.white` regardless of theme
/// since it's painted on top of a black scrim, not the panel's own
/// surface color.
class _TapToCloseHint extends StatelessWidget {
  const _TapToCloseHint();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.touch_app_outlined,
          size: 40,
          color: Colors.white.withOpacity(0.85),
        ),
        const SizedBox(height: 12),
        Text(
          'Tap here to close',
          style: AppTypography.ui(
            color: Colors.white.withOpacity(0.85),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Matches `TopBar`'s rendered height exactly (16 top padding + the
// 72-tall `_topBarTapTarget` profile circle + 12 bottom padding — see
// top_bar.dart) so the cart header and the top bar line up edge-to-edge
// across the cart/catalog split, rather than each sizing independently
// off their own padding + tallest child and drifting apart if either
// changes.
const double _cartHeaderHeight = 100;

class _CartHeader extends StatelessWidget {
  const _CartHeader({required this.itemCount});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      height: _cartHeaderHeight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        // V1 brand teal, not a neutral surface — see `AppPalette.teal500`
        // doc comment (the exact V1 #009184), same fill already used for
        // the emphasized "Start shift" button and the profile ring in
        // top_bar.dart. `colors.primary` would drift per-theme (it's a
        // lighter tint in dark mode); this header wants the literal
        // brand color regardless of theme, so it reads from the palette
        // directly rather than the semantic token.
        color: AppPalette.teal500,
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Current sale',
            style: AppTypography.display(
              // `onPrimary` — the token for text/icons sitting on a solid
              // primary fill — not `textPrimary`, which is tuned for the
              // neutral surface this header no longer has and would go
              // near-invisible on teal.
              color: colors.onPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          if (itemCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                // `primaryContainer`/`onPrimaryContainer` are tuned to sit
                // on the neutral background, not on `teal500` itself —
                // on top of the solid brand fill they'd lose contrast (in
                // dark mode `primaryContainer` is a darker teal, close in
                // value to the fill behind it). A translucent white pill
                // instead, same "tinted pill on a solid color" pattern as
                // `_ProfileMenuRow`'s icon backdrop in top_bar.dart, just
                // inverted for a dark-colored fill.
                color: colors.onPrimary.withOpacity(0.18),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                style: AppTypography.ui(
                  color: colors.onPrimary,
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

  /// Shared by the ✕ button and the swipe gesture so both paths agree on
  /// what "remove" means and both get the same confirmation guard — a
  /// touchscreen POS makes an accidental full-width swipe easy to
  /// trigger while scrolling the cart, so unlike a plain tap on a small
  /// target, the swipe path needs a confirm step before it actually
  /// removes anything.
  Future<bool> _confirmRemove(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) =>
          _RemoveLineConfirmationDialog(productName: line.product.name),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final notifier = ref.read(dashboardControllerProvider.notifier);

    // Keyed on product id (not the line's position) so Dismissible can
    // correctly tell lines apart as the cart reorders/shrinks — without
    // a stable key it can mis-animate or dismiss the wrong tile.
    return Dismissible(
      key: ValueKey(line.product.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmRemove(context),
      onDismissed: (_) => notifier.removeLine(line.product.id),
      background: _SwipeToRemoveBackground(colors: colors),
      child: Padding(
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
                // visually modest; the InkWell/tap area does not. Routes
                // through the same `_confirmRemove` guard as the swipe so
                // a stray tap mid-shift can't silently drop a line either.
                Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () async {
                      if (await _confirmRemove(context)) {
                        notifier.removeLine(line.product.id);
                      }
                    },
                    customBorder: const CircleBorder(),
                    child: SizedBox(
                      width: minTapTarget,
                      height: minTapTarget,
                      // Was unstyled, so it fell back to Flutter's
                      // default icon color instead of the theme — that's
                      // why it wasn't visible. `textSecondary` matches
                      // the weight of the "$X each" line right above it:
                      // present, but not competing with the product name
                      // or the line total for attention.
                      child: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Red reveal behind a cart line as it's swiped left — trailing-aligned
/// (icon/label sit at the right edge, where the swipe is headed) so the
/// affordance reads in the direction of the gesture, same idea as native
/// swipe-to-delete on iOS/Android list rows.
class _SwipeToRemoveBackground extends StatelessWidget {
  const _SwipeToRemoveBackground({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: colors.danger,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_outline_rounded, color: colors.onDanger, size: 22),
          const SizedBox(width: 8),
          Text(
            'Remove',
            style: AppTypography.ui(
              color: colors.onDanger,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Confirms before a line is actually removed — same pattern as
/// `_LogoutConfirmationDialog` in top_bar.dart (stacked full-width
/// actions, destructive on top), reused here because dropping a whole
/// cart line is the same class of hard-to-undo action mid-sale.
class _RemoveLineConfirmationDialog extends StatelessWidget {
  const _RemoveLineConfirmationDialog({required this.productName});

  final String productName;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AlertDialog(
      backgroundColor: colors.surfaceRaised,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      title: Text(
        'Remove item?',
        style: AppTypography.display(
          color: colors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      content: Text(
        '$productName will be removed from this sale.',
        style: AppTypography.ui(color: colors.textSecondary, fontSize: 15),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      actions: [
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.danger,
                    foregroundColor: colors.onDanger,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Remove',
                    style: AppTypography.ui(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Cancel',
                    style: AppTypography.ui(
                      color: colors.textSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
          width: minTapTarget,
          height: minTapTarget,
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
                  height: primaryTapTarget,
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
                  height: primaryTapTarget,
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
