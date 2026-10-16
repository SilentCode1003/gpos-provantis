import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/routing/root_navigator_key.dart';
import 'package:gpos_provantis/src/services/check_health_service.dart';
import 'package:gpos_provantis/src/shared/widgets/server_reconnect_dialog.dart';

/// How long the server must stay unreachable before the prompt appears.
const Duration kReconnectPromptDelay = Duration(minutes: 15);

/// Wraps the app (inside `MaterialApp.builder`) and shows
/// [ServerReconnectDialog] ONCE per outage.
///
/// - The clock starts when the health check first reports offline and is
///   cancelled the moment it reports online, so a flapping connection never
///   reaches the threshold; only a continuous outage does.
/// - After it has been shown (even if dismissed) it will not appear again
///   until the server has been online and then gone down for a full new
///   [kReconnectPromptDelay].
class ServerReconnectPrompt extends ConsumerStatefulWidget {
  const ServerReconnectPrompt({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ServerReconnectPrompt> createState() =>
      _ServerReconnectPromptState();
}

class _ServerReconnectPromptState extends ConsumerState<ServerReconnectPrompt> {
  Timer? _timer;
  bool _shownThisOutage = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual<ServerHealthStatus>(
      serverHealthControllerProvider,
      (_, next) => _onStatus(next),
      fireImmediately: true,
    );
  }

  void _onStatus(ServerHealthStatus status) {
    switch (status) {
      case ServerHealthStatus.offline:
        // Keep any running clock; don't restart it on every 10s poll.
        if (!_shownThisOutage) {
          _timer ??= Timer(kReconnectPromptDelay, _onThreshold);
        }
      case ServerHealthStatus.online:
        // Outage over: reset so the NEXT outage can prompt once again.
        _timer?.cancel();
        _timer = null;
        _shownThisOutage = false;
      case ServerHealthStatus.checking:
        // Neutral (first boot, or a manual re-check): leave things as is.
        break;
    }
  }

  Future<void> _onThreshold() async {
    _timer = null;
    if (!mounted || _shownThisOutage) return;
    if (ref.read(serverHealthControllerProvider) !=
        ServerHealthStatus.offline) {
      return;
    }

    // This widget sits ABOVE the Navigator, so use the root navigator's context.
    final navContext = rootNavigatorKey.currentContext;
    if (navContext == null) return;

    _shownThisOutage = true;
    await showServerReconnectDialog(navContext);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
