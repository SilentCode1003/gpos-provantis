import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/printutil/order_slip_generator.dart';

/// Wrap the dashboard screen in this once. When a sale finishes and the Order
/// Slip setting is "ask", the generator queues a request; this widget shows
/// the prompt for it and prints the slip if the cashier says yes.
///
/// It must sit BELOW the app's Navigator (i.e. inside a screen, not in
/// MaterialApp.builder), because it opens a dialog.
///
///   OrderSlipPromptHost(child: Scaffold(...))
class OrderSlipPromptHost extends ConsumerStatefulWidget {
  const OrderSlipPromptHost({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<OrderSlipPromptHost> createState() =>
      _OrderSlipPromptHostState();
}

class _OrderSlipPromptHostState extends ConsumerState<OrderSlipPromptHost> {
  bool _showing = false;

  @override
  void initState() {
    super.initState();
    // A request may already be waiting if this screen was rebuilt or the
    // user came back to it.
    WidgetsBinding.instance.addPostFrameCallback((_) => _showNext());
  }

  Future<void> _showNext() async {
    if (_showing || !mounted) return;
    final queue = ref.read(orderSlipPromptQueueProvider);
    if (queue.isEmpty) return;

    final request = queue.first;
    _showing = true;

    final shouldPrint =
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => OrderSlipPromptDialog(request: request),
        ) ??
        false;

    // Answered either way, so it leaves the queue.
    ref.read(orderSlipPromptQueueProvider.notifier).resolve(request);
    _showing = false;

    if (shouldPrint) {
      // Not awaited: the next prompt (if any) shouldn't wait on the printer.
      unawaited(
        ref.read(orderSlipGeneratorProvider).printConfirmed(request.data),
      );
    }

    if (mounted) unawaited(_showNext());
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(orderSlipPromptQueueProvider, (previous, next) {
      if (next.isEmpty) return;
      WidgetsBinding.instance.addPostFrameCallback((_) => _showNext());
    });
    return widget.child;
  }
}

/// The question itself. Pops `true` for Print and `false` for Skip, and does
/// no printing on its own.
class OrderSlipPromptDialog extends StatelessWidget {
  const OrderSlipPromptDialog({super.key, required this.request});

  final OrderSlipPromptRequest request;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final data = request.data;
    final itemCount = data.totalItemCount;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Print order slip?',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Sale #${data.detailId} · $itemCount '
                          '${itemCount == 1 ? 'item' : 'items'}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  itemCount: data.items.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: scheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                  itemBuilder: (_, index) {
                    final item = data.items[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '× ${item.quantity}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.print_outlined,
                    size: 16,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Prints on ${request.printerName}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text('Skip'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      autofocus: true,
                      onPressed: () => Navigator.of(context).pop(true),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      icon: const Icon(Icons.print_rounded),
                      label: const Text('Print slip'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
