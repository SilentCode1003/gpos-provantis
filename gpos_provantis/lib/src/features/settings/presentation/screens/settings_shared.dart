// Location: src/features/settings/settings_shared.dart
import 'package:flutter/material.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';

/// =========================================================================
/// SETTINGS SHARED — widgets and constants used by more than one settings
/// panel (or by the settings shell itself).
///
/// Kept deliberately small: a widget only belongs here once a second panel
/// actually needs it. Anything used by exactly one panel should live next
/// to that panel instead (e.g. `_FieldLabel`, `_TouchTextField` live in
/// `panels/printers_panel.dart` since only the printer form uses them).
/// =========================================================================

/// Fixed spacing scale — every gap on the settings screen comes from here
/// rather than a one-off number, so rhythm stays consistent as the screen
/// grows.
abstract class Space {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;
}

/// One entry in the settings nav strip: icon + label + which panel it
/// shows when selected.
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

/// Simple title/subtitle header, used at the top of every panel.
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

/// One row inside a bottom-sheet list of actions (e.g. the printer actions
/// sheet: Edit / Test / Remove). Generic enough for any future "tap a row,
/// open a sheet of actions" panel.
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

/// A row of mutually-exclusive string options rendered as touch-sized
/// segments. Used by the printer form (connection type, paper size) and
/// the theme panel (light/system/dark) — any future single-choice picker
/// on this screen should reach for this rather than a new widget.
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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        for (final option in options) ...[
          if (option != options.first) const SizedBox(width: Space.md),
          Expanded(
            child: Builder(
              builder: (context) {
                final isSelected = option == selected;
                return Material(
                  color: isSelected ? colors.primary : colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: () => onSelected(option),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      height: 64,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (iconFor != null) ...[
                            Icon(
                              iconFor!(option),
                              size: 20,
                              color: isSelected
                                  ? colors.onPrimary
                                  : colors.textSecondary,
                            ),
                            const SizedBox(width: Space.sm),
                          ],
                          Text(
                            labelFor != null ? labelFor!(option) : option,
                            style: AppTypography.ui(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? colors.onPrimary
                                  : colors.textPrimary,
                            ),
                          ),
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

/// Generic "coming soon" body for a settings section with no real UI yet.
/// Sync / System / Users / About all use this today; a section should
/// stop passing through here the moment it gets real content (see how
/// `ThemePanel` used to use this before the light/system/dark toggle was
/// built out).
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
