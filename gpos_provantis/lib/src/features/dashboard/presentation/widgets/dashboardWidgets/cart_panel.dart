// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/cart_panel.dart
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

/// --- Cart panel (left) -----------------------------------------------------

/// How long the darkening scrim + "Tap here to close" hint stay visible
/// after the catalog sheet opens, before fading themselves out on their
/// own. Tap-to-dismiss itself is NOT on a timer — it keeps working for
/// as long as the sheet is open, this only controls how long the visual
/// reminder sticks around before getting out of the way so the cart
/// items underneath are fully legible again.
const Duration _cartScrimAutoFadeDelay = Duration(seconds: 3);

class CartPanel extends ConsumerStatefulWidget {
  const CartPanel({super.key});

  @override
  ConsumerState<CartPanel> createState() => _CartPanelState();
}

class _CartPanelState extends ConsumerState<CartPanel> {
  // Whether the scrim/hint should currently be visible. Distinct from
  // `state.isCatalogSheetOpen` on purpose: the sheet can stay open far
  // longer than 3 seconds, but the darkening + hint shouldn't — this
  // flag is what actually drives their opacity, separately from
  // whether the sheet itself is still open.
  bool _showScrim = false;
  Timer? _autoFadeTimer;
  bool? _wasSheetOpen;

  @override
  void dispose() {
    _autoFadeTimer?.cancel();
    super.dispose();
  }

  // Called every build with the sheet's current open/closed state.
  // Using `didChangeDependencies`-style manual diffing here (a plain
  // `bool? _wasSheetOpen` compared each build) rather than
  // `ref.listen`, since this widget already reads `isCatalogSheetOpen`
  // via `ref.watch` in `build` for layout purposes anyway — a second
  // separate listener would just be reacting to the same value twice.
  void _syncScrimTimer(bool isSheetOpen) {
    if (_wasSheetOpen == isSheetOpen) return;
    _wasSheetOpen = isSheetOpen;

    _autoFadeTimer?.cancel();

    if (isSheetOpen) {
      // Freshly opened: show the scrim/hint immediately, then start the
      // countdown to fade them back out. Re-opening after a close
      // always restarts this from full visibility — there's no
      // "remembers it already faded once" state, since the user
      // closing and re-opening the sheet is a new enough moment to earn
      // the reminder again.
      setState(() => _showScrim = true);
      _autoFadeTimer = Timer(_cartScrimAutoFadeDelay, () {
        if (mounted) setState(() => _showScrim = false);
      });
    } else {
      // Sheet just closed: hide immediately rather than waiting out
      // whatever's left of the 3 seconds — there's nothing left to
      // hint at once the sheet itself is gone.
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
      // "Tap outside the sheet closes it" also means tapping over here
      // on the cart side, since the sheet only ever covers the right
      // panel. Only intercepts taps while the sheet is actually open, so
      // it never steals normal cart-line taps (stepper, remove, hold,
      // charge) the rest of the time. This stays active for the sheet's
      // entire open duration, independent of `_showScrim` — the scrim
      // fading out after 3 seconds is purely visual and doesn't mean
      // tap-to-close stops working, it just means the cart is fully
      // visible again while it's still tappable-to-dismiss underneath.
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
          // Darkens the cart while the sheet is freshly open, then fades
          // itself back out after `_cartScrimAutoFadeDelay` (see
          // `_showScrim`) so the cart items are fully visible again
          // without the user having to do anything. Fades in using the
          // same timing/curve constants the sheet's own opening scrim
          // uses, so the two sides read as one continuous dimming at
          // the moment the sheet opens; the *fade back out* on the
          // timer uses the sheet's close-duration/curve as well, purely
          // because it's the same "dismiss-flavored" motion, not
          // because the sheet is actually closing. Purely visual; the
          // GestureDetector above (not this) handles the actual dismiss
          // tap, and IgnorePointer here keeps this layer out of its
          // way. Positioned.fill is required — without it (or
          // StackFit.expand on the Stack alone) a bare DecoratedBox has
          // no intrinsic size and paints at zero-by-zero.
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
          // "Tap here to close" hint — subtle icon + label directly on
          // the scrim (no card/button chrome), just enough to make the
          // darkened cart legible as a dismiss surface for the same
          // `_showScrim` window as the darkening above, then fades out
          // alongside it. Purely visual (IgnorePointer) since the
          // GestureDetector wrapping the whole Stack already owns the
          // actual tap — and keeps owning it even once this hint (and
          // the darkening) have faded away.
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

/// Subtle "tap to close" hint shown over the darkened cart while the
/// catalog sheet is freshly open — no card, pill, or button chrome;
/// just an icon and label sitting directly on the dark scrim, the way a
/// hint (not a control) should read. Fades out (see `_showScrim` in
/// `_CartPanelState`) a few seconds after appearing rather than staying
/// up for as long as the sheet itself is open. `Colors.white` regardless
/// of theme since it's painted on top of a black scrim, not the panel's
/// own surface color.
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

// Matches `TopBar`'s rendered height exactly (16 top padding + the
// 72-tall `_topBarTapTarget` profile circle + 12 bottom padding — see
// top_bar.dart) so the cart header and the top bar line up edge-to-edge
// across the cart/catalog split, rather than each sizing independently
// off their own padding + tallest child and drifting apart if either
// changes.
const double _cartHeaderHeight = 100;

class _CartHeader extends StatelessWidget {
  const _CartHeader({required this.itemCount, required this.onRemoveAll});

  final int itemCount;

  /// Null-safe by construction from the caller (`CartPanel` only ever
  /// passes `notifier.clearCart` here), but the button itself only
  /// renders `if (itemCount > 0)` below — an empty cart has nothing to
  /// remove, so the action shouldn't be offered at all rather than
  /// rendered-but-disabled.
  final VoidCallback onRemoveAll;

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
          const Spacer(),
          // Only offered once there's actually something to clear — an
          // empty cart has nothing for this to do, so it's absent
          // rather than rendered-and-disabled. Confirms first via the
          // same shared `showConfirmDialog` Logout already uses in
          // top_bar.dart — clearing an entire in-progress sale is just
          // as hard to walk back as logging out mid-shift, so it gets
          // the same "are you sure" guard rather than firing on a
          // single accidental tap.
          if (itemCount > 0) _RemoveAllButton(onTap: onRemoveAll),
        ],
      ),
    );
  }
}

/// "Remove all" — clears every line from the cart in one tap instead of
/// making the cashier back out each line individually via its own swipe
/// or trash icon (see `_CartLineTile`). Text-only, no button chrome, so
/// it doesn't visually compete with the item-count pill for attention
/// in a header that's otherwise just a title — same "hint/secondary
/// action sits quietly" spirit as `_TapToCloseHint` rather than a full
/// `ElevatedButton`. `colors.onPrimary` at reduced opacity (not
/// `colors.danger`) since this sits on the solid teal header fill,
/// where the danger-red token isn't guaranteed enough contrast against
/// brand teal in every theme; the destructive weight instead comes from
/// the confirm dialog it opens, not the button's own color.
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

/// Wraps the cart's `ListView.separated` with two pieces of "there's more
/// content" feedback that only appear when they're actually true:
///   - a soft shadow/gradient fade at whichever edge (top and/or bottom)
///     still has off-screen content, so a long cart doesn't just end
///     abruptly at the header/footer seam with no visual cue it's a
///     scrollable region rather than the full list.
///   - a small downward arrow hovering just above the footer, shown only
///     while there's more to scroll to below — nudges a cashier who
///     might not otherwise think to try scrolling a POS panel.
/// Needs to be stateful since it listens to the `ScrollController` to
/// decide whether either edge currently has more content.
class _ScrollableCartList extends StatefulWidget {
  const _ScrollableCartList({required this.cartLines});

  final List<CartLine> cartLines;

  @override
  State<_ScrollableCartList> createState() => _ScrollableCartListState();
}

class _ScrollableCartListState extends State<_ScrollableCartList> {
  final _controller = ScrollController();

  // Whether there's currently off-screen content above/below the
  // viewport. Both start false and get corrected on the first post-frame
  // check once real content dimensions are known — starting `true` would
  // flash a fade/arrow for a split second on short carts that were never
  // actually scrollable.
  bool _canScrollUp = false;
  bool _canScrollDown = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateScrollAffordances);
    // Content isn't laid out yet during initState — check again right
    // after the first frame so a cart that opens already-scrollable
    // (e.g. resumed from a held sale with many lines) shows the bottom
    // fade/arrow immediately instead of waiting for the first scroll
    // event.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateScrollAffordances();
    });
  }

  @override
  void didUpdateWidget(covariant _ScrollableCartList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cart contents changed (line added/removed/qty changed) — the
    // scrollable extent may have changed with it, so re-check after this
    // frame builds rather than waiting for the next manual scroll.
    if (oldWidget.cartLines != widget.cartLines) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _updateScrollAffordances();
      });
    }
  }

  void _updateScrollAffordances() {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    // A small epsilon rather than an exact 0/max comparison — floating
    // point scroll extents can land a fraction of a pixel short of the
    // true edge even when visually fully scrolled.
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
        // Top fade — sits just under the header, only visible once the
        // list has been scrolled down from the very top.
        _EdgeFade(
          visible: _canScrollUp,
          alignment: Alignment.topCenter,
          colors: colors,
        ),
        // Bottom fade — sits just above the footer, visible whenever
        // there's more content below the fold.
        _EdgeFade(
          visible: _canScrollDown,
          alignment: Alignment.bottomCenter,
          colors: colors,
        ),
        // Top scroll-hint arrow — mirrors the bottom one below, shown
        // only while there's unscrolled content above (i.e. the cashier
        // has scrolled down and might not realize there's more above).
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
        // Bottom scroll-hint arrow, layered on top of the bottom fade —
        // same visibility condition (only while there's more below), but
        // its own widget so the fade and the arrow can be tuned
        // independently later without tangling their logic together.
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

/// Soft gradient fade at one edge of the scroll viewport — the visual
/// language for "there's more content this way" (same idea as a fading
/// horizontal scroller, just vertical here). `IgnorePointer` since this
/// is a pure overlay and must never intercept the taps/drags meant for
/// the list underneath it.
///
/// Lightened from the first pass, which used `colors.shadow` at full
/// strength — that token is tuned for drop shadows under raised cards,
/// not a soft top/bottom vignette, and read as a noticeably dark band
/// here. Peak opacity is now scaled down (30% of the token's own alpha)
/// so it stays a gentle cue rather than competing with the content.
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

  // Fraction of `colors.shadow`'s own alpha used at the fade's darkest
  // point. Tuned down from full strength (1.0) — see class doc comment.
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

/// Which way a `_ScrollHintArrow` points and bounces — toward whichever
/// edge still has unscrolled content.
enum _ScrollHintDirection { up, down }

/// Small bouncing chevron near an edge of the cart list — the "psst,
/// there's more this way" nudge. One arrow lives just under the header
/// (pointing up, for content already scrolled past) and one just above
/// the footer (pointing down, for content not yet scrolled to); both use
/// this same widget, just with an opposite `direction`. Purely decorative
/// (wrapped in `IgnorePointer` by the caller), looping for as long as
/// it's visible rather than a one-shot animation, since a cashier
/// glancing at the screen mid-shift might miss a single bounce.
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
    // Bounce toward the direction being pointed at — an "up" arrow
    // nudges upward (negative offset), a "down" arrow nudges downward.
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

  /// Shared by the ✕ button and the swipe gesture so both paths agree on
  /// what "remove" means and both get the same confirmation guard — a
  /// touchscreen POS makes an accidental full-width swipe easy to
  /// trigger while scrolling the cart, so unlike a plain tap on a small
  /// target, the swipe path needs a confirm step before it actually
  /// removes anything.
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
