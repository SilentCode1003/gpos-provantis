import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/settings_controller.dart';
import 'package:gpos_provantis/src/core/database/domain/printer_dto.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';

/// =========================================================================
/// SETTINGS SCREEN
///
/// Touch-first layout for a 14" counter-mounted POS panel, worked at arm's
/// length with fingers rather than a mouse cursor. Two things follow from
/// that:
///
/// 1. A fixed left nav rail of large tappable rows (mirrors the
///    dashboard's category-rail pattern) replaces the old top `TabBar`.
///    Rows are sized closer to a phone's app-icon grid than a desktop
///    sidebar — this is deliberately oversized for a mouse, because it's
///    sized for a fingertip instead.
/// 2. Every tappable surface on this screen — rail rows, buttons, printer
///    cards, form fields — targets ~72dp, well above Material's 48dp
///    *minimum*. That minimum is calibrated for a fingertip with a clear
///    line of sight on a handheld device; a counter POS is tapped at an
///    angle, sometimes with the side of a finger, and a mis-tap mid-order
///    is actively costly (wrong action fires, or — worse in the add
///    printer flow — the form closes and re-entry is required). Sizing up
///    is the guard against that, not just a density preference.
///
/// Sections:
///   1. Printers — add/list printers (fields based on `PrinterDto`)
///   2. Sync     — placeholder
///   3. System   — placeholder
///   4. Theme    — placeholder
///   5. Users    — placeholder (staff/PIN access, common for POS)
///   6. About    — placeholder (app version, support info)
///
/// Only the Printers section has real UI for now; the rest are stubbed
/// with `_PanelPlaceholder` so the layout/navigation is in place before
/// their logic is built out.
/// =========================================================================

/// Spacing scale used throughout this screen. Every gap on the page should
/// come from here rather than a one-off magic number — the previous pass
/// had ~10 distinct spacing values (12/14/16/18/20/26/28/32/36) with no
/// discernible system, which is part of why the layout read as slightly
/// off even though no single value was "wrong". A small fixed set makes
/// rhythm consistent and makes future edits obviously right or wrong.
abstract class _Space {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;
  static const huge = 40.0;
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  static const _sections = [
    _SettingsSection(
      label: 'Printers',
      icon: Icons.print_rounded,
      builder: _PrintersPanel.new,
    ),
    _SettingsSection(
      label: 'Sync',
      icon: Icons.sync_rounded,
      builder: _SyncPanel.new,
    ),
    _SettingsSection(
      label: 'System',
      icon: Icons.tune_rounded,
      builder: _SystemPanel.new,
    ),
    _SettingsSection(
      label: 'Theme',
      icon: Icons.palette_rounded,
      builder: _ThemePanel.new,
    ),
    _SettingsSection(
      label: 'Users',
      icon: Icons.badge_rounded,
      builder: _UsersPanel.new,
    ),
    _SettingsSection(
      label: 'About',
      icon: Icons.info_rounded,
      builder: _AboutPanel.new,
    ),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // final state = ref.watch(settingsControllerProvider);
    final colors = context.colors;
    final selected = _sections[_selectedIndex];

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(title: selected.label),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _NavRail(
                    sections: _sections,
                    selectedIndex: _selectedIndex,
                    onSelect: (index) => setState(() => _selectedIndex = index),
                  ),
                  // No divider here on purpose — the selected rail item
                  // fills with `colors.background` and rounds its right
                  // edge outward, so it visually bridges this seam
                  // instead of butting up against a hard line. A divider
                  // would cut right through that merge.
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
                          key: ValueKey(_selectedIndex),
                          child: selected.builder(),
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
/// TOP BAR — back button and the active section's name. Deliberately
/// thin: on this layout the rail carries the wayfinding, so the bar's only
/// job is "how do I leave" plus a title for orientation.
///
/// The breadcrumb ("Settings › <section>") is one continuous piece of
/// text logic now, not two differently-weighted labels competing for
/// attention: "Settings" stays a quiet prefix and the section name is the
/// only thing actually emphasized. It's also wrapped in `Expanded` with
/// an ellipsis, since a plain `Row` here would silently overflow the
/// moment a section label runs long.
/// -----------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: _Space.md),
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
            size: 56,
            iconSize: 26,
          ),
          const SizedBox(width: _Space.sm),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Settings  ',
                    style: AppTypography.ui(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colors.textSecondary,
                    ),
                  ),
                  TextSpan(
                    text: title,
                    style: AppTypography.ui(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// A large square icon button — swaps in for bare `IconButton`s throughout
/// this screen, which default to a 40dp tap target that's far too tight
/// for a 14" panel tapped at an angle with a full finger pad. Defaults to
/// 64dp; call sites needing more presence (e.g. delete on a printer card)
/// can size up further.
class _TouchIconButton extends StatelessWidget {
  const _TouchIconButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.color,
    this.size = 64,
    this.iconSize = 26,
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

class _SettingsSection {
  const _SettingsSection({
    required this.label,
    required this.icon,
    required this.builder,
  });

  final String label;
  final IconData icon;
  final Widget Function() builder;
}

/// -----------------------------------------------------------------------
/// NAV RAIL — physical-tab metaphor. The selected row fills with
/// `colors.background` — the same surface the content pane sits on — and
/// rounds its trailing edge outward past the rail/content seam, so the
/// two panes read as one continuous surface with a notch cut into the
/// rail behind the active tab, like an index-card tab or a pressed key
/// sitting proud of the keys around it.
///
/// The previous pass sold "unselected" with a pair of offsetting inset
/// `BoxShadow`s meant to read as "recessed behind glass". That's a subtle
/// effect even at native resolution, and on the neutral-tinted (not pure
/// gray) surfaces this palette actually uses, it was more likely to read
/// as a rendering artifact than an intentional recess — especially once
/// scaled or viewed on a lower-quality panel. This version keeps the one
/// real idea (selected tab structurally merges into the content pane) and
/// drops the fragile part: unselected rows are simply flat, with the
/// active tab carrying a single soft drop shadow to read as lifted. One
/// clear signal beats two competing subtle ones.
/// -----------------------------------------------------------------------

class _NavRail extends StatelessWidget {
  const _NavRail({
    required this.sections,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<_SettingsSection> sections;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 280,
      color: colors.surface,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: _Space.lg),
        children: [
          for (var i = 0; i < sections.length; i++)
            _NavRailItem(
              section: sections[i],
              selected: i == selectedIndex,
              onTap: () => onSelect(i),
            ),
        ],
      ),
    );
  }
}

class _NavRailItem extends StatelessWidget {
  const _NavRailItem({
    required this.section,
    required this.selected,
    required this.onTap,
  });

  final _SettingsSection section;
  final bool selected;
  final VoidCallback onTap;

  static const _morphDuration = Duration(milliseconds: 160);
  static const _morphCurve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // 76dp row height: the primary navigation surface for the whole
    // screen, sized closer to a phone home-screen icon than a desktop
    // sidebar item so it's unmissable on a 14" panel.
    //
    // No horizontal margin on the trailing edge when selected — the row
    // runs flush to the rail's own right edge so its rounded corners read
    // as one continuous shape with the content pane beside it, rather
    // than a card floating with a gap around it.
    return Padding(
      padding: const EdgeInsets.only(bottom: _Space.xs),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: _morphDuration,
          curve: _morphCurve,
          height: 76,
          margin: EdgeInsets.only(
            left: _Space.sm,
            right: selected ? 0 : _Space.sm,
          ),
          padding: const EdgeInsets.symmetric(horizontal: _Space.lg),
          decoration: BoxDecoration(
            color: selected ? colors.background : Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              bottomLeft: const Radius.circular(16),
              topRight: Radius.circular(selected ? 16 : 0),
              bottomRight: Radius.circular(selected ? 16 : 0),
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: colors.shadow,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: _morphDuration,
                curve: _morphCurve,
                width: 4,
                height: 28,
                decoration: BoxDecoration(
                  color: selected ? colors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: _Space.lg),
              Icon(
                section.icon,
                size: 26,
                color: selected ? colors.primary : colors.textSecondary,
              ),
              const SizedBox(width: _Space.lg),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: _morphDuration,
                  curve: _morphCurve,
                  style: AppTypography.ui(
                    fontSize: 17,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    color: selected ? colors.textPrimary : colors.textSecondary,
                  ),
                  child: Text(
                    section.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// PRINTERS PANEL
/// -----------------------------------------------------------------------

/// Connection-type icon lookup, shared by the printer card and the add
/// printer sheet. Previously duplicated verbatim in both places — a
/// classic drift risk (add a fourth connection type, remember to update
/// it twice). One source of truth now.
IconData _connectionTypeIcon(String type) => switch (type) {
  'BLUETOOTH' => Icons.bluetooth_rounded,
  'WIFI' => Icons.wifi_rounded,
  'USB' => Icons.usb_rounded,
  _ => Icons.print_outlined,
};

class _PrintersPanel extends ConsumerStatefulWidget {
  const _PrintersPanel();

  @override
  ConsumerState<_PrintersPanel> createState() => _PrintersPanelState();
}

class _PrintersPanelState extends ConsumerState<_PrintersPanel> {
  // TODO: replace with real state from settingsControllerProvider once the
  // controller persists/loads printers. Kept local for now so the UI is
  // usable standalone.
  final List<PrinterDto> _printers = [];

  Future<void> _openAddPrinterSheet() async {
    // isDismissible/enableDrag are both false: a full 14" sheet reaches
    // most of the way across the panel, so a stray finger during normal
    // reach-and-tap easily lands on the scrim or triggers a drag. Default
    // bottom-sheet behavior would silently discard whatever was typed —
    // the sheet's own Cancel/close button is the only way out now, and
    // that button asks for confirmation once any field has content (see
    // `_AddPrinterSheet._confirmDiscardIfNeeded`).
    final result = await showModalBottomSheet<PrinterDto>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => const _AddPrinterSheet(),
    );

    if (result != null) {
      setState(() => _printers.add(result));
    }
  }

  void _removePrinter(PrinterDto printer) {
    setState(() => _printers.removeWhere((p) => p.id == printer.id));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: _printers.isEmpty
          ? _PanelPlaceholder(
              icon: Icons.print_outlined,
              title: 'No printers added yet',
              description:
                  'Add a receipt or kitchen printer to start printing '
                  'from this device.',
              action: _PrimaryTouchButton(
                icon: Icons.add_rounded,
                label: 'Add printer',
                onPressed: _openAddPrinterSheet,
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                _Space.xxxl,
                _Space.xxl,
                _Space.xxxl,
                _Space.xxxl,
              ),
              itemCount: _printers.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: _Space.lg),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _PanelHeader(
                    title: 'Printers',
                    subtitle:
                        '${_printers.length} '
                        '${_printers.length == 1 ? 'printer' : 'printers'} '
                        'connected to this device',
                    onAdd: _openAddPrinterSheet,
                  );
                }
                final printer = _printers[index - 1];
                return _PrinterCard(
                  printer: printer,
                  onDelete: () => _removePrinter(printer),
                );
              },
            ),
    );
  }
}

/// Section header used at the top of a scrollable panel — title/subtitle
/// on the left, primary action on the right. Keeping this in the scroll
/// flow (rather than a fixed app bar) means the "Add" button scrolls with
/// content instead of permanently eating vertical space above the list.
class _PanelHeader extends StatelessWidget {
  const _PanelHeader({
    required this.title,
    required this.subtitle,
    required this.onAdd,
  });

  final String title;
  final String subtitle;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: _Space.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.display(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: _Space.xs),
                Text(
                  subtitle,
                  style: AppTypography.ui(
                    fontSize: 16,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: _Space.lg),
          _PrimaryTouchButton(
            icon: Icons.add_rounded,
            label: 'Add printer',
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }
}

/// Full-height primary action button — 72dp tall, bold fill, generous
/// padding. Stands in for `ElevatedButton.icon` / `FloatingActionButton`
/// wherever this screen needs its most important touch target.
///
/// Uses `colors.onPrimary` directly rather than deriving text color from
/// `primary`'s luminance at each call site — the theme already defines
/// what "on primary" means (and defines it per-mode, correctly), so
/// recomputing it here risked disagreeing with the rest of the app the
/// moment `primary` changes without a matching luminance flip.
class _PrimaryTouchButton extends StatelessWidget {
  const _PrimaryTouchButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.primary,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: _Space.xxl),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24, color: colors.onPrimary),
              const SizedBox(width: _Space.md),
              Text(
                label,
                style: AppTypography.ui(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: colors.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrinterCard extends StatelessWidget {
  const _PrinterCard({required this.printer, required this.onDelete});

  final PrinterDto printer;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(_Space.lg),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _connectionTypeIcon(printer.connectionType),
              size: 28,
              color: colors.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: _Space.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  printer.name,
                  style: AppTypography.ui(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: _Space.xs),
                // Icon-led metadata chips instead of a single bullet-joined
                // string. A counter panel is read at a glance, at an
                // angle — three facts stitched into one run-on sentence
                // ("BLUETOOTH • 00:11:... • 80mm paper") makes the reader
                // parse punctuation to find the piece they actually want
                // (usually the address, when troubleshooting a
                // disconnected printer). Separating them into distinct
                // chips with their own icon means the address is a
                // recognizable shape, not a substring to hunt for.
                Wrap(
                  spacing: _Space.md,
                  runSpacing: _Space.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _MetaChip(
                      icon: _connectionTypeIcon(printer.connectionType),
                      label: printer.connectionType,
                    ),
                    _MetaChip(icon: Icons.tag_rounded, label: printer.address),
                    _MetaChip(
                      icon: Icons.receipt_long_outlined,
                      label: '${printer.paperSize}mm',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: _Space.sm),
          _TouchIconButton(
            icon: Icons.delete_outline_rounded,
            tooltip: 'Remove printer',
            color: colors.danger,
            onPressed: onDelete,
            size: 56,
            iconSize: 26,
          ),
        ],
      ),
    );
  }
}

/// Small icon + label pair used in the printer card's metadata row. Kept
/// intentionally quiet (secondary text color, small icon) — this is
/// supporting detail, not a second headline competing with the printer
/// name above it.
class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: colors.textSecondary),
        const SizedBox(width: _Space.xs),
        Text(
          label,
          style: AppTypography.ui(fontSize: 14, color: colors.textSecondary),
        ),
      ],
    );
  }
}

/// -----------------------------------------------------------------------
/// ADD PRINTER — bottom sheet form, touch-optimized
/// -----------------------------------------------------------------------

const _connectionTypes = ['BLUETOOTH', 'WIFI', 'USB'];
const _paperSizes = ['58', '72', '80'];

class _AddPrinterSheet extends StatefulWidget {
  const _AddPrinterSheet();

  @override
  State<_AddPrinterSheet> createState() => _AddPrinterSheetState();
}

class _AddPrinterSheetState extends State<_AddPrinterSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  String? _connectionType;
  String? _paperSize;
  bool _showConnectionError = false;
  bool _showPaperSizeError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String get _addressLabel => switch (_connectionType) {
    'BLUETOOTH' => 'Device MAC address',
    'WIFI' => 'IP address',
    'USB' => 'Device path / port',
    _ => 'Address',
  };

  String get _addressHint => switch (_connectionType) {
    'BLUETOOTH' => '00:11:22:33:44:55',
    'WIFI' => '192.168.1.50',
    'USB' => '/dev/usb/lp0',
    _ => 'Select a connection type first',
  };

  bool get _hasUnsavedInput =>
      _nameController.text.trim().isNotEmpty ||
      _addressController.text.trim().isNotEmpty ||
      _connectionType != null ||
      _paperSize != null;

  /// Cancel and the hardware/gesture back action both route through here.
  /// An empty form closes immediately; a form with anything typed asks
  /// first — this is the actual fix for "annoying them because they have
  /// to enter all the details yet again": the sheet no longer takes that
  /// risk on their behalf from a single stray tap.
  Future<void> _confirmDiscardIfNeeded() async {
    if (!_hasUnsavedInput) {
      Navigator.of(context).pop();
      return;
    }

    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Discard this printer?'),
        content: const Text("What you've entered so far will be lost."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    if (shouldDiscard == true && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void _submit() {
    final formValid = _formKey.currentState!.validate();
    setState(() {
      _showConnectionError = _connectionType == null;
      _showPaperSizeError = _paperSize == null;
    });
    if (!formValid || _connectionType == null || _paperSize == null) return;

    final printer = PrinterDto(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      connectionType: _connectionType!,
      address: _addressController.text.trim(),
      paperSize: _paperSize!,
    );

    Navigator.of(context).pop(printer);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    // canPop: false + onPopInvokedWithResult routes the hardware/gesture
    // back action through the same confirm-before-discard check as the
    // Cancel button, instead of letting it silently close the sheet.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmDiscardIfNeeded();
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.92,
          ),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                _Space.xxxl,
                _Space.lg,
                _Space.xxxl,
                _Space.xxxl,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Drag-handle affordance. `enableDrag` is off (see
                    // `_openAddPrinterSheet`), so this is purely a visual
                    // "this is a sheet" cue, not a functional grab bar —
                    // worth keeping anyway so the surface doesn't look
                    // like it's missing something.
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: _Space.lg),
                        decoration: BoxDecoration(
                          color: colors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Add printer',
                            style: AppTypography.display(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                        _TouchIconButton(
                          icon: Icons.close_rounded,
                          tooltip: 'Close',
                          onPressed: _confirmDiscardIfNeeded,
                          size: 52,
                          iconSize: 22,
                        ),
                      ],
                    ),
                    const SizedBox(height: _Space.xxl),

                    // Name
                    const _FieldLabel('Printer name'),
                    const SizedBox(height: _Space.sm),
                    _TouchTextField(
                      controller: _nameController,
                      hintText: 'Front Counter Receipt',
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Enter a name for this printer'
                          : null,
                    ),
                    const SizedBox(height: _Space.xxl),

                    // Connection type — 3 options is a segmented control's
                    // sweet spot: every option is visible and one tap away,
                    // no dropdown overlay to open first.
                    const _FieldLabel('Connection type'),
                    const SizedBox(height: _Space.sm),
                    _SegmentedTouchControl(
                      options: _connectionTypes,
                      selected: _connectionType,
                      iconFor: _connectionTypeIcon,
                      onSelected: (value) => setState(() {
                        _connectionType = value;
                        _showConnectionError = false;
                      }),
                    ),
                    if (_showConnectionError) ...[
                      const SizedBox(height: _Space.sm),
                      const _ErrorText('Select a connection type'),
                    ],
                    const SizedBox(height: _Space.xxl),

                    // Address (label/hint adapts to connection type)
                    _FieldLabel(_addressLabel),
                    const SizedBox(height: _Space.sm),
                    _TouchTextField(
                      controller: _addressController,
                      hintText: _addressHint,
                      textInputAction: TextInputAction.next,
                      enabled: _connectionType != null,
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? "Enter the printer's address"
                          : null,
                    ),
                    const SizedBox(height: _Space.xxl),

                    // Paper size — same reasoning as connection type; 3
                    // fixed choices read faster as buttons than a dropdown.
                    const _FieldLabel('Paper size'),
                    const SizedBox(height: _Space.sm),
                    _SegmentedTouchControl(
                      options: _paperSizes,
                      selected: _paperSize,
                      labelFor: (size) => '${size}mm',
                      onSelected: (value) => setState(() {
                        _paperSize = value;
                        _showPaperSizeError = false;
                      }),
                    ),
                    if (_showPaperSizeError) ...[
                      const SizedBox(height: _Space.sm),
                      const _ErrorText('Select a paper size'),
                    ],
                    const SizedBox(height: _Space.xxxl),

                    Row(
                      children: [
                        Expanded(
                          child: _SecondaryTouchButton(
                            label: 'Cancel',
                            onPressed: _confirmDiscardIfNeeded,
                          ),
                        ),
                        const SizedBox(width: _Space.md),
                        Expanded(
                          flex: 2,
                          child: _PrimaryTouchButton(
                            icon: Icons.check_rounded,
                            label: 'Save printer',
                            onPressed: _submit,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Text(
      text,
      style: AppTypography.ui(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: colors.textSecondary,
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline_rounded, size: 16, color: colors.danger),
        const SizedBox(width: _Space.xs),
        Text(text, style: AppTypography.ui(fontSize: 14, color: colors.danger)),
      ],
    );
  }
}

/// 68dp-tall text field — taller than Material's default `TextFormField`
/// so the tap target and the on-screen keyboard's target text are both
/// comfortable at arm's length on a 14" panel.
class _TouchTextField extends StatelessWidget {
  const _TouchTextField({
    required this.controller,
    required this.hintText,
    this.textInputAction,
    this.validator,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      validator: validator,
      enabled: enabled,
      style: AppTypography.ui(fontSize: 18, color: colors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTypography.ui(fontSize: 18, color: colors.textDisabled),
        filled: true,
        fillColor: enabled ? colors.surfaceVariant : colors.disabledFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: _Space.xl,
          vertical: _Space.xl,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.primary, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.danger, width: 2),
        ),
      ),
    );
  }
}

/// Row of equal-width, 68dp-tall option buttons — replaces
/// `DropdownButtonFormField` for short, fixed option sets where every
/// choice can just be shown at once instead of hidden behind a menu.
///
/// Selected state now carries exactly one visual signal — a solid
/// `primary` fill — instead of the previous combination of a tinted
/// container fill *and* a separate colored border stacked on top of it.
/// Two overlapping cues for the same piece of state read as slightly
/// over-decorated up close (the border doing work the fill already did)
/// without actually making "selected" any clearer at a glance.
class _SegmentedTouchControl extends StatelessWidget {
  const _SegmentedTouchControl({
    required this.options,
    required this.selected,
    required this.onSelected,
    this.iconFor,
    this.labelFor,
  });

  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;
  final IconData Function(String)? iconFor;
  final String Function(String)? labelFor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        for (final option in options) ...[
          if (option != options.first) const SizedBox(width: _Space.md),
          Expanded(
            child: Builder(
              builder: (context) {
                final isSelected = option == selected;
                return Material(
                  color: isSelected ? colors.primary : colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: () => onSelected(option),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      height: 64,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (iconFor != null) ...[
                            Icon(
                              iconFor!(option),
                              size: 20,
                              color: isSelected
                                  ? colors.onPrimary
                                  : colors.textSecondary,
                            ),
                            const SizedBox(width: _Space.sm),
                          ],
                          Text(
                            labelFor != null ? labelFor!(option) : option,
                            style: AppTypography.ui(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? colors.onPrimary
                                  : colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _SecondaryTouchButton extends StatelessWidget {
  const _SecondaryTouchButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border, width: 2),
          ),
          child: Text(
            label,
            style: AppTypography.ui(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// PLACEHOLDER PANELS — used for Sync / System / Theme / Users / About
/// until each gets its real implementation, and also doubles as the
/// Printers panel's empty state (with an action button attached).
///
/// Previously `_ComingSoonPanel` and `_EmptyPrintersState` were two
/// pixel-for-pixel identical layouts maintained separately — same icon
/// circle, same heading/description sizing, same spacing, copy-pasted
/// rather than shared. One widget now covers both: the optional `action`
/// slot carries the "Add printer" button for the empty state, and the
/// optional `badge` carries the "Coming soon" tag for the stub sections,
/// so each caller only supplies what's actually different about it.
/// -----------------------------------------------------------------------

class _SyncPanel extends StatelessWidget {
  const _SyncPanel();

  @override
  Widget build(BuildContext context) {
    return const _PanelPlaceholder(
      icon: Icons.sync_rounded,
      title: 'Sync',
      description:
          'Manage data sync with the back office — connection status, '
          'last sync time, and manual sync controls will live here.',
      badge: 'Coming soon',
    );
  }
}

class _SystemPanel extends StatelessWidget {
  const _SystemPanel();

  @override
  Widget build(BuildContext context) {
    return const _PanelPlaceholder(
      icon: Icons.tune_rounded,
      title: 'System',
      description:
          'Device-level settings — receipt footer text, tax rates, '
          'currency, language, and hardware diagnostics.',
      badge: 'Coming soon',
    );
  }
}

class _ThemePanel extends StatelessWidget {
  const _ThemePanel();

  @override
  Widget build(BuildContext context) {
    return const _PanelPlaceholder(
      icon: Icons.palette_rounded,
      title: 'Theme',
      description:
          'Light, dark, or system appearance, plus any future '
          'branding/display options.',
      badge: 'Coming soon',
    );
  }
}

class _UsersPanel extends StatelessWidget {
  const _UsersPanel();

  @override
  Widget build(BuildContext context) {
    return const _PanelPlaceholder(
      icon: Icons.badge_rounded,
      title: 'Users',
      description:
          'Staff accounts, PIN/login setup, and role permissions '
          '(cashier vs. manager access).',
      badge: 'Coming soon',
    );
  }
}

class _AboutPanel extends StatelessWidget {
  const _AboutPanel();

  @override
  Widget build(BuildContext context) {
    return const _PanelPlaceholder(
      icon: Icons.info_rounded,
      title: 'About',
      description:
          'App version, build number, licenses, and support/contact '
          'information.',
      badge: 'Coming soon',
    );
  }
}

class _PanelPlaceholder extends StatelessWidget {
  const _PanelPlaceholder({
    required this.icon,
    required this.title,
    required this.description,
    this.badge,
    this.action,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? badge;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(_Space.huge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 52, color: colors.textDisabled),
            ),
            const SizedBox(height: _Space.xxl),
            Text(
              title,
              style: AppTypography.display(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: _Space.sm),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: AppTypography.ui(
                  fontSize: 16,
                  color: colors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
            if (badge != null) ...[
              const SizedBox(height: _Space.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: _Space.md,
                  vertical: _Space.xs,
                ),
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badge!,
                  style: AppTypography.ui(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colors.onPrimaryContainer,
                  ),
                ),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: _Space.xxl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
