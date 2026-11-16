import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/shared/widgets/toast_emitter.dart';

/// One piece of printer work that is waiting for, or using, the printer.
class PrintJobInfo {
  const PrintJobInfo({required this.id, required this.label});

  final int id;

  /// Short text for the on-screen indicator, e.g. "Sale #1042".
  final String label;
}

/// Runs printer work in the background, one job at a time, in the order it
/// was queued.
///
/// Why this exists: an offline printer makes every print attempt wait for a
/// connection timeout. When the sale flow awaited that, the cashier was stuck
/// on the payment screen for those seconds. Now the sale is saved and
/// announced straight away, and the printing happens here.
///
/// Why one at a time: a printer can't take two jobs at once (two writes to
/// the same USB / Bluetooth device, or two sockets to one Wi-Fi printer, can
/// interleave or be refused), so a second sale rung up while the first is
/// still printing waits its turn instead of racing it.
///
/// The state is the list of jobs not finished yet (the one printing now plus
/// those waiting). While it is not empty, a "Printing…" loading toast is shown
/// through the app's [ToastEmitter] (bottom-right, stacked with the other
/// toasts); it goes away by itself when the last job finishes.
///
/// It is a plain (non-autoDispose) provider on purpose: a job must outlive the
/// screen or controller that started it.
class PrintQueue extends Notifier<List<PrintJobInfo>> {
  Future<void> _tail = Future<void>.value();
  int _nextId = 0;
  ToastHandle? _loadingToast;

  @override
  List<PrintJobInfo> build() => const [];

  /// Keeps the loading toast in step with [state]: shown while there is work,
  /// its text updated as jobs finish, removed when the queue is empty.
  void _syncToast() {
    final jobs = state;
    if (jobs.isEmpty) {
      _loadingToast?.dismiss();
      _loadingToast = null;
      return;
    }
    final message = jobs.length == 1
        ? 'Printing receipt for ${jobs.first.label}…'
        : 'Printing ${jobs.length} receipts…';
    final toast = _loadingToast;
    if (toast == null) {
      _loadingToast = ref.read(toastEmitterProvider).loading(message);
    } else {
      toast.update(message);
    }
  }

  /// Adds [run] to the queue and returns a future that completes when it has
  /// finished (it never completes with an error, so it is safe to ignore).
  ///
  /// [run] is responsible for reporting its own print problems to the cashier;
  /// anything it still throws is only logged, so one failed job can never stop
  /// the jobs behind it.
  Future<void> enqueue({
    required String label,
    required Future<void> Function() run,
  }) {
    final id = _nextId++;
    state = [...state, PrintJobInfo(id: id, label: label)];
    _syncToast();

    final done = _tail.then((_) async {
      try {
        await run();
      } catch (e, st) {
        debugPrint('[PrintQueue] job "$label" threw: $e\n$st');
      } finally {
        state = [
          for (final job in state)
            if (job.id != id) job,
        ];
        _syncToast();
      }
    });
    _tail = done;
    return done;
  }
}

final printQueueProvider = NotifierProvider<PrintQueue, List<PrintJobInfo>>(
  PrintQueue.new,
);
