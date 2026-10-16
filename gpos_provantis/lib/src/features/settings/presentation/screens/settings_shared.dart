import 'package:flutter/material.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';

abstract class Space {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;
}

/// Below this screen width (phone portrait) Settings switches to a
/// list -> detail layout. At or above it, the original side-nav layout is
/// used unchanged.
const kCompactSettingsWidth = 600.0;

bool isCompactLayout(BuildContext context) =>
    MediaQuery.sizeOf(context).width < kCompactSettingsWidth;

/// Page padding for a settings panel. [wide] is each panel's original padding
/// and is returned untouched everywhere except on compact (phone) screens.
EdgeInsets settingsPanelPadding(
  BuildContext context, {
  EdgeInsets wide = const EdgeInsets.fromLTRB(
    Space.xxxl,
    Space.xxl,
    Space.xxxl,
    Space.xxxl,
  ),
}) {
  return isCompactLayout(context)
      ? const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, Space.xxl)
      : wide;
}

class SettingsSection {
  const SettingsSection({
    required this.label,
    required this.icon,
    required this.builder,
  });

  final String label;
  final IconData icon;
  final Widget Function() builder;
}

class PanelHeader extends StatelessWidget {
  const PanelHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.display(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: Space.xs),
        Text(
          subtitle,
          style: AppTypography.ui(fontSize: 16, color: colors.textSecondary),
        ),
      ],
    );
  }
}

class ActionSheetTile extends StatelessWidget {
  const ActionSheetTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = destructive ? colors.danger : colors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: Space.sm),
          child: Row(
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(width: Space.lg),
              Text(
                label,
                style: AppTypography.ui(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SegmentedTouchControl extends StatelessWidget {
  const SegmentedTouchControl({
    required this.options,
    required this.selected,
    required this.onSelected,
    this.iconFor,
    this.labelFor,
  });

  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;
  final IconData Function(String)? iconFor;
  final String Function(String)? labelFor;

  /// Below this per-option width, icon + label no longer fit side by side
  /// (e.g. "BLUETOOTH" on a phone), so the icon is stacked above the label.
  static const _stackBelowWidth = 120.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        for (final option in options) ...[
          if (option != options.first) const SizedBox(width: Space.md),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isSelected = option == selected;
                final stacked =
                    iconFor != null && constraints.maxWidth < _stackBelowWidth;
                final foreground = isSelected
                    ? colors.onPrimary
                    : colors.textPrimary;
                final iconColor = isSelected
                    ? colors.onPrimary
                    : colors.textSecondary;

                final label = Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      labelFor != null ? labelFor!(option) : option,
                      maxLines: 1,
                      style: AppTypography.ui(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: foreground,
                      ),
                    ),
                  ),
                );

                return Material(
                  color: isSelected ? colors.primary : colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: () => onSelected(option),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      height: 64,
                      alignment: Alignment.center,
                      padding: stacked
                          ? const EdgeInsets.symmetric(horizontal: Space.xs)
                          : EdgeInsets.zero,
                      child: stacked
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  iconFor!(option),
                                  size: 20,
                                  color: iconColor,
                                ),
                                const SizedBox(height: Space.xs),
                                label,
                              ],
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (iconFor != null) ...[
                                  Icon(
                                    iconFor!(option),
                                    size: 20,
                                    color: iconColor,
                                  ),
                                  const SizedBox(width: Space.sm),
                                ],
                                label,
                              ],
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class PanelPlaceholder extends StatelessWidget {
  const PanelPlaceholder({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 44, color: colors.textDisabled),
            ),
            const SizedBox(height: Space.xl),
            Text(
              title,
              style: AppTypography.display(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: Space.sm),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: AppTypography.ui(
                  fontSize: 15,
                  color: colors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: Space.md),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Space.md,
                vertical: Space.xs,
              ),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Coming soon',
                style: AppTypography.ui(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colors.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
