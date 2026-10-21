import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/database/domain/settings_dto.dart';
import 'package:gpos_provantis/src/core/database/providers/settings_dao_provider.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/settings/presentation/controllers/sync_settings_controller.dart';
import 'package:gpos_provantis/src/services/check_health_service.dart';
import 'package:gpos_provantis/src/shared/widgets/confirm_dialog.dart';
import '../screens/settings_cards.dart';
import '../screens/settings_shared.dart';

/// Custom schedule limits, in hours (decimals allowed: 0.5 = 30 minutes).
const _minHours = 0.1;
const _maxHours = 720.0;

const _presets = <(int, String)>[
  (0, 'Off'),
  (60, 'Every hour'),
  (120, 'Every 2 hours'),
  (180, 'Every 3 hours'),
];

class SyncPanel extends ConsumerStatefulWidget {
  const SyncPanel({super.key});

  @override
  ConsumerState<SyncPanel> createState() => _SyncPanelState();
}

class _SyncPanelState extends ConsumerState<SyncPanel> {
  final _hoursController = TextEditingController();
  String? _hoursError;

  @override
  void dispose() {
    _hoursController.dispose();
    super.dispose();
  }

  void _setMinutes(int minutes) {
    FocusScope.of(context).unfocus();
    setState(() => _hoursError = null);
    _hoursController.clear();
    ref
        .read(syncSettingsControllerProvider.notifier)
        .setAutoSyncIntervalMinutes(minutes);
  }

  void _applyCustomHours() {
    final hours = double.tryParse(
      _hoursController.text.trim().replaceAll(',', '.'),
    );
    if (hours == null || hours < _minHours || hours > _maxHours) {
      setState(
        () => _hoursError =
            'Enter hours from $_minHours to ${_maxHours.toInt()}. '
            'Decimals work, e.g. 0.5 is 30 minutes.',
      );
      return;
    }
    _setMinutes((hours * 60).round());
  }

  Future<void> _onAutoDeleteChanged(bool value) async {
    final controller = ref.read(syncSettingsControllerProvider.notifier);
    if (!value) {
      await controller.setAutoDeleteSyncedDataOnLogout(false);
      return;
    }
    final confirmed = await showConfirmDialog(
      context,
      eyebrow: 'DELETE SYNCED DATA ON LOGOUT',
      title: 'Turn this on?',
      body:
          'From now on, logging out deletes the data downloaded from the '
          'server (products, prices, staff and so on) from this device. '
          'Sales and split payments are never deleted. The next login needs '
          'an internet connection to download everything again.',
      confirmLabel: 'Turn on',
      isDestructive: false,
    );
    if (confirmed != true || !mounted) return;
    await controller.setAutoDeleteSyncedDataOnLogout(true);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final settings =
        ref.watch(syncSettingsProvider).value ?? const SyncSettings();
    final job = ref.watch(syncSettingsControllerProvider);
    final health = ref.watch(serverHealthControllerProvider);
    final controller = ref.read(syncSettingsControllerProvider.notifier);
    final minutes = settings.autoSyncIntervalMinutes;

    final (statusText, statusColor) = switch (health) {
      ServerHealthStatus.online => ('Online', colors.primary),
      ServerHealthStatus.offline => ('Offline', colors.danger),
      ServerHealthStatus.checking => ('Checking…', colors.textSecondary),
    };

    return ListView(
      padding: settingsPanelPadding(context),
      children: [
        const PanelHeader(
          title: 'Sync',
          subtitle: 'Choose when this device sends and downloads data',
        ),
        const SizedBox(height: Space.lg),

        SettingsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SettingsCardTitle(title: 'Sync now'),
              const SizedBox(height: Space.xs),
              const SettingsCardDescription(
                text:
                    'Sends anything waiting on this device to the server, then '
                    'downloads the latest products, prices, staff and '
                    'settings.',
              ),
              const SizedBox(height: Space.md),
              Row(
                children: [
                  Icon(Icons.circle, size: 10, color: statusColor),
                  const SizedBox(width: Space.sm),
                  Text(
                    'Server: $statusText',
                    style: AppTypography.ui(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Space.xs),
              Text(
                settings.lastCatalogSyncAt == null
                    ? 'Last synced: not yet'
                    : 'Last synced: ${_dateTime(settings.lastCatalogSyncAt!)}',
                style: AppTypography.ui(
                  fontSize: 13,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: Space.md),
              FilledButton.icon(
                onPressed: job.syncing ? null : controller.syncNow,
                icon: job.syncing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sync_rounded, size: 20),
                label: Text(job.syncing ? 'Syncing…' : 'Sync now'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Space.md),

        SettingsToggleCard(
          title: 'Sync after each sale',
          description:
              'On: sales are sent to the server right after each sale (and '
              'tried again every 30 seconds if the server could not be '
              'reached). Off: nothing is sent automatically. Sales stay saved '
              'on this device until you tap Sync now or the Auto-sync '
              'schedule runs.',
          value: settings.autoSyncAfterTransaction,
          onChanged: controller.setAutoSyncAfterTransaction,
        ),
        const SizedBox(height: Space.md),

        SettingsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SettingsCardTitle(title: 'Auto-sync schedule'),
              const SizedBox(height: Space.xs),
              const SettingsCardDescription(
                text:
                    'Syncs by itself while the app is open: sends what is '
                    'waiting, then downloads the latest data. It runs quietly '
                    'in the background, waits while the cart has items or the '
                    'server can\'t be reached, then tries again.',
              ),
              const SizedBox(height: Space.md),
              Wrap(
                spacing: Space.sm,
                runSpacing: Space.sm,
                children: [
                  for (final (value, label) in _presets)
                    SettingsChoiceChip(
                      label: label,
                      selected: minutes == value,
                      onTap: () => _setMinutes(value),
                    ),
                ],
              ),
              const SizedBox(height: Space.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _hoursController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                      ],
                      textInputAction: TextInputAction.done,
                      onChanged: (_) {
                        if (_hoursError != null) {
                          setState(() => _hoursError = null);
                        }
                      },
                      onSubmitted: (_) => _applyCustomHours(),
                      decoration: InputDecoration(
                        labelText: 'Custom: every how many hours?',
                        hintText: 'e.g. 0.5',
                        errorText: _hoursError,
                        errorMaxLines: 2,
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: Space.md),
                  SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: _applyCustomHours,
                      child: const Text('Set'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Space.md),
              Text(
                minutes <= 0
                    ? 'Schedule: off. The app only syncs when you sync.'
                    : 'Schedule: every ${_formatInterval(minutes)}.',
                style: AppTypography.ui(
                  fontSize: 13,
                  height: 1.4,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Space.md),

        SettingsToggleCard(
          title: 'Delete synced data on logout',
          description:
              'When you log out, deletes the data downloaded from the server '
              '(products, prices, staff and so on) from this device. Sales '
              'and split payments are never deleted, so nothing waiting to be '
              'sent is lost. The next login needs an internet connection to '
              'download everything again.',
          value: settings.autoDeleteSyncedDataOnLogout,
          onChanged: _onAutoDeleteChanged,
        ),
      ],
    );
  }

  /// 60 -> "hour", 120 -> "2 hours", 30 -> "30 minutes", 90 -> "1.5 hours".
  static String _formatInterval(int minutes) {
    if (minutes < 60) return '$minutes minutes';
    if (minutes % 60 == 0) {
      final hours = minutes ~/ 60;
      return hours == 1 ? 'hour' : '$hours hours';
    }
    final text = (minutes / 60)
        .toStringAsFixed(2)
        .replaceFirst(RegExp(r'\.?0+$'), '');
    return '$text hours';
  }

  static String _dateTime(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}';
  }
}
