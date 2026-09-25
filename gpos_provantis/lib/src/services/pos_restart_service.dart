import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restart_app/restart_app.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/routing/root_navigator_key.dart';

part 'pos_restart_service.g.dart';

@Riverpod(keepAlive: true)
PosRestartService posRestartService(Ref ref) => const PosRestartService();

class PosRestartService {
  const PosRestartService();

  Future<RestartResult> restart() {
    return Restart.restartApp();
  }
}

Future<void> showRestartPosFlow(WidgetRef ref) async {
  final service = ref.read(posRestartServiceProvider);

  final confirmed = await _showConfirmDialog();
  if (confirmed != true) return;

  final proceeded = await _showCountdownDialog();
  if (proceeded != true) return;

  final result = await service.restart();

  final context = rootNavigatorKey.currentContext;
  if (context == null || !context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Restart failed: ${result.message ?? result.code ?? 'unknown error'}',
      ),
    ),
  );
}

Future<bool?> _showConfirmDialog() {
  final context = rootNavigatorKey.currentContext;
  if (context == null) return Future.value(null);
  final colors = context.colors;

  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Restart POS?',
          style: AppTypography.display(
            color: colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'The app will close completely and reopen itself. '
          'Any unsaved changes on this screen will be lost.',
          style: AppTypography.ui(color: colors.textSecondary, fontSize: 14),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: _DialogButton(
                  label: 'Cancel',
                  onTap: () => Navigator.of(context).pop(false),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _DialogButton(
                  label: 'Proceed',
                  emphasized: true,
                  onTap: () => Navigator.of(context).pop(true),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future<bool?> _showCountdownDialog() {
  final context = rootNavigatorKey.currentContext;
  if (context == null) return Future.value(null);

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const _CountdownDialog(),
  );
}

class _CountdownDialog extends StatefulWidget {
  const _CountdownDialog();

  @override
  State<_CountdownDialog> createState() => _CountdownDialogState();
}

class _CountdownDialogState extends State<_CountdownDialog> {
  static const _startSeconds = 5;
  int _secondsLeft = _startSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  void _onTick(Timer timer) {
    if (_secondsLeft <= 1) {
      timer.cancel();

      Navigator.of(context).pop(true);
      return;
    }
    setState(() => _secondsLeft -= 1);
  }

  void _cancel() {
    _timer?.cancel();
    Navigator.of(context).pop(false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _cancel();
      },
      child: AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Restarting POS…',
          style: AppTypography.display(
            color: colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 72,
              height: 72,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: CircularProgressIndicator(
                      value: _secondsLeft / _startSeconds,
                      strokeWidth: 4,
                      backgroundColor: colors.surfaceVariant,
                      color: AppPalette.teal500,
                    ),
                  ),
                  Text(
                    '$_secondsLeft',
                    style: AppTypography.display(
                      color: colors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'The app will close and reopen automatically.',
              textAlign: TextAlign.center,
              style: AppTypography.ui(
                color: colors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          SizedBox(
            width: double.infinity,
            child: _DialogButton(label: 'Cancel', onTap: _cancel),
          ),
        ],
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.onTap,
    this.emphasized = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fill = emphasized ? AppPalette.teal500 : colors.surfaceVariant;
    final foreground = emphasized ? colors.onPrimary : colors.textPrimary;

    return Material(
      color: fill,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 52,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            label,
            style: AppTypography.ui(
              color: foreground,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
