import 'package:flutter/material.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'amount_input_formatter.dart';

class AmountNumpad extends StatelessWidget {
  const AmountNumpad({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;

  final ValueChanged<double?> onChanged;

  void _handleKey(NumpadKey key) {
    final current = TextEditingValue(
      text: controller.text,
      selection: controller.selection,
    );
    final next = applyNumpadKey(current, key);
    controller.value = next;
    onChanged(parseAmountField(next.text));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _NumpadRow(
            children: [
              _NumpadDigitKey(
                label: '7',
                onTap: () => _handleKey(NumpadKey.d7),
              ),
              _NumpadDigitKey(
                label: '8',
                onTap: () => _handleKey(NumpadKey.d8),
              ),
              _NumpadDigitKey(
                label: '9',
                onTap: () => _handleKey(NumpadKey.d9),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _NumpadRow(
            children: [
              _NumpadDigitKey(
                label: '4',
                onTap: () => _handleKey(NumpadKey.d4),
              ),
              _NumpadDigitKey(
                label: '5',
                onTap: () => _handleKey(NumpadKey.d5),
              ),
              _NumpadDigitKey(
                label: '6',
                onTap: () => _handleKey(NumpadKey.d6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _NumpadRow(
            children: [
              _NumpadDigitKey(
                label: '1',
                onTap: () => _handleKey(NumpadKey.d1),
              ),
              _NumpadDigitKey(
                label: '2',
                onTap: () => _handleKey(NumpadKey.d2),
              ),
              _NumpadDigitKey(
                label: '3',
                onTap: () => _handleKey(NumpadKey.d3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _NumpadRow(
            children: [
              _NumpadDigitKey(
                label: '.',
                onTap: () => _handleKey(NumpadKey.point),
              ),
              _NumpadDigitKey(
                label: '0',
                onTap: () => _handleKey(NumpadKey.d0),
              ),
              _NumpadBackspaceKey(onTap: () => _handleKey(NumpadKey.backspace)),
            ],
          ),
        ),
      ],
    );
  }
}

class _NumpadRow extends StatelessWidget {
  const _NumpadRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(child: children[i]),
        ],
      ],
    );
  }
}

class _NumpadDigitKey extends StatelessWidget {
  const _NumpadDigitKey({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surfaceVariant,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.border, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTypography.display(
              color: colors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _NumpadBackspaceKey extends StatelessWidget {
  const _NumpadBackspaceKey({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.border, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.backspace_outlined,
            size: 28,
            color: colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
