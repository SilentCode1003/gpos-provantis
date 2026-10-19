import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'settings_shared.dart';
import '../panels/printers_panel.dart';
import '../panels/theme_panel.dart';
import '../panels/transactions_panel.dart';
import '../panels/pos_config_panel.dart';
import '../panels/email_panel.dart';
import '../panels/placeholder_panels.dart';
import '../panels/about_panel.dart';
import '../panels/counter_display_panel.dart';
import '../panels/guides_panel.dart';
import '../panels/factory_reset_panel.dart';

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
      label: 'Email',
      icon: Icons.mail_rounded,
      builder: EmailPanel.new,
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
    SettingsSection(
      label: 'Guides',
      icon: Icons.menu_book_rounded,
      builder: GuidesPanel.new,
    ),
    SettingsSection(
      label: 'Factory Reset',
      icon: Icons.restart_alt_rounded,
      builder: FactoryResetPanel.new,
    ),
  ];

  static const _aboutSection = SettingsSection(
    label: 'About',
    icon: Icons.info_outline_rounded,
    builder: AboutPanel.new,
  );

  int _selectedIndex = 0;
  bool _aboutSelected = false;

  /// Phone layout only: false shows the list of sections, true shows the
  /// chosen section's panel.
  bool _compactDetailOpen = false;

  SettingsSection get _active =>
      _aboutSelected ? _aboutSection : _sections[_selectedIndex];

  /// Phone-portrait layout: a list of sections, and tapping one opens its
  /// panel full screen. Back returns to the list, then to the dashboard.
  Widget _buildCompact(BuildContext context) {
    final colors = context.colors;
    final detailOpen = _compactDetailOpen;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: PopScope(
          canPop: !detailOpen,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) setState(() => _compactDetailOpen = false);
          },
          child: Column(
            children: [
              _CompactTopBar(
                title: detailOpen ? _active.label : 'Settings',
                backTooltip: detailOpen
                    ? 'Back to settings'
                    : 'Back to dashboard',
                onBack: detailOpen
                    ? () => setState(() => _compactDetailOpen = false)
                    : () => context.go('/dashboard'),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: detailOpen
                      ? KeyedSubtree(
                          key: ValueKey(
                            _aboutSelected ? 'about' : _selectedIndex,
                          ),
                          child: ColoredBox(
                            color: colors.background,
                            child: _active.builder(),
                          ),
                        )
                      : _CompactSectionList(
                          key: const ValueKey('sections'),
                          sections: _sections,
                          aboutSection: _aboutSection,
                          onSelect: (index) => setState(() {
                            _selectedIndex = index;
                            _aboutSelected = false;
                            _compactDetailOpen = true;
                          }),
                          onSelectAbout: () => setState(() {
                            _aboutSelected = true;
                            _compactDetailOpen = true;
                          }),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (isCompactLayout(context)) return _buildCompact(context);

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

class _CompactTopBar extends StatelessWidget {
  const _CompactTopBar({
    required this.title,
    required this.onBack,
    required this.backTooltip,
  });

  final String title;
  final VoidCallback onBack;
  final String backTooltip;

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
            tooltip: backTooltip,
            onPressed: onBack,
            size: 52,
            iconSize: 22,
          ),
          const SizedBox(width: Space.sm),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.display(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: Space.sm),
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

class _CompactSectionList extends StatelessWidget {
  const _CompactSectionList({
    super.key,
    required this.sections,
    required this.aboutSection,
    required this.onSelect,
    required this.onSelectAbout,
  });

  final List<SettingsSection> sections;
  final SettingsSection aboutSection;
  final ValueChanged<int> onSelect;
  final VoidCallback onSelectAbout;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Space.lg,
        Space.lg,
        Space.lg,
        Space.xxl,
      ),
      children: [
        for (var i = 0; i < sections.length; i++) ...[
          _CompactSectionTile(section: sections[i], onTap: () => onSelect(i)),
          const SizedBox(height: Space.sm),
        ],
        const SizedBox(height: Space.md),
        _CompactSectionTile(section: aboutSection, onTap: onSelectAbout),
      ],
    );
  }
}

class _CompactSectionTile extends StatelessWidget {
  const _CompactSectionTile({required this.section, required this.onTap});

  final SettingsSection section;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(minHeight: 72),
          padding: const EdgeInsets.symmetric(
            horizontal: Space.lg,
            vertical: Space.md,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.borderSubtle),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  section.icon,
                  size: 24,
                  color: colors.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: Space.lg),
              Expanded(
                child: Text(
                  section.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.ui(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: colors.textDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
