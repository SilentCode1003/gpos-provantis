import 'package:flutter/material.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'settings_shared.dart';

// Building blocks shared by the settings panels that are made of cards
// (Product Images, Sync).

class SettingsCard extends StatelessWidget {
  const SettingsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.borderSubtle),
        color: colors.surface,
      ),
      child: child,
    );
  }
}

class SettingsCardTitle extends StatelessWidget {
  const SettingsCardTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Text(
      title,
      style: AppTypography.ui(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
      ),
    );
  }
}

class SettingsCardDescription extends StatelessWidget {
  const SettingsCardDescription({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Text(
      text,
      style: AppTypography.ui(
        fontSize: 13,
        height: 1.4,
        color: colors.textSecondary,
      ),
    );
  }
}

class SettingsToggleCard extends StatelessWidget {
  const SettingsToggleCard({
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingsCardTitle(title: title),
                const SizedBox(height: Space.xs),
                SettingsCardDescription(text: description),
              ],
            ),
          ),
          const SizedBox(width: Space.md),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class SettingsActionCard extends StatelessWidget {
  const SettingsActionCard({
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.icon,
    required this.enabled,
    required this.onPressed,
    this.destructive = false,
  });

  final String title;
  final String description;
  final String buttonLabel;
  final IconData icon;
  final bool enabled;
  final bool destructive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsCardTitle(title: title),
          const SizedBox(height: Space.xs),
          SettingsCardDescription(text: description),
          const SizedBox(height: Space.md),
          FilledButton.icon(
            onPressed: enabled ? onPressed : null,
            icon: Icon(icon, size: 20),
            label: Text(buttonLabel),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: destructive ? colors.danger : colors.primary,
              foregroundColor: destructive ? Colors.white : colors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsChoiceChip extends StatelessWidget {
  const SettingsChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: selected ? colors.primary : colors.surfaceVariant,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: Space.lg),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTypography.ui(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: selected ? colors.onPrimary : colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
