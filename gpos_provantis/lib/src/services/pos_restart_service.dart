// Location: src/services/pos_restart_service.dart
//
// "Restart POS" flow: confirm -> cancelable 5s countdown -> app exits
// and relaunches itself, on both Android and Windows.
//
// PLATFORM REALITY CHECK (read this before changing anything below):
// Neither Android nor Windows lets an app fully close-and-reopen
// itself using pure Dart/Flutter APIs — both OSes sandbox that for
// security reasons. The actual relaunch is done by the `restart_app`
// package (native code per platform):
//   - Android: relaunches the main activity via PackageManager, then
//     terminates the old process.
//   - Windows: spawns a new process of the same executable via
//     CreateProcess, then terminates the current one.
// This file only owns the everything-up-to-that-point UX (confirm
// dialog, countdown, cancel) and then hands off to that package for
// the actual OS-level relaunch. There's no way to implement the
// relaunch itself in pure Dart — if `restart_app` is ever removed,
// this whole flow needs a different native mechanism, not just a
// different function call.
//
// REQUIRES: restart_app: ^1.10.1 (or compatible — this targets the
// `Restart.restartApp()` -> `RestartResult` API introduced in 1.8.3)
// added to pubspec.yaml. This file will not compile without it.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restart_app/restart_app.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/routing/root_navigator_key.dart';

part 'pos_restart_service.g.dart';

/// Thin wrapper around `Restart.restartApp()` so call sites depend on
/// this service (mockable/testable) rather than the package directly.
@Riverpod(keepAlive: true)
PosRestartService posRestartService(Ref ref) => const PosRestartService();

class PosRestartService {
  const PosRestartService();

  /// Fires the actual OS-level restart. Does not return under normal
  /// success — the process is terminated by the native side. If it
  /// returns, `result.success` is false and the process is still
  /// alive, so the caller can show an error instead of just hanging.
  Future<RestartResult> restart() {
    return Restart.restartApp();
  }
}

/// Call this from a button's `onTap` (e.g. the "Restart POS" tile in
/// `OthersSheet`) to run the whole flow: confirm -> countdown -> exit
/// and relaunch. Handles its own dialogs; the caller doesn't need to
/// manage any state.
///
/// Deliberately does NOT take the caller's `BuildContext` for showing
/// dialogs — only `WidgetRef` to do a single, synchronous provider
/// read up front. Every dialog in this flow instead opens against
/// `rootNavigatorKey.currentContext`, the app's root Navigator context
/// (wired in via `GoRouter(navigatorKey: rootNavigatorKey, ...)` in
/// app_router.dart), which stays alive for the whole app lifetime.
///
/// That distinction is why the countdown dialog was silently failing
/// to appear before this fix: the original version took the caller's
/// context (a bottom-sheet list tile's), and the very first thing that
/// tap handler did was `Navigator.pop()` to close the sheet — which
/// starts tearing down that tile's context as part of the sheet's
/// close animation. The confirm dialog *happened* to still open (the
/// teardown likely hadn't reached it yet), but by the time the second
/// `showDialog` call ran for the countdown, that context was no longer
/// valid to open a dialog against, so it silently did nothing.
///
/// Usage:
/// ```dart
/// onTap: () => showRestartPosFlow(ref),
/// ```
Future<void> showRestartPosFlow(WidgetRef ref) async {
  // One-shot synchronous read of a `keepAlive` provider — safe to do
  // with a widget-scoped `ref` even though this function is async,
  // since it happens immediately, before any `await` in this function
  // gives anything a chance to unmount.
  final service = ref.read(posRestartServiceProvider);

  final confirmed = await _showConfirmDialog();
  if (confirmed != true) return;

  final proceeded = await _showCountdownDialog();
  if (proceeded != true) return;

  final result = await service.restart();

  // Only reachable if the restart failed — a successful restart kills
  // this process before this line would run.
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
          // AlertDialog lays `actions` out inside an OverflowBar, not a
          // Row/Flex — Expanded can't be a direct child of OverflowBar
          // (that's what threw "Incorrect use of ParentDataWidget").
          // Wrapping both buttons in one Row here gives Expanded a
          // real Flex ancestor, and that single Row becomes the one
          // and only item OverflowBar has to lay out.
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

/// Shows the 5-second cancelable countdown. Returns `true` if it ran
/// out and the restart should proceed, `false`/`null` if the person
/// tapped Cancel or dismissed the dialog before it finished.
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
      // Countdown reached zero — proceed with the restart.
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
              style: AppTypography.ui(color: colors.textSecondary, fontSize: 14),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          // Single button, so no Row/Expanded needed here — SizedBox
          // stretches it without requiring a Flex ancestor (OverflowBar
          // isn't one; see the note in _showConfirmDialog above).
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
