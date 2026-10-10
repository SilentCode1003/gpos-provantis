import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/shared/widgets/toast_emitter.dart';

enum AppToastType { neutral, success, warning, error }

/// Shows the toasts that controllers raise through [toastEmitterProvider].
///
/// Add it ONCE, somewhere that sits BELOW the app's Navigator (for example
/// around the dashboard screen), so it can find the overlay on its own:
///
///   AppToastHost(child: DashboardScreen())
///
/// If you would rather wrap the whole app (e.g. in `MaterialApp.builder`, which
/// sits ABOVE the Navigator), pass the app's navigator key so the host can
/// reach the overlay:
///
///   AppToastHost(navigatorKey: rootNavigatorKey, child: child)
///
/// Widgets that have a context can still call [AppToast.show] directly.
class AppToastHost extends ConsumerStatefulWidget {
  const AppToastHost({super.key, required this.child, this.navigatorKey});

  final Widget child;
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  ConsumerState<AppToastHost> createState() => _AppToastHostState();
}

class _AppToastHostState extends ConsumerState<AppToastHost> {
  StreamSubscription<ToastEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = ref.read(toastEmitterProvider).stream.listen(_onEvent);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _onEvent(ToastEvent event) {
    if (!mounted) return;

    final overlay =
        widget.navigatorKey?.currentState?.overlay ??
        Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      debugPrint(
        'Toast dropped (AppToastHost is above the Navigator; pass '
        'navigatorKey): ${event.message}',
      );
      return;
    }

    AppToast._showOn(
      overlay,
      message: event.message,
      type: _typeFor(event.kind),
      duration: event.duration,
    );
  }

  static AppToastType _typeFor(ToastKind kind) {
    switch (kind) {
      case ToastKind.success:
        return AppToastType.success;
      case ToastKind.warning:
        return AppToastType.warning;
      case ToastKind.error:
        return AppToastType.error;
      case ToastKind.info:
        return AppToastType.neutral;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

@immutable
class _ToastEntry {
  const _ToastEntry({
    required this.id,
    required this.message,
    required this.type,
    required this.duration,
  });

  final Object id;
  final String message;
  final AppToastType type;
  final Duration duration;
}

class _ToastQueue extends ChangeNotifier {
  /// More than this at once just covers the screen. The oldest is dropped.
  static const int maxVisible = 3;

  final List<_ToastEntry> entries = [];

  void add(_ToastEntry entry) {
    // The same message again (a double-tapped button failing twice) replaces
    // the one on screen instead of stacking a copy, and restarts its timer so
    // the cashier sees that the second attempt was answered too.
    entries.removeWhere(
      (e) => e.message == entry.message && e.type == entry.type,
    );
    entries.add(entry);
    while (entries.length > maxVisible) {
      entries.removeAt(0);
    }
    notifyListeners();
  }

  void remove(Object id) {
    entries.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void clear() {
    entries.clear();
    notifyListeners();
  }
}

abstract class AppToast {
  static final _ToastQueue _queue = _ToastQueue();
  static OverlayEntry? _hostEntry;
  static OverlayState? _hostOverlay;
  static int _nextId = 0;

  /// How long each kind stays up. Problems stay longer than confirmations, so
  /// a cashier glancing at the customer still has time to read them.
  static Duration defaultDurationFor(AppToastType type) {
    switch (type) {
      case AppToastType.success:
      case AppToastType.neutral:
        return const Duration(seconds: 3);
      case AppToastType.warning:
        return const Duration(seconds: 5);
      case AppToastType.error:
        return const Duration(seconds: 6);
    }
  }

  static void show(
    BuildContext context, {
    required String message,
    AppToastType type = AppToastType.neutral,
    Duration? duration,
  }) {
    _showOn(
      Overlay.of(context, rootOverlay: true),
      message: message,
      type: type,
      duration: duration,
    );
  }

  static void success(BuildContext context, String message) =>
      show(context, message: message, type: AppToastType.success);

  static void warning(BuildContext context, String message) =>
      show(context, message: message, type: AppToastType.warning);

  static void error(BuildContext context, String message) =>
      show(context, message: message, type: AppToastType.error);

  static void _showOn(
    OverlayState overlay, {
    required String message,
    required AppToastType type,
    Duration? duration,
  }) {
    final text = message.trim();
    if (text.isEmpty) return;

    _ensureHostOn(overlay);

    final id = _nextId++;
    _queue.add(
      _ToastEntry(
        id: id,
        message: text,
        type: type,
        duration: duration ?? defaultDurationFor(type),
      ),
    );
  }

  static void _ensureHostOn(OverlayState overlay) {
    final existing = _hostEntry;

    if (existing != null &&
        existing.mounted &&
        identical(_hostOverlay, overlay)) {
      // Sheets, dialogs and the payment modal are routes pushed AFTER the
      // host was first inserted, so they sit above it. Move the host back to
      // the top every time, or a toast raised while one is open (a refund
      // failing inside its sheet) would be hidden behind it.
      overlay.rearrange([existing]);
      return;
    }

    // First use, or the overlay it lived in is gone (e.g. app restarted its
    // navigator): the old entry is useless.
    if (existing != null && existing.mounted) existing.remove();

    final entry = OverlayEntry(
      builder: (context) => _AppToastStack(queue: _queue),
    );
    _hostEntry = entry;
    _hostOverlay = overlay;
    overlay.insert(entry);
  }

  static void dismiss() {
    _queue.clear();
  }
}

class _AppToastStack extends StatefulWidget {
  const _AppToastStack({required this.queue});

  final _ToastQueue queue;

  @override
  State<_AppToastStack> createState() => _AppToastStackState();
}

class _AppToastStackState extends State<_AppToastStack> {
  @override
  void initState() {
    super.initState();
    widget.queue.addListener(_onQueueChanged);
  }

  @override
  void dispose() {
    widget.queue.removeListener(_onQueueChanged);
    super.dispose();
  }

  void _onQueueChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final entries = widget.queue.entries;

    return Positioned(
      right: 16,
      bottom: mediaQuery.padding.bottom + 16,
      child: SafeArea(
        top: false,
        left: false,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),

          child: AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,

              children: [
                for (final entry in entries.reversed)
                  _AppToastView(
                    key: ValueKey(entry.id),
                    message: entry.message,
                    type: entry.type,
                    duration: entry.duration,
                    onDismiss: () => widget.queue.remove(entry.id),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppToastView extends StatefulWidget {
  const _AppToastView({
    super.key,
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismiss,
  });

  final String message;
  final AppToastType type;
  final Duration duration;
  final VoidCallback onDismiss;

  @override
  State<_AppToastView> createState() => _AppToastViewState();
}

class _AppToastViewState extends State<_AppToastView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  Timer? _dismissTimer;
  bool _closing = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0.08, 0), // Rise from right edge
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();

    _dismissTimer = Timer(widget.duration, _close);
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _close() async {
    if (_closing) return;
    _closing = true;
    _dismissTimer?.cancel();

    await _controller.reverse();
    if (mounted) widget.onDismiss();
  }

  // Warning has no token in the theme that I could rely on, so it uses fixed
  // amber values. Swap these for colors.warning / warningContainer /
  // onWarningContainer if AppColors has them.
  static const _warningFill = Color(0xFFB45309);
  static const _warningContent = Color(0xFFFFFFFF);
  static const _warningFillDark = Color(0xFF4A3410);
  static const _warningContentDark = Color(0xFFFFDDB0);

  Color _fillColor(AppColors colors) {
    switch (widget.type) {
      case AppToastType.success:
        return colors.isDark ? colors.successContainer : colors.success;
      case AppToastType.warning:
        return colors.isDark ? _warningFillDark : _warningFill;
      case AppToastType.error:
        return colors.isDark ? colors.dangerContainer : colors.danger;
      case AppToastType.neutral:
        return colors.isDark ? colors.surfaceVariant : colors.textPrimary;
    }
  }

  Color _contentColor(AppColors colors) {
    switch (widget.type) {
      case AppToastType.success:
        return colors.isDark ? colors.onSuccessContainer : colors.onSuccess;
      case AppToastType.warning:
        return colors.isDark ? _warningContentDark : _warningContent;
      case AppToastType.error:
        return colors.isDark ? colors.onDangerContainer : colors.onDanger;
      case AppToastType.neutral:
        return colors.isDark ? colors.textPrimary : colors.surface;
    }
  }

  /// A shape as well as a color, so success / warning / error can still be
  /// told apart by someone who can't see the colors well.
  IconData? get _icon {
    switch (widget.type) {
      case AppToastType.success:
        return Icons.check_circle_rounded;
      case AppToastType.warning:
        return Icons.warning_amber_rounded;
      case AppToastType.error:
        return Icons.error_rounded;
      case AppToastType.neutral:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final contentColor = _contentColor(colors);
    final icon = _icon;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Semantics(
            liveRegion: true,
            child: Material(
              color: _fillColor(colors),
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: _close,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 20, color: contentColor),
                        const SizedBox(width: 10),
                      ],
                      Flexible(
                        child: Text(
                          widget.message,
                          style: AppTypography.ui(
                            color: contentColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
