import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import '../screens/settings_shared.dart';

const _themeModeOptions = ['system', 'light', 'dark'];

String _themeModeToOption(ThemeMode mode) => switch (mode) {
  ThemeMode.system => 'system',
  ThemeMode.light => 'light',
  ThemeMode.dark => 'dark',
};

ThemeMode _optionToThemeMode(String option) => switch (option) {
  'light' => ThemeMode.light,
  'dark' => ThemeMode.dark,
  _ => ThemeMode.system,
};

IconData _themeModeIcon(String option) => switch (option) {
  'light' => Icons.light_mode_rounded,
  'dark' => Icons.dark_mode_rounded,
  _ => Icons.brightness_auto_rounded,
};

String _themeModeLabel(String option) => switch (option) {
  'light' => 'Light',
  'dark' => 'Dark',
  _ => 'System',
};

class ThemePanel extends ConsumerWidget {
  const ThemePanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final mode = ref.watch(themeModeControllerProvider);
    final selected = _themeModeToOption(mode);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Space.xxxl,
        Space.xxl,
        Space.xxxl,
        Space.xxxl,
      ),
      children: [
        const PanelHeader(
          title: 'Theme',
          subtitle: 'Choose how the app looks on this device',
        ),
        const SizedBox(height: Space.lg),
        Container(
          padding: const EdgeInsets.all(Space.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.borderSubtle),
            color: colors.surface,
          ),
          child: SegmentedTouchControl(
            options: _themeModeOptions,
            selected: selected,
            iconFor: _themeModeIcon,
            labelFor: _themeModeLabel,
            onSelected: (option) {
              ref
                  .read(themeModeControllerProvider.notifier)
                  .setMode(_optionToThemeMode(option));
            },
          ),
        ),
        const SizedBox(height: Space.md),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.xs),
          child: Text(
            selected == 'system'
                ? "Follows this device's system appearance setting."
                : 'Overrides the system appearance setting on this device.',
            style: AppTypography.ui(fontSize: 13, color: colors.textSecondary),
          ),
        ),
      ],
    );
  }
}
