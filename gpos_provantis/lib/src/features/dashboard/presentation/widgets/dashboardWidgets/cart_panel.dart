import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:gpos_provantis/src/shared/widgets/confirm_dialog.dart';
import 'dashboard_constants.dart';
import 'discount_picker_sheet.dart';
import 'payments_modal.dart';

const Duration _cartScrimAutoFadeDelay = Duration(seconds: 3);

class CartPanel extends ConsumerStatefulWidget {
  const CartPanel({super.key});

  @override
  ConsumerState<CartPanel> createState() => _CartPanelState();
}

class _CartPanelState extends ConsumerState<CartPanel> {
  bool _showScrim = false;
  Timer? _autoFadeTimer;
  bool? _wasSheetOpen;

  @override
  void dispose() {
    _autoFadeTimer?.cancel();
    super.dispose();
  }

  void _syncScrimTimer(bool isSheetOpen) {
    if (_wasSheetOpen == isSheetOpen) return;
    _wasSheetOpen = isSheetOpen;

    _autoFadeTimer?.cancel();

    if (isSheetOpen) {
      setState(() => _showScrim = true);
      _autoFadeTimer = Timer(_cartScrimAutoFadeDelay, () {
        if (mounted) setState(() => _showScrim = false);
      });
    } else {
      // Hide scrim immediately when sheet closes.
      _showScrim = false;
    }
  }

  Future<void> _handleRemoveAll(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Remove all items?',
      body: 'This clears the entire cart. This can\u2019t be undone.',
      confirmLabel: 'REMOVE ALL',
    );
    if (confirmed == true && context.mounted) {
      ref.read(dashboardControllerProvider.notifier).clearCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = ref.watch(dashboardControllerProvider);
    final notifier = ref.read(dashboardControllerProvider.notifier);

    _syncScrimTimer(state.isCatalogSheetOpen);

    return GestureDetector(
      // Tap-to-close: active while sheet is open, even if scrim has faded.
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
                _CartHeader(
                  itemCount: state.itemCount,
                  onRemoveAll: () => _handleRemoveAll(context),
                ),
                Expanded(
                  child: state.cartLines.isEmpty
                      ? const _EmptyCart()
                      : _ScrollableCartList(cartLines: state.cartLines),
                ),
                _CartFooter(state: state),
              ],
            ),
          ),
          // Darkening scrim that fades out after delay. Purely visual.
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: _showScrim ? 0.55 : 0.0,
                duration: _showScrim
                    ? catalogSheetOpenDuration
                    : catalogSheetCloseDuration,
                curve: _showScrim ? Curves.easeOutCubic : Curves.easeInCubic,
                child: const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black),
                ),
              ),
            ),
          ),
          // Tap-to-close hint overlay. Fades with scrim.
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: _showScrim ? 1.0 : 0.0,
                duration: _showScrim
                    ? catalogSheetOpenDuration
                    : catalogSheetCloseDuration,
                curve: _showScrim ? Curves.easeOutCubic : Curves.easeInCubic,
                child: const Center(child: _TapToCloseHint()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TapToCloseHint extends StatelessWidget {
  const _TapToCloseHint();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          PhosphorIcons.handPointing,
          size: 40,
          color: Colors.white.withValues(alpha: 0.85),
        ),
        const SizedBox(height: 12),
        Text(
          'Tap here to close',
          style: AppTypography.ui(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

const double _cartHeaderHeight = 100;

class _CartHeader extends StatelessWidget {
  const _CartHeader({required this.itemCount, required this.onRemoveAll});

  final int itemCount;

  final VoidCallback onRemoveAll;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      height: _cartHeaderHeight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        // V1 brand teal (used consistently across themes)
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
                // Translucent white pill on teal background
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
          const Spacer(),
          // Only shown when cart has items, requires confirmation.
          if (itemCount > 0) _RemoveAllButton(onTap: onRemoveAll),
        ],
      ),
    );
  }
}

class _RemoveAllButton extends StatelessWidget {
  const _RemoveAllButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                PhosphorIcons.trash,
                size: 18,
                color: colors.onPrimary.withOpacity(0.85),
              ),
              const SizedBox(width: 6),
              Text(
                'Remove all',
                style: AppTypography.ui(
                  color: colors.onPrimary.withOpacity(0.85),
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
              PhosphorIcons.shoppingCart,
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

class _ScrollableCartList extends StatefulWidget {
  const _ScrollableCartList({required this.cartLines});

  final List<CartLine> cartLines;

  @override
  State<_ScrollableCartList> createState() => _ScrollableCartListState();
}

class _ScrollableCartListState extends State<_ScrollableCartList> {
  final _controller = ScrollController();

  // Whether there's off-screen content above/below.
  bool _canScrollUp = false;
  bool _canScrollDown = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateScrollAffordances);
    // Check scroll affordances after first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateScrollAffordances();
    });
  }

  @override
  void didUpdateWidget(covariant _ScrollableCartList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-check scroll affordances when cart contents change.
    if (oldWidget.cartLines != widget.cartLines) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _updateScrollAffordances();
      });
    }
  }

  void _updateScrollAffordances() {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    // Small epsilon tolerance for floating point scroll position.
    const epsilon = 2.0;
    final canUp = position.pixels > position.minScrollExtent + epsilon;
    final canDown = position.pixels < position.maxScrollExtent - epsilon;
    if (canUp != _canScrollUp || canDown != _canScrollDown) {
      setState(() {
        _canScrollUp = canUp;
        _canScrollDown = canDown;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateScrollAffordances);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      children: [
        ListView.separated(
          controller: _controller,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: widget.cartLines.length,
          separatorBuilder: (_, __) =>
              Divider(height: 1, color: colors.borderSubtle),
          itemBuilder: (context, index) {
            return _CartLineTile(line: widget.cartLines[index]);
          },
        ),
        // Top fade when scrolled down.
        _EdgeFade(
          visible: _canScrollUp,
          alignment: Alignment.topCenter,
          colors: colors,
        ),
        // Bottom fade when more content below.
        _EdgeFade(
          visible: _canScrollDown,
          alignment: Alignment.bottomCenter,
          colors: colors,
        ),
        // Top scroll hint arrow.
        Positioned(
          left: 0,
          right: 0,
          top: 6,
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: _canScrollUp ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 180),
              child: _ScrollHintArrow(
                colors: colors,
                direction: _ScrollHintDirection.up,
              ),
            ),
          ),
        ),
        // Bottom scroll hint arrow.
        Positioned(
          left: 0,
          right: 0,
          bottom: 6,
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: _canScrollDown ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 180),
              child: _ScrollHintArrow(
                colors: colors,
                direction: _ScrollHintDirection.down,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Soft gradient fade at scroll viewport edges to indicate more content.
class _EdgeFade extends StatelessWidget {
  const _EdgeFade({
    required this.visible,
    required this.alignment,
    required this.colors,
  });

  final bool visible;
  final Alignment alignment;
  final AppColors colors;

  static const _fadeHeight = 28.0;

  // Peak opacity scale factor for the fade.
  static const _peakOpacityScale = 0.3;

  @override
  Widget build(BuildContext context) {
    final isTop = alignment == Alignment.topCenter;
    final peakColor = colors.shadow.withValues(
      alpha: colors.shadow.a * _peakOpacityScale,
    );

    return Positioned(
      left: 0,
      right: 0,
      top: isTop ? 0 : null,
      bottom: isTop ? null : 0,
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 180),
          child: Container(
            height: _fadeHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: isTop ? Alignment.topCenter : Alignment.bottomCenter,
                end: isTop ? Alignment.bottomCenter : Alignment.topCenter,
                colors: [peakColor, peakColor.withValues(alpha: 0)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Direction for scroll hint arrow to point.
enum _ScrollHintDirection { up, down }

/// Bouncing arrow hint to indicate scrollable content.
class _ScrollHintArrow extends StatefulWidget {
  const _ScrollHintArrow({required this.colors, required this.direction});

  final AppColors colors;
  final _ScrollHintDirection direction;

  @override
  State<_ScrollHintArrow> createState() => _ScrollHintArrowState();
}

class _ScrollHintArrowState extends State<_ScrollHintArrow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    // Bounce in the direction being pointed.
    final bounceTowards = widget.direction == _ScrollHintDirection.up
        ? -5.0
        : 5.0;
    _bounce = Tween<double>(
      begin: 0,
      end: bounceTowards,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final icon = widget.direction == _ScrollHintDirection.up
        ? PhosphorIcons.caretUp
        : PhosphorIcons.caretDown;

    return Center(
      child: AnimatedBuilder(
        animation: _bounce,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _bounce.value),
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          // decoration: BoxDecoration(
          //   color: widget.colors.primaryContainer.withValues(alpha: 0.9),
          //   borderRadius: BorderRadius.circular(999),
          // ),
          child: Icon(icon, size: 22, color: widget.colors.primary),
        ),
      ),
    );
  }
}

class _CartLineTile extends ConsumerWidget {
  const _CartLineTile({required this.line});

  final CartLine line;

  /// Confirm before removing item (used for both tap and swipe).
  Future<bool> _confirmRemove(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Remove item?',
      body: '${line.product.name} will be removed from this sale.',
      confirmLabel: 'REMOVE',
    );
    return confirmed == true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final notifier = ref.read(dashboardControllerProvider.notifier);

    // Key by product ID for correct tracking during cart reordering.
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
                    '₱${line.product.price.toStringAsFixed(2)} each',
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
                  '₱${line.lineTotal.toStringAsFixed(2)}',
                  style: AppTypography.ui(
                    color: colors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                // 56x56 tap target with confirmation guard.
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
                      // Icon color matches secondary text weight
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
          Icon(PhosphorIcons.trash, color: colors.onDanger, size: 22),
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
        _StepperButton(icon: PhosphorIcons.minus, onTap: onDecrement),
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
        _StepperButton(icon: PhosphorIcons.plus, onTap: onIncrement),
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
          // Only shown once a discount is actually applied — mirrors
          // "Remove all"/"Remove discount" only appearing once there's
          // something to act on, rather than a permanent zero-value row.
          if (state.hasDiscount) ...[
            const SizedBox(height: 4),
            _TotalsRow(
              label:
                  'Discount (${state.selectedDiscount!.name} '
                  '\u2013 ${state.selectedDiscount!.rate}%)',
              value: -state.discountAmount,
              colors: colors,
              valueColor: colors.primary,
            ),
          ],
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
                '₱${state.total.toStringAsFixed(2)}',
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
                  child: OutlinedButton.icon(
                    onPressed: hasItems
                        ? () => showDiscountPickerSheet(context)
                        : null,
                    icon: Icon(
                      PhosphorIcons.percent,
                      size: 18,
                      color: hasItems ? colors.primary : colors.textDisabled,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.primary,
                      side: BorderSide(
                        color: hasItems ? colors.primary : colors.border,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    // Label reflects whichever discount (if any) is
                    // currently applied, same "button doubles as status"
                    // pattern the old hold button used ('Hold sale' ->
                    // 'Held') — tapping again re-opens the sheet to
                    // switch or clear it, rather than needing a separate
                    // control just to change discounts.
                    label: Text(
                      state.hasDiscount
                          ? '${state.selectedDiscount!.rate}% off'
                          : 'Discount',
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
                    // Modal, not a full-screen route — see the doc
                    // comment atop payment_modal.dart for why.
                    onPressed: hasItems
                        ? () => showPaymentModal(context)
                        : null,
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
                      'Charge ₱${state.total.toStringAsFixed(2)}',
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
    this.valueColor,
  });

  final String label;
  final double value;
  final AppColors colors;

  /// Overrides the value text's color — used for the discount row so it
  /// reads as a distinct, non-neutral line in the breakdown rather than
  /// blending into the plain subtotal/tax rows above it.
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final isNegative = value < 0;
    final formatted =
        '${isNegative ? '\u2212' : ''}\u20b1${value.abs().toStringAsFixed(2)}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.ui(color: colors.textSecondary, fontSize: 14),
        ),
        Text(
          formatted,
          style: AppTypography.ui(
            color: valueColor ?? colors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
