import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/services/factory_reset_service.dart';
import '../screens/settings_shared.dart';

class FactoryResetPanel extends ConsumerStatefulWidget {
  const FactoryResetPanel({super.key});

  @override
  ConsumerState<FactoryResetPanel> createState() => _FactoryResetPanelState();
}

class _FactoryResetPanelState extends ConsumerState<FactoryResetPanel> {
  bool _busy = false;

  Future<void> _onResetPressed() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const _ConfirmResetDialog(),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);

    final service = ref.read(factoryResetServiceProvider);
    final messenger = ScaffoldMessenger.of(context);

    try {
      // Wipes the data, then restarts the app. Normally never returns.
      await service.resetAndRestart();
    } catch (e) {
      if (mounted) setState(() => _busy = false);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            e is FactoryResetException ? e.message : 'Factory reset failed: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListView(
      padding: settingsPanelPadding(context),
      children: [
        const PanelHeader(
          title: 'Factory Reset',
          subtitle: 'Erase all local data and start over',
        ),
        const SizedBox(height: Space.lg),
        Container(
          padding: const EdgeInsets.all(Space.xl),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.danger),
            color: colors.surface,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: colors.danger),
                  const SizedBox(width: Space.sm),
                  Text(
                    'Danger zone',
                    style: AppTypography.ui(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colors.danger,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Space.md),
              Text(
                'This permanently erases all data stored on this device: '
                'configuration, users, products, sales, shifts, receipts, '
                'printers and everything else stored locally. Any data that '
                'has not been synced to the back office will be lost.\n\n'
                'The app will restart and return to its first-launch state. '
                'You will need to set it up again.',
                style: AppTypography.ui(
                  fontSize: 15,
                  color: colors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: Space.xl),
              Material(
                color: colors.danger,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: _busy ? null : _onResetPressed,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    height: 56,
                    alignment: Alignment.center,
                    child: _busy
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Factory reset this device',
                            style: AppTypography.ui(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
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

class _ConfirmResetDialog extends StatelessWidget {
  const _ConfirmResetDialog();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AlertDialog(
      backgroundColor: colors.surface,
      title: Text(
        'Erase everything?',
        style: AppTypography.display(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
        ),
      ),
      content: Text(
        'All local data on this device will be permanently deleted. '
        'This cannot be undone.',
        style: AppTypography.ui(fontSize: 15, color: colors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: colors.danger),
          child: const Text('Erase everything'),
        ),
      ],
    );
  }
}
