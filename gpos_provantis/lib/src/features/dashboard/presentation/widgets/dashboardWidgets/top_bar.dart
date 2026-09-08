// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/top_bar.dart
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/core/database/providers/branch_config_dao_provider.dart';
import 'package:gpos_provantis/src/shared/widgets/confirm_dialog.dart';

/// --- Top bar: status only (branch, time, shift, OR number) + branding -----
///
/// This bar used to also carry Start/End shift, Cash drop, Reprint,
/// Settings, and Others — those are now a second action row inside
/// `CatalogPanel` (see `catalog_panel.dart`), directly below this bar.
/// This bar's only job now is orientation: which branch/terminal this
/// is, what time it is, which shift is running, and the OR (official
/// receipt) number in progress.
///
/// BRANCH NAME + LOGO: both now come from `branchConfigProvider` (a
/// `StreamNotifierProvider` over the locally-synced branch config row,
/// same pattern as `categoriesProvider`/`productPriceProvider` — see
/// `_watchBranchName()` and `_BranchLogo` below). The top-right avatar
/// that used to be a generic person icon is now the branch's own logo,
/// since a POS terminal only ever has one operator profile worth
/// showing here anyway: the branch it's running for. Tapping it still
/// opens the same Settings/Logout dropdown as before — only the glyph
/// changed, not the menu behind it.
///
/// IMPORT PATH NOTE: `branchConfigDaoProvider`/`branchConfigProvider`
/// were only seen referenced (not defined) elsewhere in this codebase —
/// their defining file wasn't available to check directly. The import
/// below (`.../providers/branch_config_dao_provider.dart`) is inferred
/// from the same naming convention `categories_dao_provider.dart` and
/// `product_price_dao_provider.dart` already follow; update this one
/// line if the real file lives somewhere else.
///
/// `BranchConfigDto.logo` (and therefore the synced table column) is a
/// base64-encoded image string — decoded locally, not fetched over the
/// network. Confirmed in practice to be an SVG (the decoded bytes are
/// XML text starting `<?xml ...` / `<svg ...`), but nothing guarantees
/// every branch's logo will be — so after decoding, the bytes are
/// sniffed (see `_LogoFormat`/`_decodeLogoBytes`) and routed to either
/// `flutter_svg`'s `SvgPicture.memory` (SVG/XML) or `Image.memory`
/// (PNG/JPEG/WebP/GIF/BMP/...), rather than assuming one or the other.
/// Every failure mode degrades to the fallback icon instead of throwing:
/// malformed base64, a missing `=` padding, an accidental
/// `data:image/...;base64,` prefix, valid base64 that isn't a
/// real/complete image, and — specific to SVG — markup that isn't valid
/// XML or that `flutter_svg` otherwise can't parse. A bad logo value
/// should never be able to crash this screen.
///
/// Shift number and OR number are still placeholder literals ("1",
/// "100000000") — there's no session/shift-count or OR-number source
/// wired up yet, unlike branch name/logo. Swap `_StatusItem`'s values
/// for real state once that exists; the layout doesn't need to change.
///
/// Back to a `ConsumerWidget` (it was briefly not one, before branch
/// config was wired in) since `_BranchLogo`/`_StatusItem`'s branch value
/// now both read `branchConfigProvider`.

// Pinned explicitly rather than left to resolve implicitly from padding
// + tallest child (16 + 72 + 12 = 100, in theory). `_CartHeader` in
// cart_panel.dart is pinned to the same literal value so the two bottom
// borders land on exactly the same row across the cart/catalog seam —
// letting both sides compute their own "100" independently left them a
// hair off in practice, so this is now the single source of truth for
// that shared height. If you change this, update `_cartHeaderHeight` in
// cart_panel.dart to match.
const double _topBarHeight = 100;

class TopBar extends ConsumerWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final branchName = _watchBranchName(ref);

    return Container(
      width: double.infinity,
      height: _topBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _StatusItem(label: 'Branch', value: branchName),
                  _StatusDivider(),
                  const _ClockStatusItem(),
                  _StatusDivider(),
                  // Shift status doubles as the "Shift" value here since
                  // there's no separate open/close shift number in the
                  // controller yet — "1" is the placeholder shift count.
                  const _StatusItem(label: 'Shift', value: '1'),
                  _StatusDivider(),
                  const _StatusItem(label: 'OR number', value: '100000000'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          const _ProfileMenu(),
        ],
      ),
    );
  }
}

/// Reads the synced branch config row's `branchName` off
/// `branchConfigProvider`, falling back to an em-dash while the row
/// hasn't synced yet (right after login — same "don't show fake data,
/// show an honest placeholder-for-loading" spirit as the category/
/// product grids' loading states) or if the stream errors.
///
/// TYPE ASSUMPTION: written against `branchConfigProvider` emitting
/// `AsyncValue<BranchConfigTableData?>` — a single nullable row, not a
/// list — since branch config is a one-row-per-terminal singleton (see
/// `ProductPriceRepository.fetchAndSaveProductPrices()`'s use of
/// `branchConfigDao.getBranch()`, which returns one config, not a list).
/// If the real provider is list-shaped instead (mirroring
/// `categoriesProvider`), swap `config?.branchName` below for
/// `configs.firstOrNull?.branchName` and adjust `_BranchLogo` the same
/// way.
String _watchBranchName(WidgetRef ref) {
  final asyncConfig = ref.watch(branchConfigProvider);
  return asyncConfig.when(
    data: (config) {
      final name = config?.branchName.trim() ?? '';
      return name.isNotEmpty ? name : '—';
    },
    error: (_, __) => '—',
    loading: () => '—',
  );
}

/// A thin vertical rule between status items — these four values (branch,
/// time, shift, OR number) really are one flat list of "current session
/// facts", so a divider here is earning its keep (unlike the profile
/// dropdown's Settings/Logout, which aren't a sequence and don't get
/// one) by giving the eye a place to break between unrelated units
/// (a place name vs a clock vs a count).
class _StatusDivider extends StatelessWidget {
  const _StatusDivider();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 18),
      color: colors.borderSubtle,
    );
  }
}

/// Label-over-value status readout — "Branch", "Shift", "OR number" all
/// render through this; only the live clock needs its own stateful
/// widget (see `_ClockStatusItem` below).
class _StatusItem extends StatelessWidget {
  const _StatusItem({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppTypography.ui(
            color: colors.textDisabled,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.ui(
            color: valueColor ?? colors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Live clock, ticking once a minute (a POS status row needs the current
/// time to be correct, not the current second — a per-second timer would
/// just be extra rebuilds with no visible benefit). Isolated in its own
/// `StatefulWidget` so only this small readout rebuilds on each tick,
/// not the whole top bar.
class _ClockStatusItem extends StatefulWidget {
  const _ClockStatusItem();

  @override
  State<_ClockStatusItem> createState() => _ClockStatusItemState();
}

class _ClockStatusItemState extends State<_ClockStatusItem> {
  late DateTime _now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    // Align the first tick to the next minute boundary, then tick every
    // minute on the minute, so the displayed time doesn't drift a few
    // seconds off from wall-clock minutes over a long shift.
    final msToNextMinute =
        Duration(minutes: 1) -
        Duration(seconds: _now.second, milliseconds: _now.millisecond);
    Timer(msToNextMinute, _tick);
  }

  void _tick() {
    if (!mounted) return;
    setState(() => _now = DateTime.now());
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formatted {
    final hour24 = _now.hour;
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final minute = _now.minute.toString().padLeft(2, '0');
    final period = hour24 < 12 ? 'AM' : 'PM';
    return '$hour12:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return _StatusItem(label: 'Time', value: _formatted);
  }
}

/// --- Profile menu: avatar that morphs into its own dropdown -----------

enum _ProfileMenuAction { settings, logout }

/// Slightly larger than [primaryTapTarget] — touchscreen POS, and every
/// control in this top bar (shift toggle, cash drop, reprint, others,
/// profile) is a high-frequency action, so the whole row errs on the
/// side of bigger rather than sitting at the shared cross-app floor.
/// Scoped to `top_bar.dart` only — deliberately not a change to
/// `primaryTapTarget` itself, which other screens (cart, catalog,
/// product grid) still rely on at its original size.
const double _topBarTapTarget = 72;

/// Final size of the morphed dropdown panel, once it's finished growing
/// out of the circle. Width matches `PopupMenuButton`'s old
/// `minWidth: 208`; height is the two 52-tall rows from
/// `_ProfileMenuRow` plus the same 8-top/8-bottom vertical padding the
/// old menu used (52 * 2 + 8 * 2 = 120).
const double _profileMenuWidth = 208;
const double _profileMenuHeight = 120;

/// How long the circle takes to grow into the panel (and shrink back).
/// Slow enough to actually read as one shape becoming another rather
/// than a generic fade/scale — quick enough not to make a
/// high-frequency touchscreen control feel laggy to open.
const Duration _profileMenuMorphDuration = Duration(milliseconds: 260);

/// Circular, bordered avatar pinned at the top-right of the top bar —
/// the branch's own logo (see `_BranchLogo`), since this terminal only
/// ever represents one branch. Tapping it no longer just opens a
/// separate `PopupMenuButton` floating below — the circle itself grows
/// into the Settings/Logout panel, then shrinks back to a circle when
/// dismissed, so the avatar visibly *becomes* the menu rather than
/// spawning an unrelated shape next to it. See `_ProfileMenuOverlay` for
/// how the morph itself is built (a `PopupMenuButton`'s content renders
/// in its own detached route, which can't be animated as one continuous
/// shape with the button that opened it — this widget manages its own
/// `OverlayEntry` instead specifically so the same box can be the
/// circle at t=0 and the panel at t=1). Settings reuses the same handler
/// as the top bar's own Settings button rather than duplicating a
/// second, separately-wired no-op — the two entry points should always
/// do the same thing. Logout always confirms first via the shared
/// `showConfirmDialog` (see `confirm_dialog.dart`) before this widget
/// calls through to the actual sign-out hook.
class _ProfileMenu extends ConsumerStatefulWidget {
  const _ProfileMenu();

  @override
  ConsumerState<_ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends ConsumerState<_ProfileMenu>
    with SingleTickerProviderStateMixin {
  final _layerLink = LayerLink();
  late final AnimationController _controller;
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _profileMenuMorphDuration,
    );
  }

  @override
  void dispose() {
    // Removing a still-inserted overlay entry on dispose (rather than
    // only on the normal close path) matters here specifically because
    // this widget — unlike a `PopupMenuButton`'s own route — owns the
    // overlay entry itself: if `_ProfileMenu` ever got torn down while
    // open (hot reload, an ancestor rebuild that unmounts it), a
    // dangling entry would keep painting a menu with no button behind
    // it and no way left to close it.
    _overlayEntry?.remove();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSelection(_ProfileMenuAction action) async {
    await _close();
    if (!mounted) return;
    switch (action) {
      case _ProfileMenuAction.settings:
        break;
      case _ProfileMenuAction.logout:
        final confirmed = await showConfirmDialog(
          context,
          title: 'Logout?',
          body: 'You\u2019ll need to sign back in to continue using the till.',
          confirmLabel: 'LOGOUT',
        );
        if (confirmed == true && context.mounted) {
          context.go('/login');
        }
    }
  }

  void _toggle() {
    if (_isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    if (_isOpen) return;
    _isOpen = true;
    _overlayEntry = OverlayEntry(
      builder: (context) => _ProfileMenuOverlay(
        layerLink: _layerLink,
        controller: _controller,
        onSelected: _handleSelection,
        onDismiss: _close,
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();
  }

  // Returns a future that resolves once the shrink-back-to-circle
  // animation finishes, so `_handleSelection` can wait for the panel to
  // visually close before a confirm dialog pops up on top of it —
  // opening a second overlay mid-morph would show both animating at
  // once.
  Future<void> _close() async {
    if (!_isOpen) return;
    _isOpen = false;
    await _controller.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return CompositedTransformTarget(
      link: _layerLink,
      // Full-size circle (not a smaller circle padded inside a bigger
      // tap box) so it reads at the same visual weight as the
      // primaryTapTarget-tall buttons on the left, not just the same
      // tap area. Sized a step above primaryTapTarget — this is a
      // touchscreen POS terminal, and the profile icon is a
      // high-frequency top-bar control same as Start shift/Others, not
      // a secondary action, so it gets the same "err large" treatment.
      //
      // This circle stays mounted and visible for the entire open/close
      // cycle rather than disappearing once the overlay appears — the
      // overlay's own morphing box starts perfectly on top of it (same
      // `CompositedTransformTarget` anchor) and only becomes visually
      // distinct once it's grown past the circle's own bounds, so the
      // handoff between "real button" and "morphing panel" is invisible
      // to the eye.
      child: GestureDetector(
        onTap: _toggle,
        child: Container(
          width: _topBarTapTarget,
          height: _topBarTapTarget,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.surfaceVariant,
            // V1 brand teal, not the neutral `colors.border` — a
            // borderSubtle-style gray reads as barely-there on purpose
            // for quiet dividers, which is exactly why it looked
            // "barely seeable" here. AppPalette.teal500 (#009184) is
            // the exact V1 brand color, already used elsewhere in this
            // file for the emphasized "Start shift" button.
            border: Border.all(color: AppPalette.teal500, width: 2.5),
          ),
          alignment: Alignment.center,
          // `ClipOval` here, not just `Container`'s own
          // `clipBehavior`/`BoxShape.circle` above — that clip is
          // applied to the *decoration* (the teal border +
          // surfaceVariant fill), and while it happens to also mask
          // most children, relying on it for the logo specifically is
          // fragile: a source image/SVG that isn't already square (a
          // wide wordmark-style logo, say) gets `BoxFit.cover`-scaled
          // to fill the square before that outer clip ever sees it, so
          // corners of a non-square source can still peek past the
          // circular border. Wrapping `_BranchLogo` in its own
          // `ClipOval` guarantees the logo itself is always circular,
          // regardless of the source image's aspect ratio or format
          // (raster vs SVG) — matching the circular tap target and
          // border exactly rather than approximately.
          child: const ClipOval(child: _BranchLogo()),
        ),
      ),
    );
  }
}

/// The morphing shape itself, plus the menu content that fades in once
/// it's grown into place. Lives in its own `OverlayEntry` (inserted by
/// `_ProfileMenuState._open`) rather than inline in the tree, same as
/// any dropdown — it has to paint above every other widget in the
/// dashboard, not just its own local siblings.
///
/// THE MORPH: driven by one `AnimationController` (0 = closed circle,
/// 1 = fully-open panel) owned by `_ProfileMenuState`. A single
/// `AnimatedBuilder` interpolates the box's size, border radius,
/// border, and fill color every frame — going through actual
/// intermediate ovals/rounded-rects rather than crossfading a circle
/// bitmap into a rectangle bitmap, which is what makes this read as one
/// shape becoming another instead of a dissolve. `Curves.easeOutBack`
/// on the way open (a touch of overshoot, like the shape "pops" into
/// its final size) and the plain reverse curve on the way closed (no
/// overshoot needed once it's just shrinking back to a resting circle).
///
/// ANCHORING: `CompositedTransformFollower` (paired with the button's
/// own `CompositedTransformTarget`) keeps this pinned to the button's
/// exact position regardless of where the button sits on screen, same
/// as `PopupMenuButton` achieves internally — growth is anchored at the
/// button's top-right corner and expands down-and-left, matching where
/// the old popup used to appear (`offset: Offset(0, _topBarTapTarget)`,
/// left of the screen's right edge).
///
/// CONTENT CROSSFADE: the branch logo and the Settings/Logout rows are
/// both always laid out (via `Stack`), each visible only past a chosen
/// point in the animation (`_avatarFadeOutEnd/_menuFadeInStart`) rather
/// than only-one-mounted-at-a-time — swapping which child exists mid
/// animation would jump/relayout, whereas overlapping fades hide the
/// exact swap point inside a shape that's already mid-transition and
/// busy holding the eye's attention. The menu content itself is laid
/// out at a **fixed** size (`OverflowBox` pinned to
/// `_profileMenuWidth`/`_profileMenuHeight`) and scaled down with
/// `Transform.scale` to match the panel's current size, rather than
/// being asked to actually re-layout smaller as the box grows/shrinks —
/// a `Column` of real rows has its own intrinsic minimum size, so
/// forcing it into a box shrinking past that minimum (on close) throws
/// a layout overflow; scaling a constant-size layout down has no such
/// floor. The outer `Container`'s own `clipBehavior: Clip.antiAlias`
/// still keeps the visibly-scaled-down content from painting outside
/// the panel's current rounded bounds.
class _ProfileMenuOverlay extends StatelessWidget {
  const _ProfileMenuOverlay({
    required this.layerLink,
    required this.controller,
    required this.onSelected,
    required this.onDismiss,
  });

  final LayerLink layerLink;
  final AnimationController controller;
  final ValueChanged<_ProfileMenuAction> onSelected;
  final VoidCallback onDismiss;

  // The avatar logo is fully gone by 35% into the open animation — well
  // before the box has finished growing, so the tiny circular logo
  // doesn't visibly stretch into an oval as the box does. The menu rows
  // start fading in at 55%, once the box already reads as
  // rectangle-shaped rather than still-circular, so label text doesn't
  // appear inside an obviously-round container.
  static const _avatarFadeOutEnd = 0.35;
  static const _menuFadeInStart = 0.55;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      children: [
        // Full-screen, invisible tap catcher behind the panel — same
        // "tap outside to dismiss" affordance `PopupMenuButton`'s own
        // barrier gave for free, since a custom `OverlayEntry` doesn't
        // come with one automatically.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onDismiss,
          ),
        ),
        CompositedTransformFollower(
          link: layerLink,
          // Anchor the follower's own top-right corner to the button's
          // top-right corner (`targetAnchor`/`followerAnchor` below),
          // then nudge left by the panel's full width and (once
          // growing) down past the button's own height — this is what
          // makes the box visually grow "out of" the circle's top-right
          // corner and downward, matching the direction the old
          // popup's `offset: Offset(0, _topBarTapTarget)` used to open
          // in, rather than growing symmetrically from the circle's
          // center.
          targetAnchor: Alignment.topRight,
          followerAnchor: Alignment.topRight,
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              final clampedT = _panelProgress(controller);

              final width = _lerp(
                _topBarTapTarget,
                _profileMenuWidth,
                clampedT,
              );
              final height = _lerp(
                _topBarTapTarget,
                _profileMenuHeight,
                clampedT,
              );
              // Circle -> rounded rectangle: a circle is just a box
              // whose corner radius is half its own side length, so
              // starting the radius at `_topBarTapTarget / 2` and
              // easing it down to the panel's resting `20` radius (same
              // as the old `PopupMenuButton.shape`) is what makes the
              // corners visibly relax from "fully round" to "rounded
              // rectangle" in step with the box's own growth, instead
              // of snapping to rectangular the instant it starts
              // resizing.
              final radius = _lerp(_topBarTapTarget / 2, 20, clampedT);
              final borderWidth = _lerp(2.5, 0, clampedT);

              return Container(
                width: width,
                height: height,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Color.lerp(
                    colors.surfaceVariant,
                    colors.surfaceRaised,
                    clampedT,
                  ),
                  borderRadius: BorderRadius.circular(radius),
                  border: borderWidth > 0.01
                      ? Border.all(
                          color: AppPalette.teal500,
                          width: borderWidth,
                        )
                      : null,
                  // No shadow — flat, matching the rest of this bar's
                  // controls (none of which use elevation either).
                ),
                child: child,
              );
            },
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                // Recomputed here rather than read from the outer
                // `AnimatedBuilder`'s `builder` above — that `width` is
                // a local inside a *different* closure (Dart's
                // `builder` callbacks don't share locals across
                // separate `AnimatedBuilder`s, even nested ones), so it
                // isn't in scope here. Both builders listen to the same
                // `controller`, though, so recomputing `_panelProgress`
                // a second time always agrees with the outer one at any
                // given frame — this isn't duplicated *state*, just the
                // same pure function of `controller.value` evaluated
                // twice.
                final clampedT = _panelProgress(controller);
                final width = _lerp(
                  _topBarTapTarget,
                  _profileMenuWidth,
                  clampedT,
                );

                final avatarOpacity = (1 - controller.value / _avatarFadeOutEnd)
                    .clamp(0.0, 1.0);
                final menuT =
                    ((controller.value - _menuFadeInStart) /
                            (1 - _menuFadeInStart))
                        .clamp(0.0, 1.0);

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // The avatar content itself (branch logo), fading
                    // out early — see `_avatarFadeOutEnd`'s doc note
                    // above for why this can't just be swapped for the
                    // menu content outright.
                    if (avatarOpacity > 0)
                      Opacity(
                        opacity: avatarOpacity,
                        child: const ClipOval(child: _BranchLogo()),
                      ),
                    // Menu content. This used to sit in a
                    // `Positioned.fill` and get clipped to the parent
                    // `Container`'s current (possibly still-shrinking,
                    // on close) size — but `Positioned.fill` only clips
                    // *paint*, it doesn't shrink the `Column`'s own
                    // layout constraints, so as the box closed back down
                    // past the content's fixed intrinsic size
                    // (two 52-tall rows + padding), the `Column` kept
                    // demanding its full 120x208 and threw a
                    // RenderFlex-overflowed error every time — the
                    // "overflow on close" bug. Fixed by laying the
                    // content out at a **constant** size via
                    // `OverflowBox` (so it's never actually asked to
                    // compress) and instead `Transform.scale`-ing that
                    // fixed-size content down to match the panel's
                    // current proportions — shrinking visually along
                    // with the box instead of being force-fit into it.
                    if (menuT > 0)
                      Opacity(
                        opacity: menuT,
                        child: Transform.scale(
                          scale: (width / _profileMenuWidth).clamp(0.0, 1.0),
                          child: OverflowBox(
                            minWidth: _profileMenuWidth,
                            maxWidth: _profileMenuWidth,
                            minHeight: _profileMenuHeight,
                            maxHeight: _profileMenuHeight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 6,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _ProfileMenuRow(
                                    icon: Icons.settings_outlined,
                                    label: 'Settings',
                                    onTap: () =>
                                        onSelected(_ProfileMenuAction.settings),
                                  ),
                                  _ProfileMenuRow(
                                    icon: Icons.logout_rounded,
                                    label: 'Logout',
                                    destructive: true,
                                    onTap: () =>
                                        onSelected(_ProfileMenuAction.logout),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  /// The single "how open is the panel, 0 to 1" value everything else
  /// in this widget is derived from — factored out specifically so the
  /// two separate `AnimatedBuilder`s above (one for the box's own
  /// size/shape, one for its content) always agree on it, rather than
  /// each hand-rolling the same open/close curve logic and risking the
  /// two drifting out of sync if one gets edited later and the other
  /// doesn't.
  ///
  /// `easeOutBack` (a slight overshoot past 1.0 — the "pop") only on
  /// the way *open*; reversing through the same curve would overshoot
  /// on the way down too, which reads as an odd extra bounce right as
  /// the panel is trying to settle back into a resting circle, so
  /// closing uses a plain `easeInCubic` instead. `controller.status`
  /// (not e.g. a boolean passed down from the caller) is the source of
  /// truth for which direction is active, since it's driven by the
  /// same `forward()`/`reverse()` calls in `_ProfileMenuState` this
  /// whole animation already listens to. The result is clamped to
  /// [0, 1] so callers never have to separately guard against
  /// `easeOutBack`'s momentary overshoot past 1.0.
  static double _panelProgress(AnimationController controller) {
    final isClosing = controller.status == AnimationStatus.reverse;
    final t = isClosing
        ? Curves.easeInCubic.transform(controller.value)
        : Curves.easeOutBack.transform(controller.value);
    return t.clamp(0.0, 1.0);
  }
}

/// Fills the avatar circle with the branch's logo, read from
/// `branchConfigProvider`. `BranchConfigDto.logo` (and the synced table
/// column) is a base64-encoded image string, decoded locally via
/// `_decodeLogoBytes` and rendered with either `SvgPicture.memory` (SVG
/// markup) or `Image.memory` (PNG/JPEG/WebP/GIF/BMP/...), depending on
/// which `_LogoFormat` the decode step sniffed — see that function's
/// and `_sniffLogoFormat`'s doc comments for exactly what's checked.
/// Falls back to the same person icon this avatar showed before (not a
/// blank circle) whenever there's no logo to show: still
/// loading/unsynced, the field is empty, the string doesn't decode as
/// base64, an accidental data-URI prefix couldn't be stripped cleanly,
/// or the decoded bytes aren't a real/complete image (raster) or valid,
/// parseable markup (SVG). A bad logo value should never be able to
/// crash this screen.
class _BranchLogo extends ConsumerWidget {
  const _BranchLogo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Same single-nullable-row assumption as `_watchBranchName` above —
    // see that function's TYPE ASSUMPTION note if this needs adjusting.
    final asyncConfig = ref.watch(branchConfigProvider);
    final rawLogo = asyncConfig.when(
      data: (config) => config?.logo.trim() ?? '',
      error: (_, __) => '',
      loading: () => '',
    );

    final decoded = _decodeLogoBytes(rawLogo);
    if (decoded == null) {
      return const _BranchLogoFallback();
    }

    switch (decoded.format) {
      case _LogoFormat.svg:
        return SvgPicture.memory(
          decoded.bytes,
          width: _topBarTapTarget,
          height: _topBarTapTarget,
          fit: BoxFit.cover,
          // Mirrors the raster branch's errorBuilder below: sniffing the
          // bytes as "looks like SVG/XML" only means they start with the
          // right characters, not that `flutter_svg` can actually parse
          // the whole thing (truncated markup, unsupported elements,
          // etc.). Same fallback either way, resolved on the placeholder
          // widget returned while parsing is still in flight so a bad
          // logo never crashes the screen or gets stuck on a spinner.
          placeholderBuilder: (context) => const _BranchLogoFallback(),
          errorBuilder: (context, error, stackTrace) =>
              const _BranchLogoFallback(),
        );
      case _LogoFormat.raster:
        return Image.memory(
          decoded.bytes,
          width: _topBarTapTarget,
          height: _topBarTapTarget,
          fit: BoxFit.cover,
          // `base64Decode` succeeding only means the *string* was valid
          // base64 — it says nothing about whether the resulting bytes
          // are actually a complete, well-formed image. That check
          // happens async, inside Flutter's own image codec, so it can
          // only be caught here, not around the decode call above. Same
          // fallback either way, so a corrupt/truncated logo degrades
          // exactly like a missing one instead of showing a
          // broken-image glyph or crashing.
          errorBuilder: (context, error, stackTrace) =>
              const _BranchLogoFallback(),
        );
    }
  }
}

/// Which branch `_BranchLogo` takes after decoding: render via
/// `flutter_svg` (XML/SVG markup) or via `Image.memory` (everything
/// else — PNG/JPEG/WebP/GIF/BMP/...). See `_decodeLogoBytes` for how
/// this is determined.
enum _LogoFormat { svg, raster }

/// Decoded logo bytes plus which widget should render them.
class _DecodedLogo {
  const _DecodedLogo(this.bytes, this.format);

  final Uint8List bytes;
  final _LogoFormat format;
}

/// Turns the raw `logo` field into decoded image bytes, or `null` if
/// it can't safely be treated as one — every failure path here returns
/// `null` rather than throwing, since this runs on every branch-config
/// sync and a crash on a bad logo value would take the whole dashboard
/// down with it.
///
/// Handles two shapes of input:
///   - Raw base64 (`iVBORw0KGgo...`) — the expected/default case.
///   - A data URI (`data:image/png;base64,iVBORw0KGgo...`) — some
///     upload flows (especially anything that went through a browser
///     `<input type="file">` + `FileReader` at some point) store the
///     whole data URI rather than stripping it server-side first. The
///     prefix up to and including the first comma is dropped before
///     decoding, if present.
///
/// DOES branch on one distinction — SVG (XML text) vs everything else
/// (PNG/JPEG/WebP/GIF/BMP/...) — via `_sniffLogoFormat` below, because
/// that distinction changes which *widget* has to render the bytes
/// (`flutter_svg` vs `Image.memory`); it does NOT distinguish among the
/// raster formats themselves, since `Image.memory` already detects
/// those from the byte signature the same way every Flutter image
/// widget does, and duplicating that here would just be redoing work
/// the framework already does correctly.
_DecodedLogo? _decodeLogoBytes(String raw) {
  if (raw.isEmpty) return null;

  // Strip a `data:image/...;base64,` prefix if present. `indexOf(',')`
  // rather than a full data-URI parser — this only needs to find where
  // the actual base64 payload starts, not validate the URI's structure.
  final commaIndex = raw.indexOf(',');
  final looksLikeDataUri = raw.startsWith('data:') && commaIndex != -1;
  final payload = looksLikeDataUri ? raw.substring(commaIndex + 1) : raw;

  if (payload.isEmpty) return null;

  try {
    // `base64.decode` (not `base64Url.decode`) — the DTO's confirmed
    // POS-response style elsewhere in this codebase uses standard
    // encodings, not URL-safe ones. `normalize` fixes up missing `=`
    // padding, which real-world base64 blobs coming out of some
    // server/JS pipelines routinely drop.
    final bytes = base64.decode(base64.normalize(payload));
    return _DecodedLogo(bytes, _sniffLogoFormat(bytes));
  } on FormatException {
    // Not valid base64 at all (stray characters, corrupted/truncated
    // string, etc.) — treat exactly like "no logo," not a crash.
    return null;
  }
}

/// Sniffs whether decoded logo bytes are SVG/XML markup or a raster
/// image, so `_BranchLogo` knows whether to hand them to
/// `SvgPicture.memory` or `Image.memory`.
///
/// SVGs are text, not a fixed binary signature, so this can't check a
/// magic-number prefix the way raster formats do — it decodes the
/// leading bytes as UTF-8, trims a possible byte-order mark and leading
/// whitespace (both legal, and seen in the wild, before the first XML
/// declaration), and checks whether what's left starts with `<?xml` or
/// `<svg`, case-insensitively, matching what the doc comment at the top
/// of this file describes as the confirmed shape of a real branch logo.
/// Only the first ~200 bytes are decoded — enough to reach either
/// opening tag without paying to decode a potentially large raster
/// payload as text, and a `FormatException` from decoding non-UTF-8
/// raster bytes as a string is itself evidence this isn't SVG. Anything
/// that doesn't match — including that decode failure — falls through
/// to `_LogoFormat.raster`, where `Image.memory`'s own codec sniffing
/// (and its `errorBuilder` fallback in `_BranchLogo`) takes over from
/// here, so a mis-sniffed or malformed file still degrades to the
/// fallback icon rather than crashing.
_LogoFormat _sniffLogoFormat(Uint8List bytes) {
  if (bytes.isEmpty) return _LogoFormat.raster;

  final sampleLength = bytes.length < 200 ? bytes.length : 200;
  final sample = bytes.sublist(0, sampleLength);

  try {
    final text = utf8.decode(sample, allowMalformed: false).trimLeft();
    // Strip a leading UTF-8 BOM (U+FEFF), if `utf8.decode` left it in.
    final withoutBom = text.startsWith('\uFEFF') ? text.substring(1) : text;
    final lower = withoutBom.trimLeft().toLowerCase();
    if (lower.startsWith('<?xml') || lower.startsWith('<svg')) {
      return _LogoFormat.svg;
    }
  } on FormatException {
    // Not valid UTF-8 text at all — real raster bytes (PNG/JPEG/...)
    // routinely aren't, which itself is a signal this isn't SVG.
  }

  return _LogoFormat.raster;
}

/// The original person-icon glyph, kept as the loading/error/empty state
/// for `_BranchLogo` rather than being deleted outright — this is what
/// the avatar showed before the branch logo existed, and it's still the
/// right thing to show whenever there isn't a real logo to render.
class _BranchLogoFallback extends StatelessWidget {
  const _BranchLogoFallback();

  @override
  Widget build(BuildContext context) {
    // Explicit white (AppPalette.neutral0) rather than a semantic "on X"
    // token — this is a deliberate always-white icon regardless of
    // theme, not one that should flip per-brightness. `colors.onPrimary`
    // was considered but rejected: it resolves to white in light mode,
    // but a near-black teal in dark mode (dark mode's `primary` is a
    // light tint, so its "on" color goes dark for contrast) — the
    // opposite of what was asked for here.
    return const Icon(
      Icons.person_rounded,
      size: 34,
      color: AppPalette.neutral0,
    );
  }
}

class _ProfileMenuRow extends StatelessWidget {
  const _ProfileMenuRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = destructive ? colors.danger : colors.textPrimary;
    // Soft tinted circle behind the icon rather than a bare glyph next
    // to text — this is what reads as a modern menu row instead of a
    // flat Material-1 list item. Derived with `withOpacity` on the same
    // semantic color (danger / textPrimary) so it stays correct in both
    // light and dark theme without a dedicated "subtle" token.
    final iconBackdrop = destructive
        ? colors.danger.withOpacity(0.12)
        : colors.textPrimary.withOpacity(0.06);

    // `Material`+`InkWell` here, not just a bare `GestureDetector` —
    // `PopupMenuItem` used to supply the press ripple/highlight for
    // free; now that each row is a plain widget in a `Column` instead
    // of a `PopupMenuItem`, this is what keeps that same tactile
    // feedback on tap.
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconBackdrop,
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: AppTypography.ui(
                  color: color,
                  fontSize: 16,
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
