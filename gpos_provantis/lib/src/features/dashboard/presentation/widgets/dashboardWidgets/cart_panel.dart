import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:gpos_provantis/src/shared/widgets/confirm_dialog.dart';
import 'dashboard_constants.dart';
import 'money_format.dart';
import 'discount_picker_sheet.dart';
import 'payments_modal.dart';
import 'customer_panel.dart';

const Duration _cartScrimAutoFadeDelay = Duration(seconds: 3);

const double _cardRadius = 16;

String _money(double v) => formatPeso(v);

/// Digits that don't jiggle when quantities / totals change.
TextStyle _amountStyle({
  required Color color,
  double fontSize = 15,
  FontWeight fontWeight = FontWeight.w600,
}) {
  return AppTypography.ui(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
  ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
}

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
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: state.cartLines.isEmpty
                        ? const _EmptyCart(key: ValueKey('empty'))
                        : _ScrollableCartList(
                            key: const ValueKey('list'),
                            cartLines: state.cartLines,
                          ),
                  ),
                ),
                _CartFooter(state: state),
              ],
            ),
          ),

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

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────

/// Kept at 100 so it still lines up with the catalog header next to it.
const double _cartHeaderHeight = 100;

class _CartHeader extends StatelessWidget {
  const _CartHeader({required this.itemCount, required this.onRemoveAll});

  final int itemCount;
  final VoidCallback onRemoveAll;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasItems = itemCount > 0;

    return Container(
      width: double.infinity,
      height: _cartHeaderHeight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current sale',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.display(
                    color: colors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hasItems ? colors.primary : colors.textDisabled,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      hasItems
                          ? '$itemCount ${itemCount == 1 ? 'item' : 'items'}'
                          : 'No items yet',
                      style: AppTypography.ui(
                        color: colors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (hasItems) _RemoveAllButton(onTap: onRemoveAll),
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
      color: colors.danger.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: minTapTarget),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(PhosphorIcons.trash, size: 18, color: colors.danger),
                const SizedBox(width: 8),
                Text(
                  'Remove all',
                  style: AppTypography.ui(
                    color: colors.danger,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({super.key});

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
              width: 112,
              height: 112,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primaryContainer.withValues(alpha: 0.35),
              ),
              child: Container(
                width: 76,
                height: 76,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primaryContainer,
                ),
                child: Icon(
                  PhosphorIcons.shoppingCart,
                  size: 34,
                  color: colors.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'Start a new sale',
              style: AppTypography.display(
                color: colors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap a product on the right to add it here.',
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

// ─────────────────────────────────────────────────────────────────────────────
// List
// ─────────────────────────────────────────────────────────────────────────────

class _ScrollableCartList extends StatefulWidget {
  const _ScrollableCartList({super.key, required this.cartLines});

  final List<CartLine> cartLines;

  @override
  State<_ScrollableCartList> createState() => _ScrollableCartListState();
}

class _ScrollableCartListState extends State<_ScrollableCartList> {
  final _controller = ScrollController();

  bool _canScrollUp = false;
  bool _canScrollDown = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateScrollAffordances);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateScrollAffordances();
    });
  }

  @override
  void didUpdateWidget(covariant _ScrollableCartList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.cartLines != widget.cartLines) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _updateScrollAffordances();
      });
    }
  }

  void _updateScrollAffordances() {
    if (!_controller.hasClients) return;
    final position = _controller.position;

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
        ListView.builder(
          controller: _controller,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          itemCount: widget.cartLines.length,
          itemBuilder: (context, index) {
            return _CartLineTile(line: widget.cartLines[index]);
          },
        ),

        _EdgeFade(
          visible: _canScrollUp,
          alignment: Alignment.topCenter,
          colors: colors,
        ),
        _EdgeFade(
          visible: _canScrollDown,
          alignment: Alignment.bottomCenter,
          colors: colors,
        ),

        Positioned(
          left: 0,
          right: 0,
          top: 8,
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

        Positioned(
          left: 0,
          right: 0,
          bottom: 8,
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

/// Fades list content into the panel surface (instead of a grey shadow).
class _EdgeFade extends StatelessWidget {
  const _EdgeFade({
    required this.visible,
    required this.alignment,
    required this.colors,
  });

  final bool visible;
  final Alignment alignment;
  final AppColors colors;

  static const _fadeHeight = 36.0;

  @override
  Widget build(BuildContext context) {
    final isTop = alignment == Alignment.topCenter;

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
                colors: [
                  colors.surface,
                  colors.surface.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _ScrollHintDirection { up, down }

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

    final bounceTowards = widget.direction == _ScrollHintDirection.up
        ? -4.0
        : 4.0;
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
    final colors = widget.colors;
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
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.surfaceRaised,
            border: Border.all(color: colors.border),
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 18, color: colors.primary),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Line item
// ─────────────────────────────────────────────────────────────────────────────

class _CartLineTile extends ConsumerWidget {
  const _CartLineTile({required this.line});

  final CartLine line;

  static const double _avatarSize = 44;

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

    final card = Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 8, 8),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(_cardRadius),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Monogram(name: line.product.name, size: _avatarSize),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      line.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.ui(
                        color: colors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${_money(line.product.price)} each',
                      style: _amountStyle(
                        color: colors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  _money(line.lineTotal),
                  style: _amountStyle(
                    color: colors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: _avatarSize + 12),
              _QuantityStepper(
                quantity: line.quantity,
                onDecrement: () => notifier.decrementLine(line.product.id),
                onIncrement: () => notifier.incrementLine(line.product.id),
              ),
              const Spacer(),
              _IconAction(
                icon: PhosphorIcons.trash,
                tooltip: 'Remove item',
                onTap: () async {
                  if (await _confirmRemove(context)) {
                    notifier.removeLine(line.product.id);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_cardRadius),
        child: Dismissible(
          key: ValueKey(line.product.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) => _confirmRemove(context),
          onDismissed: (_) => notifier.removeLine(line.product.id),
          background: _SwipeToRemoveBackground(colors: colors),
          child: card,
        ),
      ),
    );
  }
}

/// Soft initial-letter tile standing in for a product photo.
class _Monogram extends StatelessWidget {
  const _Monogram({required this.name, required this.size});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final trimmed = name.trim();
    final letter = trimmed.isEmpty ? '?' : trimmed.characters.first.toUpperCase();

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        letter,
        style: AppTypography.display(
          color: colors.onPrimaryContainer,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: minTapTarget,
            height: minTapTarget,
            child: Icon(icon, size: 20, color: colors.textSecondary),
          ),
        ),
      ),
    );
  }
}

class _SwipeToRemoveBackground extends StatelessWidget {
  const _SwipeToRemoveBackground({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 22),
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

/// Pill-shaped stepper: [ − ]  2  [ + ]
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

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: PhosphorIcons.minus,
            onTap: onDecrement,
            color: colors.textSecondary,
          ),
          SizedBox(
            width: 36,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Text(
                '$quantity',
                key: ValueKey(quantity),
                textAlign: TextAlign.center,
                style: _amountStyle(
                  color: colors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          _StepperButton(
            icon: PhosphorIcons.plus,
            onTap: onIncrement,
            color: colors.primary,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: minTapTarget,
          height: minTapTarget,
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Footer
// ─────────────────────────────────────────────────────────────────────────────

class _CartFooter extends ConsumerWidget {
  const _CartFooter({required this.state});

  final DashboardState state;

  /// Charge: first ask who the customer is (if the store has that switched
  /// on), then go on to payment. Closing the customer sheet without choosing
  /// stops here, so nothing is charged by accident.
  Future<void> _charge(BuildContext context, WidgetRef ref) async {
    final proceed = await CustomerPanel.promptBeforePayment(context, ref);
    if (!proceed || !context.mounted) return;
    showPaymentModal(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final hasItems = state.cartLines.isNotEmpty;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        // Dark surfaces swallow shadows and make them look muddy, so there the
        // separation comes from a slightly stronger top border instead.
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DiscountTile(
            enabled: hasItems,
            applied: state.hasDiscount,
            title: state.hasDiscount
                ? state.selectedDiscount!.name
                : 'Add discount',
            subtitle: state.hasDiscount
                ? '${state.selectedDiscount!.rate}% off applied'
                : null,
            onTap: () => showDiscountPickerSheet(context),
          ),
          const SizedBox(height: 14),
          _TotalsRow(label: 'Subtotal', value: state.subtotal, colors: colors),
          if (state.hasDiscount) ...[
            const SizedBox(height: 6),
            _TotalsRow(
              label: 'Discount (${state.selectedDiscount!.rate}%)',
              value: -state.discountAmount,
              colors: colors,
              valueColor: colors.primary,
            ),
          ],
          const SizedBox(height: 12),
          Divider(height: 1, color: colors.border),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTypography.ui(
                  color: colors.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _money(state.total),
                style: AppTypography.display(
                  color: colors.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: primaryTapTarget,
            child: ElevatedButton(
              onPressed: hasItems ? () => _charge(context, ref) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                disabledBackgroundColor: colors.disabledFill,
                disabledForegroundColor: colors.textDisabled,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Charge',
                    style: AppTypography.ui(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _money(state.total),
                    style: _amountStyle(
                      color: hasItems ? colors.onPrimary : colors.textDisabled,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(PhosphorIcons.caretRight, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A full-width row that replaces the old outlined "Discount" button. Reads as
/// a coupon slot: neutral when empty, tinted when a discount is applied.
class _DiscountTile extends StatelessWidget {
  const _DiscountTile({
    required this.enabled,
    required this.applied,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final bool enabled;
  final bool applied;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final fill = applied ? colors.primaryContainer : colors.background;
    final fg = !enabled
        ? colors.textDisabled
        : applied
        ? colors.onPrimaryContainer
        : colors.textPrimary;
    final iconBg = applied
        ? colors.primary.withValues(alpha: 0.18)
        : colors.surfaceVariant;
    final iconFg = !enabled ? colors.textDisabled : colors.primary;

    return Material(
      color: fill,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(minHeight: minTapTarget),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: applied
                  ? colors.primary.withValues(alpha: 0.45)
                  : colors.border.withValues(alpha: 0.6),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(PhosphorIcons.percent, size: 16, color: iconFg),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.ui(
                        color: fg,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: AppTypography.ui(
                          color: fg.withValues(alpha: 0.8),
                          fontSize: 12.5,
                        ),
                      ),
                  ],
                ),
              ),
              if (applied)
                Text(
                  'Change',
                  style: AppTypography.ui(
                    color: fg,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              const SizedBox(width: 4),
              Icon(PhosphorIcons.caretRight, size: 16, color: fg),
            ],
          ),
        ),
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

  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final isNegative = value < 0;
    final formatted = '${isNegative ? '\u2212' : ''}${_money(value.abs())}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.ui(color: colors.textSecondary, fontSize: 14),
        ),
        Text(
          formatted,
          style: _amountStyle(
            color: valueColor ?? colors.textSecondary,
            fontSize: 14,
            fontWeight: valueColor != null ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
