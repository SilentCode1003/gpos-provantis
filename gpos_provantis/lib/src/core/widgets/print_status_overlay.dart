import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/printutil/print_queue.dart';

/// Small "Printing…" indicator in the bottom-right corner, shown while the
/// background [PrintQueue] has work. Disappears by itself when the queue is
/// empty. Taps pass straight through it, so it never blocks the cashier.
///
/// Must be a direct child of a [Stack] that covers the screen, e.g. the
/// dashboard body or `MaterialApp.builder`:
///
/// ```dart
/// Stack(children: [dashboardBody, const PrintStatusOverlay()])
/// ```
class PrintStatusOverlay extends ConsumerWidget {
  const PrintStatusOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobs = ref.watch(printQueueProvider);
    final scheme = Theme.of(context).colorScheme;

    final String? message = switch (jobs.length) {
      0 => null,
      1 => 'Printing receipt for ${jobs.first.label}…',
      _ => 'Printing ${jobs.length} receipts…',
    };

    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: message == null
                ? const SizedBox.shrink(key: ValueKey('print-idle'))
                : ConstrainedBox(
                    key: const ValueKey('print-busy'),
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Material(
                      elevation: 6,
                      color: scheme.inverseSurface,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: scheme.onInverseSurface,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                message,
                                style: TextStyle(
                                  color: scheme.onInverseSurface,
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
