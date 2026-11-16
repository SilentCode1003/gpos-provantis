import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint, immutable;
import 'package:riverpod/riverpod.dart';

/// How a toast should look. Kept separate from the widget's `AppToastType` so
/// controllers can raise toasts without importing any Flutter widgets.
///
/// [loading] is different from the others: it has no timer. It stays until the
/// [ToastHandle] returned by [ToastEmitter.loading] dismisses it.
enum ToastKind { success, warning, error, info, loading }

@immutable
class ToastEvent {
  const ToastEvent(
    this.kind,
    this.message, {
    this.duration,
    this.id,
    this.dismiss = false,
  });

  final ToastKind kind;
  final String message;

  /// Null means "use the default for [kind]".
  final Duration? duration;

  /// Set only for a toast that is changed or removed later (see
  /// [ToastEmitter.loading]). An event with an id that is already on screen
  /// replaces that toast in place instead of stacking a new one.
  final int? id;

  /// True: remove the toast with this [id]. [message] is ignored.
  final bool dismiss;
}

/// Controls one toast that stays on screen until it is dismissed, such as the
/// "Printing…" toast. Get one from [ToastEmitter.loading].
class ToastHandle {
  ToastHandle._(this._emitter, this._id);

  final ToastEmitter _emitter;
  final int _id;
  bool _done = false;

  /// Changes the text of the toast that is already showing.
  void update(String message) {
    final text = message.trim();
    if (_done || text.isEmpty) return;
    _emitter._emit(ToastEvent(ToastKind.loading, text, id: _id));
  }

  /// Removes the toast. Calling it again does nothing.
  void dismiss() {
    if (_done) return;
    _done = true;
    _emitter._emit(ToastEvent(ToastKind.loading, '', id: _id, dismiss: true));
  }
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

  int _nextId = 0;

  void _emit(ToastEvent event) {
    if (_controller.isClosed) return;
    if (!_controller.hasListener) {
      // Nothing is mounted to show it. Almost always means AppToastHost was
      // never added to the widget tree.
      if (!event.dismiss) {
        debugPrint(
          'Toast dropped (no AppToastHost is listening): ${event.message}',
        );
      }
      return;
    }
    _controller.add(event);
  }

  void show(ToastKind kind, String message, {Duration? duration}) {
    final text = message.trim();
    if (text.isEmpty) return;
    _emit(ToastEvent(kind, text, duration: duration));
  }

  /// Shows a toast with a spinner that stays until the returned handle's
  /// [ToastHandle.dismiss] is called. For work that runs in the background
  /// (printing a receipt) so the cashier can keep working while it finishes.
  ToastHandle loading(String message) {
    final handle = ToastHandle._(this, _nextId++);
    final text = message.trim();
    if (text.isNotEmpty) {
      _emit(ToastEvent(ToastKind.loading, text, id: handle._id));
    }
    return handle;
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
