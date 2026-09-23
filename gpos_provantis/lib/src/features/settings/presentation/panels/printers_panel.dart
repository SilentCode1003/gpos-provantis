// Location: src/features/settings/panels/printers_panel.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/app_settings_controller.dart';
import '../controllers/settings_controller.dart';
import '../controllers/usb_scan_controller.dart';
import 'package:gpos_provantis/src/core/database/domain/printer_dto.dart';
import 'package:gpos_provantis/src/core/database/domain/settings_dto.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import '../screens/settings_shared.dart';
import 'package:gpos_provantis/src/services/printing/usb_printing.dart';
import 'package:gpos_provantis/src/services/printing/wifi_printing.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';

/// =========================================================================
/// PRINTERS PANEL — list/add/edit/test printers backed by `PrinterDto` and
/// `settingsControllerProvider`.
///
/// Split out of the old monolithic `settings_screen.dart` so this panel's
/// own future changes (new printer fields, real device status polling,
/// etc.) don't require touching or re-reading the rest of the settings
/// screen. Everything below is private to this file except `PrintersPanel`
/// itself, which the settings shell references from its section list.
///
/// PRINTER ASSIGNMENT — below the printer list, the user picks which saved
/// printer is the Main printer and which is the Sub printer. Only the
/// printer's uuid (`PrinterDto.id`) is stored, in the `mainPrinter` /
/// `subPrinter` columns of the settings row, saved through
/// `appSettingsProvider`. `UNREGISTERED` means "not assigned".
/// =========================================================================

/// -----------------------------------------------------------------------

/// Connection-type icon lookup, shared by the printer row and the add/edit
/// sheet — one source of truth instead of duplicating the switch twice.
IconData _connectionTypeIcon(String type) => switch (type) {
  'BLUETOOTH' => Icons.bluetooth_rounded,
  'WIFI' => Icons.wifi_rounded,
  'USB' => Icons.usb_rounded,
  _ => Icons.print_outlined,
};

/// Connection status shown as a colored dot + label on each row.
///
/// This is UI-only for now — there's no live device polling wired up yet,
/// so every printer renders as `online` until real status data exists.
/// Kept as its own enum (rather than a bool) so a future `connecting` or
/// `error` state slots in without reshaping the row widget.
enum _PrinterStatus { online, offline }

/// The two jobs a saved printer can be assigned to. The choice is stored
/// as the printer's uuid in the matching settings column.
enum _PrinterRole {
  main('Main printer', Icons.print_rounded),
  sub('Sub printer', Icons.print_outlined);

  const _PrinterRole(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// Finds the saved printer whose uuid is [id]. Returns `null` when nothing
/// is assigned (`UNREGISTERED`) or when the stored uuid no longer matches
/// any saved printer, so a stale assignment simply shows as "Not assigned".
PrinterDto? _printerById(List<PrinterDto> printers, String id) {
  for (final printer in printers) {
    if (printer.id == id) return printer;
  }
  return null;
}

class PrintersPanel extends ConsumerStatefulWidget {
  const PrintersPanel();

  @override
  ConsumerState<PrintersPanel> createState() => _PrintersPanelState();
}

class _PrintersPanelState extends ConsumerState<PrintersPanel> {
  final _usbPrinterService = UsbPrinterService();
  final _wifiPrinterService = WifiPrinterService();

  Future<void> _openAddPrinterSheet() async {
    final result = await showModalBottomSheet<PrinterDto>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => const _PrinterFormSheet(),
    );

    if (result != null) {
      await ref.read(settingsControllerProvider.notifier).addPrinter(result);
    }
  }

  Future<void> _openEditPrinterSheet(PrinterDto printer) async {
    final result = await showModalBottomSheet<PrinterDto>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => _PrinterFormSheet(existing: printer),
    );

    if (result != null) {
      await ref.read(settingsControllerProvider.notifier).updatePrinter(result);
    }
  }

  Future<void> _removePrinter(PrinterDto printer) async {
    try {
      await ref
          .read(settingsControllerProvider.notifier)
          .removePrinter(printer.id);

      // If this printer was the main or sub printer, un-assign it so the
      // settings never point at a printer that no longer exists.
      await ref
          .read(appSettingsProvider.notifier)
          .clearPrinterAssignment(printer.id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not remove printer: $e')));
    }
  }

  /// Opens the picker for [role] and saves the choice. Only the printer's
  /// uuid is stored; picking "None" stores `UNREGISTERED` (via null).
  Future<void> _openPrinterPicker({
    required _PrinterRole role,
    required List<PrinterDto> printers,
    required String? selectedId,
  }) async {
    final result = await showModalBottomSheet<_PickResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PrinterPickerSheet(
        role: role,
        printers: printers,
        selectedId: selectedId,
      ),
    );

    // Dismissed without choosing anything.
    if (result == null) return;

    final notifier = ref.read(appSettingsProvider.notifier);
    try {
      switch (role) {
        case _PrinterRole.main:
          await notifier.setMainPrinter(result.printerId);
        case _PrinterRole.sub:
          await notifier.setSubPrinter(result.printerId);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not save the ${role.label.toLowerCase()}.'),
        ),
      );
    }
  }

  /// Sends a real test ticket to [printer], routed to the USB or WiFi
  /// service based on its saved connection type. Bluetooth isn't wired up
  /// yet — there's no `BluetoothPrinterService` in this project — so that
  /// case shows a clear "not supported yet" message instead of silently
  /// doing nothing.
  Future<void> _testPrinter(BuildContext context, PrinterDto printer) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(content: Text('Sending test print to ${printer.name}…')),
    );

    try {
      switch (printer.connectionType) {
        case 'USB':
          await _usbPrinterService.printTestPage(printer);
        case 'WIFI':
          await _wifiPrinterService.printTestPage(printer);
        case 'BLUETOOTH':
          throw Exception('Bluetooth printing isn\'t wired up yet.');
        default:
          throw Exception('Unknown connection type: ${printer.connectionType}');
      }

      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Test print sent to ${printer.name}.')),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('Test print failed: $e')));
    }
  }

  Future<void> _openActionsSheet(PrinterDto printer) async {
    final colors = context.colors;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.fromLTRB(
          Space.lg,
          Space.md,
          Space.lg,
          Space.xxl,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: Space.lg),
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Space.sm),
                child: Text(
                  printer.name,
                  style: AppTypography.ui(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: Space.md),
              ActionSheetTile(
                icon: Icons.edit_outlined,
                label: 'Edit printer',
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _openEditPrinterSheet(printer);
                },
              ),
              ActionSheetTile(
                icon: Icons.print_outlined,
                label: 'Test print',
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _testPrinter(context, printer);
                },
              ),
              ActionSheetTile(
                icon: Icons.delete_outline_rounded,
                label: 'Remove printer',
                destructive: true,
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _removePrinter(printer);
                },
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
    final printersAsync = ref.watch(settingsControllerProvider);
    final settings =
        ref.watch(appSettingsProvider).value ?? SettingsDto.defaults();

    return Scaffold(
      backgroundColor: colors.background,
      body: printersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Failed to load printers: $error',
            style: AppTypography.ui(fontSize: 14, color: colors.danger),
          ),
        ),
        data: (printers) => ListView(
          padding: const EdgeInsets.fromLTRB(
            Space.xxxl,
            Space.xxl,
            Space.xxxl,
            Space.xxxl,
          ),
          children: [
            PanelHeader(
              title: 'Printers',
              subtitle: printers.isEmpty
                  ? 'No printers connected to this device yet'
                  : '${printers.length} '
                        '${printers.length == 1 ? 'printer' : 'printers'} connected',
            ),
            const SizedBox(height: Space.lg),
            // One continuous bordered group — rows separated by hairlines,
            // not floating cards — with the add-printer slot as the final
            // row rather than a separate button living above the list.
            //
            // Rounding lives on an explicit `ClipRRect` wrapping the whole
            // group, not on `Container.clipBehavior`. Any child that paints
            // its own full-perimeter border (as `_AddPrinterSlot` used to)
            // draws square corners that get sliced off right where the
            // parent's curve starts, which is what read as "cut off" on the
            // top/bottom edges. `_AddPrinterSlot` no longer paints a boxed
            // border at all — just a tinted fill and a top hairline — so
            // there's nothing left to visibly collide with the outer curve.
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.borderSubtle),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: Column(
                  children: [
                    for (final printer in printers) ...[
                      _PrinterRow(
                        printer: printer,
                        status: _PrinterStatus.online,
                        onTap: () => _openActionsSheet(printer),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: colors.borderSubtle,
                      ),
                    ],
                    _AddPrinterSlot(onTap: _openAddPrinterSheet),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Space.xxl),
            _PrinterAssignmentSection(
              mainPrinter: _printerById(printers, settings.mainPrinter),
              subPrinter: _printerById(printers, settings.subPrinter),
              hasPrinters: printers.isNotEmpty,
              onSelect: (role) => _openPrinterPicker(
                role: role,
                printers: printers,
                selectedId: _printerById(
                  printers,
                  role == _PrinterRole.main
                      ? settings.mainPrinter
                      : settings.subPrinter,
                )?.id,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single printer row — status dot, connection icon, name + metadata.
/// Tapping anywhere on the row opens the actions sheet (Edit / Test /
/// Remove); there are no inline icon buttons cluttering the row itself.
class _PrinterRow extends StatelessWidget {
  const _PrinterRow({
    required this.printer,
    required this.status,
    required this.onTap,
  });

  final PrinterDto printer;
  final _PrinterStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isOnline = status == _PrinterStatus.online;
    final statusColor = isOnline ? colors.success : colors.danger;

    return Material(
      color: colors.surface,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 76),
          padding: const EdgeInsets.symmetric(
            horizontal: Space.lg,
            vertical: Space.md,
          ),
          child: Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: Space.lg),
              Icon(
                _connectionTypeIcon(printer.connectionType),
                size: 22,
                color: colors.textSecondary,
              ),
              const SizedBox(width: Space.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      printer.name,
                      style: AppTypography.ui(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_connectionLabel(printer.connectionType)} · '
                      '${printer.address} · ${printer.paperSize}mm',
                      style: AppTypography.ui(
                        fontSize: 13,
                        color: colors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Space.md),
              Text(
                isOnline ? 'ONLINE' : 'OFFLINE',
                style: AppTypography.ui(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(width: Space.sm),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: colors.textDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _connectionLabel(String type) => switch (type) {
  'BLUETOOTH' => 'Bluetooth',
  'WIFI' => 'Wi-Fi',
  'USB' => 'USB',
  _ => type,
};

/// The redesigned "add printer" entry point: a dashed, tinted slot at the
/// end of the printer list, styled like the next open bay in a row of
/// hardware rather than a standalone button bolted above it. When the
/// list is empty, this is the only thing shown — the empty state and the
/// add action are now the same element instead of two separate pieces of
/// UI saying the same thing.
class _AddPrinterSlot extends StatelessWidget {
  const _AddPrinterSlot({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // No boxed border here — a full `Border.all` on a row that sits flush
    // against the group's rounded outer corners paints square edges that
    // visibly collide with the curve above/below it. A top hairline (the
    // same treatment as the dividers between printer rows) plus a tinted
    // fill reads as "this row is different" without fighting the parent's
    // rounding anywhere.
    return Material(
      color: colors.primaryContainer.withValues(alpha: 0.35),
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 72),
          padding: const EdgeInsets.symmetric(
            horizontal: Space.lg,
            vertical: Space.md,
          ),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: colors.primary.withValues(alpha: 0.35)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_rounded,
                  size: 18,
                  color: colors.onPrimary,
                ),
              ),
              const SizedBox(width: Space.md),
              Text(
                'Add another printer',
                style: AppTypography.ui(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.primary,
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
/// PRINTER ASSIGNMENT — two rows (Main / Sub). Tapping one opens a sheet
/// listing every saved printer to pick from.
/// -----------------------------------------------------------------------

class _PrinterAssignmentSection extends StatelessWidget {
  const _PrinterAssignmentSection({
    required this.mainPrinter,
    required this.subPrinter,
    required this.hasPrinters,
    required this.onSelect,
  });

  final PrinterDto? mainPrinter;
  final PrinterDto? subPrinter;
  final bool hasPrinters;
  final ValueChanged<_PrinterRole> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assigned printers',
          style: AppTypography.display(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: Space.xs),
        Text(
          'Choose which saved printer is the main printer and which is the '
          'sub printer',
          style: AppTypography.ui(fontSize: 15, color: colors.textSecondary),
        ),
        const SizedBox(height: Space.lg),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.borderSubtle),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: Column(
              children: [
                _AssignmentRow(
                  role: _PrinterRole.main,
                  printer: mainPrinter,
                  enabled: hasPrinters,
                  onTap: () => onSelect(_PrinterRole.main),
                ),
                Divider(height: 1, thickness: 1, color: colors.borderSubtle),
                _AssignmentRow(
                  role: _PrinterRole.sub,
                  printer: subPrinter,
                  enabled: hasPrinters,
                  onTap: () => onSelect(_PrinterRole.sub),
                ),
              ],
            ),
          ),
        ),
        if (!hasPrinters) ...[
          const SizedBox(height: Space.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.xs),
            child: Text(
              'Add a printer above to assign it.',
              style: AppTypography.ui(
                fontSize: 13,
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _AssignmentRow extends StatelessWidget {
  const _AssignmentRow({
    required this.role,
    required this.printer,
    required this.enabled,
    required this.onTap,
  });

  final _PrinterRole role;
  final PrinterDto? printer;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final assigned = printer;

    return Material(
      color: colors.surface,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Container(
          constraints: const BoxConstraints(minHeight: 76),
          padding: const EdgeInsets.symmetric(
            horizontal: Space.lg,
            vertical: Space.md,
          ),
          child: Row(
            children: [
              Icon(role.icon, size: 22, color: colors.textSecondary),
              const SizedBox(width: Space.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role.label,
                      style: AppTypography.ui(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      assigned == null
                          ? 'Not assigned'
                          : '${assigned.name} · '
                                '${_connectionLabel(assigned.connectionType)}',
                      style: AppTypography.ui(
                        fontSize: 13,
                        color: assigned == null
                            ? colors.textDisabled
                            : colors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Space.md),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: colors.textDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// What the picker sheet returns. Wrapping the id lets "None" (a `null`
/// printerId) be told apart from the sheet simply being dismissed (where
/// the sheet itself returns `null`).
class _PickResult {
  const _PickResult(this.printerId);

  final String? printerId;
}

class _PrinterPickerSheet extends StatelessWidget {
  const _PrinterPickerSheet({
    required this.role,
    required this.printers,
    required this.selectedId,
  });

  final _PrinterRole role;
  final List<PrinterDto> printers;

  /// The uuid of the printer currently assigned to [role], or `null` if
  /// none (which highlights the "None" row).
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      padding: const EdgeInsets.fromLTRB(
        Space.lg,
        Space.md,
        Space.lg,
        Space.xxl,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: Space.lg),
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.sm),
              child: Text(
                'Select ${role.label.toLowerCase()}',
                style: AppTypography.ui(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: Space.md),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final printer in printers)
                    _PickerTile(
                      icon: _connectionTypeIcon(printer.connectionType),
                      title: printer.name,
                      subtitle:
                          '${_connectionLabel(printer.connectionType)} · '
                          '${printer.address}',
                      selected: printer.id == selectedId,
                      onTap: () =>
                          Navigator.of(context).pop(_PickResult(printer.id)),
                    ),
                  _PickerTile(
                    icon: Icons.block_rounded,
                    title: 'None',
                    subtitle: 'Leave this printer unassigned',
                    selected: selectedId == null,
                    onTap: () =>
                        Navigator.of(context).pop(const _PickResult(null)),
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

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: Space.xs),
      child: Material(
        color: selected
            ? colors.primaryContainer.withValues(alpha: 0.35)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            constraints: const BoxConstraints(minHeight: 68),
            padding: const EdgeInsets.symmetric(
              horizontal: Space.md,
              vertical: Space.sm,
            ),
            child: Row(
              children: [
                Icon(icon, size: 22, color: colors.textSecondary),
                const SizedBox(width: Space.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.ui(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTypography.ui(
                          fontSize: 13,
                          color: colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Space.md),
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 24,
                  color: selected ? colors.primary : colors.textDisabled,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// PRINTER FORM SHEET — shared by both Add and Edit. Passing `existing`
/// pre-fills every field and switches the sheet into edit mode (title and
/// submit label change accordingly); omitting it is the add flow.
/// -----------------------------------------------------------------------

const _connectionTypes = ['BLUETOOTH', 'WIFI', 'USB'];
const _paperSizes = ['58', '72', '80'];

class _PrinterFormSheet extends ConsumerStatefulWidget {
  const _PrinterFormSheet({this.existing});

  /// When set, the sheet opens pre-filled for editing this printer rather
  /// than creating a new one.
  final PrinterDto? existing;

  bool get isEditing => existing != null;

  @override
  ConsumerState<_PrinterFormSheet> createState() => _PrinterFormSheetState();
}

class _PrinterFormSheetState extends ConsumerState<_PrinterFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(
    text: widget.existing?.name ?? '',
  );
  late final _addressController = TextEditingController(
    text: widget.existing?.address ?? '',
  );

  String? _connectionType;
  String? _paperSize;
  bool _showConnectionError = false;
  bool _showPaperSizeError = false;

  /// The USB device the user tapped in the scan results. `null` until they
  /// pick one, even if editing a printer that was originally USB — on
  /// edit, `_addressController` already carries the saved address, and a
  /// fresh pick here is what overrides it.
  Printer? _selectedUsbDevice;

  @override
  void initState() {
    super.initState();
    _connectionType = widget.existing?.connectionType;
    _paperSize = widget.existing?.paperSize;
  }

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

  /// Whether the form differs from its starting point — an empty form on
  /// add, or the original values on edit. Either way, this is what gates
  /// the discard-confirmation dialog: don't ask if there's nothing to lose.
  bool get _hasUnsavedChanges {
    final existing = widget.existing;
    if (existing == null) {
      return _nameController.text.trim().isNotEmpty ||
          _addressController.text.trim().isNotEmpty ||
          _connectionType != null ||
          _paperSize != null;
    }
    return _nameController.text.trim() != existing.name ||
        _addressController.text.trim() != existing.address ||
        _connectionType != existing.connectionType ||
        _paperSize != existing.paperSize;
  }

  Future<void> _confirmDiscardIfNeeded() async {
    if (!_hasUnsavedChanges) {
      Navigator.of(context).pop();
      return;
    }

    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          widget.isEditing ? 'Discard these changes?' : 'Discard this printer?',
        ),
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
    final addressMissing = _addressController.text.trim().isEmpty;
    setState(() {
      _showConnectionError = _connectionType == null;
      _showPaperSizeError = _paperSize == null;
    });
    if (!formValid || _connectionType == null || _paperSize == null) return;
    if (_connectionType == 'USB' && addressMissing) {
      // The USB branch swaps the text field for the device picker, so
      // there's no Form validator catching this — enforce it here instead.
      setState(() {});
      return;
    }

    final printer = PrinterDto(
      id:
          widget.existing?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
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
                Space.xxxl,
                Space.lg,
                Space.xxxl,
                Space.xxxl,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: Space.lg),
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
                            widget.isEditing ? 'Edit printer' : 'Add printer',
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
                    const SizedBox(height: Space.xxl),

                    const _FieldLabel('Printer name'),
                    const SizedBox(height: Space.sm),
                    _TouchTextField(
                      controller: _nameController,
                      hintText: 'Front Counter Receipt',
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Enter a name for this printer'
                          : null,
                    ),
                    const SizedBox(height: Space.xxl),

                    const _FieldLabel('Connection type'),
                    const SizedBox(height: Space.sm),
                    SegmentedTouchControl(
                      options: _connectionTypes,
                      selected: _connectionType,
                      iconFor: _connectionTypeIcon,
                      onSelected: (value) {
                        setState(() {
                          _connectionType = value;
                          _showConnectionError = false;
                        });
                        final scanController = ref.read(
                          usbScanControllerProvider.notifier,
                        );
                        if (value == 'USB') {
                          scanController.start();
                        } else {
                          scanController.stop();
                        }
                      },
                    ),
                    if (_showConnectionError) ...[
                      const SizedBox(height: Space.sm),
                      const _ErrorText('Select a connection type'),
                    ],
                    const SizedBox(height: Space.xxl),

                    _FieldLabel(_addressLabel),
                    const SizedBox(height: Space.sm),
                    if (_connectionType == 'USB')
                      _UsbDevicePicker(
                        selectedDevice: _selectedUsbDevice,
                        onDeviceSelected: (device) {
                          setState(() {
                            _selectedUsbDevice = device;
                            _addressController.text = device.address ?? '';
                            if (_nameController.text.trim().isEmpty &&
                                device.name != null) {
                              _nameController.text = device.name!;
                            }
                          });
                        },
                      )
                    else
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
                    if (_connectionType == 'USB' &&
                        _addressController.text.trim().isEmpty) ...[
                      const SizedBox(height: Space.sm),
                      const _ErrorText('Select a USB device'),
                    ],
                    const SizedBox(height: Space.xxl),

                    const _FieldLabel('Paper size'),
                    const SizedBox(height: Space.sm),
                    SegmentedTouchControl(
                      options: _paperSizes,
                      selected: _paperSize,
                      labelFor: (size) => '${size}mm',
                      onSelected: (value) => setState(() {
                        _paperSize = value;
                        _showPaperSizeError = false;
                      }),
                    ),
                    if (_showPaperSizeError) ...[
                      const SizedBox(height: Space.sm),
                      const _ErrorText('Select a paper size'),
                    ],
                    const SizedBox(height: Space.xxxl),

                    Row(
                      children: [
                        Expanded(
                          child: _SecondaryTouchButton(
                            label: 'Cancel',
                            onPressed: _confirmDiscardIfNeeded,
                          ),
                        ),
                        const SizedBox(width: Space.md),
                        Expanded(
                          flex: 2,
                          child: _PrimaryTouchButton(
                            icon: Icons.check_rounded,
                            label: widget.isEditing
                                ? 'Save changes'
                                : 'Save printer',
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

/// Scan button + live device list for the USB branch of the printer form.
/// Watches `usbScanControllerProvider`, so it updates as devices are found
/// without the parent form needing to know anything about the scan stream.
class _UsbDevicePicker extends ConsumerWidget {
  const _UsbDevicePicker({
    required this.selectedDevice,
    required this.onDeviceSelected,
  });

  final Printer? selectedDevice;
  final ValueChanged<Printer> onDeviceSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final scanState = ref.watch(usbScanControllerProvider);
    final scanController = ref.read(usbScanControllerProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(Space.md),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: scanState.isScanning ? colors.danger : colors.primary,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: scanState.isScanning
                  ? scanController.stop
                  : scanController.start,
              child: Container(
                height: 56,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      scanState.isScanning
                          ? Icons.stop_rounded
                          : Icons.search_rounded,
                      size: 20,
                      color: colors.onPrimary,
                    ),
                    const SizedBox(width: Space.sm),
                    Text(
                      scanState.isScanning
                          ? 'Stop scanning'
                          : 'Scan for USB printers',
                      style: AppTypography.ui(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colors.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (scanState.isScanning) ...[
            const SizedBox(height: Space.sm),
            const LinearProgressIndicator(),
          ],
          if (selectedDevice != null) ...[
            const SizedBox(height: Space.sm),
            Container(
              padding: const EdgeInsets.all(Space.sm),
              decoration: BoxDecoration(
                color: colors.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.success),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: colors.success,
                  ),
                  const SizedBox(width: Space.sm),
                  Expanded(
                    child: Text(
                      'Selected: ${selectedDevice!.name ?? selectedDevice!.address}',
                      style: AppTypography.ui(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: colors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (scanState.devices.isNotEmpty) ...[
            const SizedBox(height: Space.sm),
            Container(
              constraints: const BoxConstraints(maxHeight: 220),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.borderSubtle),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: scanState.devices.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: colors.borderSubtle),
                itemBuilder: (context, index) {
                  final device = scanState.devices[index];
                  final isSelected = selectedDevice?.address == device.address;
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onDeviceSelected(device),
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 60),
                        padding: const EdgeInsets.symmetric(
                          horizontal: Space.md,
                          vertical: Space.sm,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    device.name ?? 'Unknown device',
                                    style: AppTypography.ui(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    device.address ?? '—',
                                    style: AppTypography.ui(
                                      fontSize: 12,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check_rounded, color: colors.success),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else if (!scanState.isScanning) ...[
            const SizedBox(height: Space.sm),
            Text(
              'No USB printers found yet. Make sure it\'s plugged in and tap scan.',
              style: AppTypography.ui(
                fontSize: 13,
                color: colors.textSecondary,
              ),
            ),
          ],
        ],
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
        const SizedBox(width: Space.xs),
        Text(text, style: AppTypography.ui(fontSize: 14, color: colors.danger)),
      ],
    );
  }
}

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
          horizontal: Space.xl,
          vertical: Space.xl,
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
          padding: const EdgeInsets.symmetric(horizontal: Space.xxl),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24, color: colors.onPrimary),
              const SizedBox(width: Space.md),
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
