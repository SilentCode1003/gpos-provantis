import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint, immutable;
import 'package:riverpod/riverpod.dart';

/// How a toast should look. Kept separate from the widget's `AppToastType` so
/// controllers can raise toasts without importing any Flutter widgets.
enum ToastKind { success, warning, error, info }

@immutable
class ToastEvent {
  const ToastEvent(this.kind, this.message, {this.duration});

  final ToastKind kind;
  final String message;

  /// Null means "use the default for [kind]".
  final Duration? duration;
}

/// Lets a controller tell the cashier how something went, without needing a
/// `BuildContext`.
///
/// Controllers call [success] / [warning] / [error] / [info]. A single
/// `AppToastHost` near the top of the widget tree listens to [stream] and shows
/// the toast.
///
/// Rule of thumb for the three levels on a transaction:
///  * success: it happened, and everything that matters worked.
///  * warning: it happened, but something around it didn't (e.g. the sale is
///    saved but the receipt did not print). The cashier must NOT redo it.
///  * error: it did not happen.
class ToastEmitter {
  final StreamController<ToastEvent> _controller =
      StreamController<ToastEvent>.broadcast();

  Stream<ToastEvent> get stream => _controller.stream;

  void show(ToastKind kind, String message, {Duration? duration}) {
    final text = message.trim();
    if (text.isEmpty || _controller.isClosed) return;
    if (!_controller.hasListener) {
      // Nothing is mounted to show it. Almost always means AppToastHost was
      // never added to the widget tree.
      debugPrint('Toast dropped (no AppToastHost is listening): $text');
      return;
    }
    _controller.add(ToastEvent(kind, text, duration: duration));
  }

  void success(String message, {Duration? duration}) =>
      show(ToastKind.success, message, duration: duration);

  void warning(String message, {Duration? duration}) =>
      show(ToastKind.warning, message, duration: duration);

  void error(String message, {Duration? duration}) =>
      show(ToastKind.error, message, duration: duration);

  void info(String message, {Duration? duration}) =>
      show(ToastKind.info, message, duration: duration);

  void dispose() => _controller.close();
}

/// Not auto-dispose on purpose: a controller that finishes its work after its
/// screen closed (a refund, a print) can still report the result.
final toastEmitterProvider = Provider<ToastEmitter>((ref) {
  final emitter = ToastEmitter();
  ref.onDispose(emitter.dispose);
  return emitter;
});
