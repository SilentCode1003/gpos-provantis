import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/services/check_health_service.dart';
import 'package:gpos_provantis/src/shared/widgets/toast_emitter.dart';

/// Shows the "can't reach the server" dialog. Resolves to true when the
/// connection came back while it was open, otherwise false/null (dismissed).
Future<bool?> showServerReconnectDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (_) => const ServerReconnectDialog(),
  );
}

/// Same look as [ConfirmDialog], but the confirm button actually checks the
/// server and stays open (with a spinner) until it has an answer. If the
/// background health poll sees the server return first, it closes itself.
class ServerReconnectDialog extends ConsumerStatefulWidget {
  const ServerReconnectDialog({super.key});

  @override
  ConsumerState<ServerReconnectDialog> createState() =>
      _ServerReconnectDialogState();
}

class _ServerReconnectDialogState extends ConsumerState<ServerReconnectDialog> {
  bool _busy = false;
  bool _closed = false;
  String? _error;

  void _closeAsConnected() {
    if (_closed || !mounted) return;
    _closed = true;
    ref.read(toastEmitterProvider).success('Server connection restored.');
    Navigator.of(context).pop(true);
  }

  Future<void> _reconnect() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });

    final ok = await ref
        .read(serverHealthControllerProvider.notifier)
        .checkNow();

    if (!mounted || _closed) return;
    if (ok) {
      _closeAsConnected();
    } else {
      setState(() {
        _busy = false;
        _error =
            'Still can\'t reach the server. Check the connection and try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // The poll may reconnect on its own while the dialog is open.
    ref.listen<ServerHealthStatus>(serverHealthControllerProvider, (_, next) {
      if (next == ServerHealthStatus.online) _closeAsConnected();
    });

    return Dialog(
      backgroundColor: colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.border),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CONNECTION LOST',
                    style: AppTypography.ui(
                      color: colors.danger,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Can\'t reach the server',
                    style: AppTypography.display(
                      color: colors.textPrimary,
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'This device has been disconnected from the server for a '
                    'while. You can keep selling; sales are saved here and '
                    'sent once the connection is back. Tap Reconnect to try '
                    'again now.',
                    style: AppTypography.ui(
                      color: colors.textSecondary,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: AppTypography.ui(
                        color: colors.danger,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: colors.borderSubtle),
            Row(
              children: [
                Expanded(
                  child: _Action(
                    label: 'Dismiss',
                    color: colors.textPrimary,
                    onPressed: _busy
                        ? null
                        : () => Navigator.of(context).pop(false),
                  ),
                ),
                Container(width: 1, height: 52, color: colors.borderSubtle),
                Expanded(
                  child: _Action(
                    label: 'Reconnect',
                    color: colors.primary,
                    busy: _busy,
                    onPressed: _busy ? null : _reconnect,
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

class _Action extends StatelessWidget {
  const _Action({
    required this.label,
    required this.color,
    required this.onPressed,
    this.busy = false,
  });

  final String label;
  final Color color;
  final VoidCallback? onPressed;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          height: 52,
          child: Center(
            child: busy
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: color,
                    ),
                  )
                : Text(
                    label,
                    style: AppTypography.ui(
                      color: onPressed == null
                          ? color.withValues(alpha: 0.4)
                          : color,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
