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
  const BarcodeScanBar({super.key, this.compact = false});

  /// Phone mode: shows only a round button at the bottom right. Tapping it
  /// opens the full bar (and the keyboard); tapping elsewhere collapses it.
  final bool compact;

  @override
  ConsumerState<BarcodeScanBar> createState() => _BarcodeScanBarState();
}

class _BarcodeScanBarState extends ConsumerState<BarcodeScanBar> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  Timer? _feedbackTimer;
  _ScanFeedback? _feedback;

  /// Only used when [BarcodeScanBar.compact] is true.
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    // Focus lost (tap outside / keyboard dismissed) -> fold back to the button.
    if (widget.compact && _expanded && !_focusNode.hasFocus) {
      setState(() => _expanded = false);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
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

    const noBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide.none,
    );

    final collapsed = widget.compact && !_expanded;

    return Align(
      alignment: collapsed ? Alignment.bottomRight : Alignment.bottomCenter,
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: collapsed ? double.infinity : _maxBarWidth,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: collapsed
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.stretch,
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
            if (collapsed)
              Material(
                color: colors.primary,
                shape: const CircleBorder(),
                elevation: colors.isDark ? 0 : 6,
                shadowColor: colors.shadow,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => setState(() => _expanded = true),
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(
                      Icons.qr_code_scanner_rounded,
                      color: colors.onPrimary,
                      size: 26,
                    ),
                  ),
                ),
              )
            else
              Material(
                color: colors.surface,
                // On dark surfaces a shadow just looks muddy; the border does
                // the separating there.
                elevation: colors.isDark ? 0 : 6,
                shadowColor: colors.shadow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                  side: BorderSide(
                    color: colors.isDark ? colors.border : colors.borderSubtle,
                  ),
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
                            // Phone: the field only exists after tapping the
                            // round button, so open the keyboard right away.
                            autofocus: widget.compact,
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
                                color: colors.primary,
                                size: 22,
                              ),
                              filled: true,
                              fillColor: colors.surfaceVariant,
                              contentPadding: EdgeInsets.zero,
                              border: noBorder,
                              enabledBorder: noBorder,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: colors.primary,
                                  width: 1.5,
                                ),
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
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              minimumSize: const Size(0, minTapTarget),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
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
    final colors = context.colors;

    final bg = feedback.isError ? colors.danger : colors.primary;
    final fg = feedback.isError ? colors.onDanger : colors.onPrimary;

    return Align(
      alignment: Alignment.centerLeft,
      widthFactor: 1,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        elevation: colors.isDark ? 0 : 3,
        shadowColor: colors.shadow,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                feedback.isError
                    ? Icons.error_outline_rounded
                    : Icons.check_circle_outline_rounded,
                size: 18,
                color: fg,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  feedback.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.ui(
                    color: fg,
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
