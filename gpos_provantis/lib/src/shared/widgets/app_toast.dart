// Location: src/shared/widgets/app_toast.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';

/// =========================================================================
/// APP TOAST — the app-wide replacement for SnackBar.
///
/// WHY NOT SNACKBAR: a SnackBar is shown via `ScaffoldMessenger`, which is
/// scoped to whichever Scaffold/Navigator context called it — it queues
/// behind other snackbars in that same scope, and a Dialog (like
/// ConfirmDialog) painted above it will sit on top of it, not the other
/// way around. That's a real problem for a POS screen: an error toast
/// fired right as a confirmation dialog opens should still be visible,
/// not buried underneath it.
///
/// HOW "ALWAYS ON TOP" WORKS: this inserts a single OverlayEntry directly
/// into the app's ROOT Overlay — the same Overlay instance MaterialApp/
/// GoRouter's Navigator installs at the very top of the widget tree.
/// Since dialogs, routes, and bottom sheets are themselves just entries
/// pushed into that overlay (or a nested one), and this always targets
/// the *root* overlay specifically (`rootOverlay: true`), a toast fired
/// at any point — mid-navigation, over a dialog, over anything — paints
/// above all of it.
///
/// STACKING: unlike a SnackBar (and unlike this widget's earlier
/// single-toast version), calling `AppToast.show` repeatedly does NOT
/// replace what's on screen — each call pushes a new toast onto a
/// bottom-left stack, and each one animates in/out and times out
/// independently. The whole stack lives inside ONE OverlayEntry (an
/// `_AppToastStack` fed by a ChangeNotifier-backed queue) rather than
/// one OverlayEntry per toast, so ordering relative to the rest of the
/// app never has to be renegotiated as toasts come and go.
///
/// SETUP — call once in your root MaterialApp/GoRouter widget so a
/// BuildContext with access to the root Navigator exists:
///
///   MaterialApp.router(
///     routerConfig: router,
///     builder: (context, child) => AppToastHost(child: child!),
///   )
///
/// USAGE — from anywhere with a BuildContext:
///
///   AppToast.show(context, message: 'Sync complete');
///   AppToast.show(context, message: 'Domain did not save', type: AppToastType.error);
///
/// Flat fill, no shadow/blur — same performance discipline as the rest
/// of this app (see login_screen.dart's file header). Color logic
/// mirrors AppTheme's existing SnackBarThemeData (surfaceVariant/
/// textPrimary swap between light and dark) so a toast still reads as
/// a sibling of the thing it replaces, not a new invention.
/// =========================================================================

enum AppToastType { neutral, success, error }

/// Wrap your app's root widget (inside MaterialApp.builder) with this so
/// `AppToast.show` always has a root-overlay BuildContext to insert into,
/// regardless of which screen or dialog is currently active.
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

/// Holds the live list of toasts and notifies the single overlay entry
/// that hosts the stack. Kept separate from `AppToast` so the stack
/// widget can just `AnimatedBuilder`/listen off of it.
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

  /// Shows a toast above everything else in the app — other toasts,
  /// dialogs, bottom sheets, routes. Toasts stack bottom-left, each
  /// animating in and timing out independently — a fast sequence of
  /// events shows as a rising column rather than replacing or queuing
  /// behind one another.
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

  /// Dismiss every toast currently showing — e.g. when navigating away
  /// from the screen that triggered them.
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
          // AnimatedSize smooths the column's height as toasts are
          // added/removed, so when one in the middle times out and
          // exits, the ones above it slide down to close the gap
          // instead of jumping.
          child: AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              // Oldest toast is last in the list and rendered at the
              // bottom of this Column (closest to its trigger point);
              // each new one is appended above the previous, so the
              // stack rises upward as more arrive.
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
    // Flat fade + short rise — no bounce/elastic curve, matching this
    // app's general avoidance of decorative motion (see
    // organic_pattern_background.dart's restraint around animation).
    // Same controller drives both the entrance (0 -> 1, played forward
    // on init) and the exit (1 -> 0, played in reverse on dismiss), so
    // timing/curve stay identical coming and going.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _slide = Tween<Offset>(
      begin: const Offset(-0.08, 0), // rises in from the left edge
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
    // Play the entrance animation in reverse before actually removing
    // the entry from the queue, so it fades/slides out instead of
    // popping off; the surrounding AnimatedSize handles the reflow of
    // whatever toast was stacked above it.
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
        // Mirrors AppTheme.snackBarTheme exactly: surfaceVariant in dark
        // mode, textPrimary (a near-black/near-white ink color used as a
        // fill) in light mode — same inversion trick, same reasoning.
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
            // Flat fill, no elevation/shadow — consistent with the
            // rest of the app's cheap-to-paint discipline.
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
