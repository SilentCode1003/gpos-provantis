// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/top_bar.dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';

/// --- Top bar: status only (branch, time, shift, OR number) + profile ------
///
/// This bar used to also carry Start/End shift, Cash drop, Reprint,
/// Settings, and Others — those are now a second action row inside
/// `CatalogPanel` (see `catalog_panel.dart`), directly below this bar.
/// This bar's only job now is orientation: which branch/terminal this
/// is, what time it is, which shift is running, and the OR (official
/// receipt) number in progress. The profile icon stays pinned top-right,
/// unchanged from before.
///
/// Branch name, shift number, and OR number are placeholder literals for
/// now ("5L Solutions", "1", "100000000") — same placeholder-data
/// approach as the rest of the dashboard (see `dashboard_screen.dart`'s
/// doc comment on `DashboardController`'s hardcoded catalog). Swap
/// `_StatusItem`'s values for real controller/session state once that
/// exists; the layout doesn't need to change.
///
/// No longer a `ConsumerWidget` — nothing in this bar reads Riverpod
/// state anymore now that shift/cart actions have moved out. If a real
/// session/shift source gets wired in to replace the placeholders above,
/// this will need to go back to watching it.

// Pinned explicitly rather than left to resolve implicitly from padding
// + tallest child (16 + 72 + 12 = 100, in theory). `_CartHeader` in
// cart_panel.dart is pinned to the same literal value so the two bottom
// borders land on exactly the same row across the cart/catalog seam —
// letting both sides compute their own "100" independently left them a
// hair off in practice, so this is now the single source of truth for
// that shared height. If you change this, update `_cartHeaderHeight` in
// cart_panel.dart to match.
const double _topBarHeight = 100;

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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
                  const _StatusItem(label: 'Branch', value: '5L Solutions'),
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

/// --- Profile menu: avatar with border, opens a Settings/Logout dropdown ---

enum _ProfileMenuAction { settings, logout }

/// Slightly larger than [primaryTapTarget] — touchscreen POS, and every
/// control in this top bar (shift toggle, cash drop, reprint, others,
/// profile) is a high-frequency action, so the whole row errs on the
/// side of bigger rather than sitting at the shared cross-app floor.
/// Scoped to `top_bar.dart` only — deliberately not a change to
/// `primaryTapTarget` itself, which other screens (cart, catalog,
/// product grid) still rely on at its original size.
const double _topBarTapTarget = 72;

/// Circular, bordered profile icon pinned at the top-right of the top
/// bar. Tapping it opens a dropdown (`PopupMenuButton`) with Settings and
/// Logout. Settings reuses the same handler as the top bar's own
/// Settings button rather than duplicating a second, separately-wired
/// no-op — the two entry points should always do the same thing. Logout
/// always confirms first via `_LogoutConfirmationDialog` before this
/// widget calls through to the actual sign-out hook.
class _ProfileMenu extends StatelessWidget {
  const _ProfileMenu();

  Future<void> _handleSelection(
    BuildContext context,
    _ProfileMenuAction action,
  ) async {
    switch (action) {
      case _ProfileMenuAction.settings:
        // Same hook as the top bar's own "Settings" button — wire both
        // to the real settings route/sheet together.
        break;
      case _ProfileMenuAction.logout:
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => const _LogoutConfirmationDialog(),
        );
        if (confirmed == true) {
          // TODO: hook up to the real sign-out flow (clear session,
          // navigate to the login screen, etc).
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return PopupMenuButton<_ProfileMenuAction>(
      tooltip: 'Profile',
      offset: const Offset(0, _topBarTapTarget),
      // Explicit surface color — without this, PopupMenuButton falls back
      // to Material 3's default popover surface tint, which reads as
      // near-black regardless of app theme. `colors.surfaceRaised` is
      // the token this theme already uses for cards/sheets/dialogs
      // sitting above the base surface, so the dropdown matches the
      // rest of the app's floating-surface color instead of Flutter's
      // own default.
      color: colors.surfaceRaised,
      // Shadow-only elevation, no border — current native menus (iOS
      // context menus, Material You) separate the floating surface from
      // the page with depth alone, not an outline on top of a shadow.
      // A border reads as a leftover from flatter, pre-elevation UI.
      elevation: 12,
      shadowColor: colors.textPrimary.withOpacity(0.2),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      constraints: const BoxConstraints(minWidth: 208),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      onSelected: (action) => _handleSelection(context, action),
      itemBuilder: (context) => [
        // No divider between the two items: they're not two separate
        // groups, so a hairline rule here is decoration standing in for
        // structure it doesn't have. Color (destructive red) already
        // separates Logout from Settings on its own — current menus
        // lean on that instead of adding a rule.
        //
        // PopupMenuItem has no per-item `borderRadius` param — only
        // PopupMenuButton.shape rounds the outer menu's own corners, so
        // each row's press highlight is a plain rectangle inset within
        // that rounded surface. `padding: zero` here plus the row's own
        // internal horizontal padding (see _ProfileMenuRow) is what
        // keeps the icon/label content visually inset from the menu's
        // rounded edge.
        PopupMenuItem(
          value: _ProfileMenuAction.settings,
          height: 52,
          padding: EdgeInsets.zero,
          child: const _ProfileMenuRow(
            icon: Icons.settings_outlined,
            label: 'Settings',
          ),
        ),
        PopupMenuItem(
          value: _ProfileMenuAction.logout,
          height: 52,
          padding: EdgeInsets.zero,
          child: const _ProfileMenuRow(
            icon: Icons.logout_rounded,
            label: 'Logout',
            destructive: true,
          ),
        ),
      ],
      // Full-size circle (not a smaller circle padded inside a bigger
      // tap box) so it reads at the same visual weight as the
      // primaryTapTarget-tall buttons on the left, not just the same
      // tap area. Sized a step above primaryTapTarget — this is a
      // touchscreen POS terminal, and the profile icon is a
      // high-frequency top-bar control same as Start shift/Others, not
      // a secondary action, so it gets the same "err large" treatment.
      child: Container(
        width: _topBarTapTarget,
        height: _topBarTapTarget,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.surfaceVariant,
          // V1 brand teal, not the neutral `colors.border` — a
          // borderSubtle-style gray reads as barely-there on purpose for
          // quiet dividers, which is exactly why it looked "barely
          // seeable" here. AppPalette.teal500 (#009184) is the exact V1
          // brand color, already used elsewhere in this file for the
          // emphasized "Start shift" button.
          border: Border.all(color: AppPalette.teal500, width: 2.5),
        ),
        alignment: Alignment.center,
        // Explicit white (AppPalette.neutral0) rather than a semantic
        // "on X" token — this is a deliberate always-white icon
        // regardless of theme, not one that should flip per-brightness.
        // `colors.onPrimary` was considered but rejected: it resolves to
        // white in light mode, but a near-black teal in dark mode (dark
        // mode's `primary` is a light tint, so its "on" color goes dark
        // for contrast) — the opposite of what was asked for here.
        child: const Icon(
          Icons.person_rounded,
          size: 34,
          color: AppPalette.neutral0,
        ),
      ),
    );
  }
}

class _ProfileMenuRow extends StatelessWidget {
  const _ProfileMenuRow({
    required this.icon,
    required this.label,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
    );
  }
}

/// Confirmation dialog shown before logout actually happens — a signed-in
/// cashier tapping the wrong dropdown item shouldn't get kicked out of an
/// active sale with no way back. Returns `true` via `Navigator.pop` if
/// the person confirms, `false`/`null` otherwise (including dismissing
/// by tapping outside).
class _LogoutConfirmationDialog extends StatelessWidget {
  const _LogoutConfirmationDialog();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AlertDialog(
      // Same bug class as PopupMenuButton above: no explicit
      // backgroundColor means Flutter falls back to Material 3's own
      // default dialog surface tint, which reads dark/near-black
      // regardless of app theme — not a light/dark mode issue, just a
      // missing color. `colors.surfaceRaised` matches the token this
      // theme uses for every other floating surface (cards, sheets,
      // the profile dropdown above).
      backgroundColor: colors.surfaceRaised,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // Left-aligned, compact title/body instead of a centered icon +
      // headline stack. A big icon-in-circle above a title reads as the
      // template confirm-dialog now — the same shape is on every
      // "delete this?" prompt from a few years back. Skipping it and
      // tightening the type keeps the color (danger red, on the action
      // below) carrying the "this is destructive" signal instead of an
      // icon doing it redundantly.
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      title: Text(
        'Log out?',
        style: AppTypography.display(
          color: colors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      content: Text(
        'You’ll need to sign back in to continue using the till.',
        style: AppTypography.ui(color: colors.textSecondary, fontSize: 15),
      ),
      // Stacked full-width actions (destructive on top, plain-text
      // cancel below) rather than two equal-weight side-by-side pills.
      // Two same-size buttons is what makes a dialog read as a
      // generic template; a single confident primary action with a
      // lighter-weight way out underneath is the current native
      // pattern (iOS action sheets, refreshed Material dialogs) and
      // also states a clearer default for a touchscreen till.
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
                    'Log out',
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
