import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'dashboard_constants.dart';

/// Max width of the floating bar. It is centered in the space the layout
/// gives it, instead of stretching edge to edge.
const double _maxBarWidth = 420;

/// Floating barcode entry field.
///
/// - Tap it: focus -> the on-screen keyboard opens.
/// - Tap anywhere else: focus is lost -> the keyboard closes.
/// - Press Enter (a barcode scanner sends Enter after every scan) or tap the
///   "Add" button: the barcode is looked up in the local product table and the
///   product is added to the cart.
///
/// The field keeps focus after each submit so back-to-back scans just work.
class BarcodeScanBar extends ConsumerStatefulWidget {
  const BarcodeScanBar({super.key});

  @override
  ConsumerState<BarcodeScanBar> createState() => _BarcodeScanBarState();
}

class _BarcodeScanBarState extends ConsumerState<BarcodeScanBar> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  Timer? _feedbackTimer;
  _ScanFeedback? _feedback;

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final raw = _textController.text;

    // Empty Enter (e.g. a stray key press): do nothing, keep focus.
    if (raw.trim().isEmpty) {
      _focusNode.requestFocus();
      return;
    }

    final result = ref
        .read(dashboardControllerProvider.notifier)
        .addToCartByBarcode(raw);

    switch (result.status) {
      case BarcodeScanStatus.added:
        _textController.clear();
        _showFeedback(_ScanFeedback.success('${result.product!.name} added'));
      case BarcodeScanStatus.outOfStock:
        _selectAll();
        _showFeedback(
          _ScanFeedback.error('${result.product!.name} is out of stock'),
        );
      case BarcodeScanStatus.notFound:
        _selectAll();
        _showFeedback(
          _ScanFeedback.error('No product found for "${raw.trim()}"'),
        );
      case BarcodeScanStatus.notReady:
        _showFeedback(_ScanFeedback.error('Products are still loading'));
    }

    // Stay focused so the next scan lands in the field.
    _focusNode.requestFocus();
  }

  /// After a failed lookup, keep the bad code visible but selected, so the
  /// next scan or keystroke replaces it instead of appending to it.
  void _selectAll() {
    _textController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _textController.text.length,
    );
  }

  void _showFeedback(_ScanFeedback feedback) {
    _feedbackTimer?.cancel();
    setState(() => _feedback = feedback);
    _feedbackTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) setState(() => _feedback = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Align(
      alignment: Alignment.bottomCenter,
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxBarWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              switchInCurve: Curves.easeOut,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1,
                  child: child,
                ),
              ),
              child: _feedback == null
                  ? const SizedBox.shrink(key: ValueKey('no-feedback'))
                  : Padding(
                      key: ValueKey(_feedback),
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _FeedbackPill(feedback: _feedback!),
                    ),
            ),
            Material(
              color: colors.surface,
              elevation: 6,
              shadowColor: Colors.black.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: colors.borderSubtle),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: minTapTarget,
                        child: TextField(
                          controller: _textController,
                          focusNode: _focusNode,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          expands: true,
                          maxLines: null,
                          minLines: null,
                          textAlignVertical: TextAlignVertical.center,
                          autocorrect: false,
                          enableSuggestions: false,
                          // Overriding onEditingComplete stops Flutter from
                          // unfocusing on Enter, so repeated scans keep working.
                          onEditingComplete: _submit,
                          // Tap anywhere outside -> lose focus -> keyboard closes.
                          onTapOutside: (_) => _focusNode.unfocus(),
                          style: AppTypography.ui(
                            color: colors.textPrimary,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Scan or enter barcode…',
                            hintStyle: AppTypography.ui(
                              color: colors.textDisabled,
                              fontSize: 15,
                            ),
                            prefixIcon: Icon(
                              Icons.qr_code_scanner_rounded,
                              color: colors.textDisabled,
                              size: 22,
                            ),
                            filled: true,
                            fillColor: colors.surfaceVariant,
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // TextFieldTapRegion: tapping this button is NOT an "outside"
                    // tap, so the field keeps focus (and the keyboard) when used.
                    TextFieldTapRegion(
                      child: SizedBox(
                        height: minTapTarget,
                        child: FilledButton.icon(
                          onPressed: _submit,
                          icon: const Icon(
                            Icons.keyboard_return_rounded,
                            size: 20,
                          ),
                          label: Text(
                            'Add',
                            style: AppTypography.ui(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppPalette.teal500,
                            minimumSize: const Size(0, minTapTarget),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            foregroundColor: colors.onPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanFeedback {
  const _ScanFeedback._(this.message, this.isError);

  factory _ScanFeedback.success(String message) =>
      _ScanFeedback._(message, false);
  factory _ScanFeedback.error(String message) => _ScanFeedback._(message, true);

  final String message;
  final bool isError;
}

class _FeedbackPill extends StatelessWidget {
  const _FeedbackPill({required this.feedback});

  final _ScanFeedback feedback;

  @override
  Widget build(BuildContext context) {
    final bg = feedback.isError
        ? Theme.of(context).colorScheme.error
        : AppPalette.teal500;

    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                feedback.isError
                    ? Icons.error_outline_rounded
                    : Icons.check_circle_outline_rounded,
                size: 18,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  feedback.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.ui(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
