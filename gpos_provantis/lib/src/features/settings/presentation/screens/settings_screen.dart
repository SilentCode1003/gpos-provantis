// Location: src/features/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'settings_shared.dart';
import '../panels/printers_panel.dart';
import '../panels/theme_panel.dart';
import '../panels/transactions_panel.dart';
import '../panels/pos_config_panel.dart';
import '../panels/placeholder_panels.dart';
import '../panels/counter_display_panel.dart';

/// =========================================================================
/// SETTINGS SCREEN — touch-first layout for a counter-mounted POS panel.
///
/// Ground-up redesign (v3): a flush vertical icon strip stands in for the
/// old tab bar / nav rail — rounded tiles, icon + short label, no
/// hard-edged "physical key" styling and no F-key labeling, since this is
/// a touchscreen device operated by a fingertip, not a keyboard. Every
/// tile targets ~68-76dp, well past Material's 48dp minimum, because a
/// mis-tap on this screen either fires the wrong settings section or —
/// worse, inside the add-printer flow — silently loses whatever the
/// cashier already typed.
///
/// Sections:
///   1. Printers          — list/add/edit/test printers (fields based on `PrinterDto`)
///   2. Transactions      — receipt/transaction behavior toggles
///   3. POS Config        — company/BIR details printed on official receipts
///   4. Sync              — placeholder
///   5. System            — placeholder
///   6. Theme             — light/system/dark toggle
///   7. Users             — placeholder (staff/PIN access)
///   8. Counter Display   — placeholder (customer-facing screen)
///   9. About             — placeholder (app version, support info)
///
/// This file is the shell only: nav strip, top bar, and switching between
/// sections. Each section's actual content lives in its own file under
/// `panels/`, and small pieces shared by more than one panel live in
/// `settings_shared.dart`. Splitting it this way keeps any single file
/// from growing past what's comfortable to read/update, and means adding
/// or reworking one section never requires touching the others.
/// =========================================================================

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  static const _sections = [
    SettingsSection(
      label: 'Printers',
      icon: Icons.print_rounded,
      builder: PrintersPanel.new,
    ),
    SettingsSection(
      label: 'Transactions',
      icon: Icons.receipt_long_rounded,
      builder: TransactionsPanel.new,
    ),
    SettingsSection(
      label: 'POS Config',
      icon: Icons.storefront_rounded,
      builder: PosConfigPanel.new,
    ),
    SettingsSection(
      label: 'Sync',
      icon: Icons.sync_rounded,
      builder: SyncPanel.new,
    ),
    SettingsSection(
      label: 'System',
      icon: Icons.tune_rounded,
      builder: SystemPanel.new,
    ),
    SettingsSection(
      label: 'Theme',
      icon: Icons.palette_rounded,
      builder: ThemePanel.new,
    ),
    SettingsSection(
      label: 'Users',
      icon: Icons.badge_rounded,
      builder: UsersPanel.new,
    ),
    SettingsSection(
      label: 'Counter Display',
      icon: Icons.monitor_rounded,
      builder: CounterDisplayPanel.new,
    ),
  ];

  static const _aboutSection = SettingsSection(
    label: 'About',
    icon: Icons.info_outline_rounded,
    builder: AboutPanel.new,
  );

  int _selectedIndex = 0;
  bool _aboutSelected = false;

  SettingsSection get _active =>
      _aboutSelected ? _aboutSection : _sections[_selectedIndex];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(activeLabel: _active.label),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _NavStrip(
                    sections: _sections,
                    selectedIndex: _aboutSelected ? null : _selectedIndex,
                    onSelect: (index) => setState(() {
                      _selectedIndex = index;
                      _aboutSelected = false;
                    }),
                    aboutSection: _aboutSection,
                    aboutSelected: _aboutSelected,
                    onSelectAbout: () => setState(() => _aboutSelected = true),
                  ),
                  Expanded(
                    child: ColoredBox(
                      color: colors.background,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: KeyedSubtree(
                          key: ValueKey(
                            _aboutSelected ? 'about' : _selectedIndex,
                          ),
                          child: _active.builder(),
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

/// -----------------------------------------------------------------------
/// TOP BAR — back button, wordmark, and a small breadcrumb for the active
/// section. The strip below carries the actual wayfinding, so this bar's
/// only job is orientation plus a way out.
/// -----------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  const _TopBar({required this.activeLabel});

  final String activeLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: Space.md),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: Row(
        children: [
          _TouchIconButton(
            icon: Icons.arrow_back_rounded,
            tooltip: 'Back to dashboard',
            onPressed: () => context.go('/dashboard'),
            size: 52,
            iconSize: 22,
          ),
          const SizedBox(width: Space.sm),
          Text(
            'Settings',
            style: AppTypography.display(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(width: Space.sm),
          Container(width: 1, height: 18, color: colors.borderSubtle),
          const SizedBox(width: Space.sm),
          Expanded(
            child: Text(
              activeLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.ui(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: colors.primary,
              ),
            ),
          ),
          Text(
            'REGISTER 1',
            style: AppTypography.ui(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: colors.textSecondary,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

/// A large square icon button — stands in for bare `IconButton`s, which
/// default to a 40dp target too tight for a 14" panel tapped at an angle.
class _TouchIconButton extends StatelessWidget {
  const _TouchIconButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.color,
    this.size = 56,
    this.iconSize = 24,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final Color? color;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final button = Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, size: iconSize, color: color ?? colors.textPrimary),
        ),
      ),
    );

    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}

/// -----------------------------------------------------------------------
/// NAV STRIP — flush vertical strip of rounded icon tiles. Icon + short
/// label, sized for a fingertip. The active tile carries a solid
/// `primary` fill; everything else stays flat and quiet. "About" sits
/// pinned to the bottom, visually separated from the main section list so
/// it doesn't compete with the working sections above it.
/// -----------------------------------------------------------------------

class _NavStrip extends StatelessWidget {
  const _NavStrip({
    required this.sections,
    required this.selectedIndex,
    required this.onSelect,
    required this.aboutSection,
    required this.aboutSelected,
    required this.onSelectAbout,
  });

  final List<SettingsSection> sections;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;
  final SettingsSection aboutSection;
  final bool aboutSelected;
  final VoidCallback onSelectAbout;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 128,
      color: colors.surface,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Space.sm),
              child: Column(
                children: [
                  for (var i = 0; i < sections.length; i++)
                    _NavTile(
                      section: sections[i],
                      selected: i == selectedIndex,
                      onTap: () => onSelect(i),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Space.sm),
            child: _NavTile(
              section: aboutSection,
              selected: aboutSelected,
              onTap: onSelectAbout,
              compact: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.section,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  final SettingsSection section;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: Material(
        color: selected ? colors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 112,
            constraints: BoxConstraints(minHeight: compact ? 72 : 84),
            padding: const EdgeInsets.symmetric(vertical: Space.md),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  section.icon,
                  size: compact ? 24 : 28,
                  color: selected ? colors.onPrimary : colors.textSecondary,
                ),
                const SizedBox(height: Space.sm),
                Text(
                  section.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.ui(
                    fontSize: compact ? 12 : 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    color: selected ? colors.onPrimary : colors.textSecondary,
                    height: 1.15,
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
