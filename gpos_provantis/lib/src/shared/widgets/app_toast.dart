import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';

enum AppToastType { neutral, success, error }

class AppToastHost extends StatelessWidget {
  const AppToastHost({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
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
  final List<_ToastEntry> entries = [];

  void add(_ToastEntry entry) {
    entries.add(entry);
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
  static int _nextId = 0;

  static void show(
    BuildContext context, {
    required String message,
    AppToastType type = AppToastType.neutral,
    Duration duration = const Duration(seconds: 3),
  }) {
    _ensureHostInserted(context);

    final id = _nextId++;
    _queue.add(
      _ToastEntry(id: id, message: message, type: type, duration: duration),
    );
  }

  static void _ensureHostInserted(BuildContext context) {
    if (_hostEntry != null) return;

    final overlay = Overlay.of(context, rootOverlay: true);
    late final OverlayEntry entry;
    entry = OverlayEntry(builder: (context) => _AppToastStack(queue: _queue));
    _hostEntry = entry;
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

  void _onQueueChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final entries = widget.queue.entries;

    return Positioned(
      left: 16,
      bottom: mediaQuery.padding.bottom + 16,
      child: SafeArea(
        top: false,
        right: false,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),

          child: AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,

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
      begin: const Offset(-0.08, 0), // Rise from left edge
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

  Color _fillColor(AppColors colors) {
    switch (widget.type) {
      case AppToastType.success:
        return colors.isDark ? colors.successContainer : colors.success;
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
      case AppToastType.error:
        return colors.isDark ? colors.onDangerContainer : colors.onDanger;
      case AppToastType.neutral:
        return colors.isDark ? colors.textPrimary : colors.surface;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
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
                child: Text(
                  widget.message,
                  style: AppTypography.ui(
                    color: _contentColor(colors),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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
