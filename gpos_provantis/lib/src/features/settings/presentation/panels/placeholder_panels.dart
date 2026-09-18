// Location: src/features/settings/panels/placeholder_panels.dart
import 'package:flutter/material.dart';

import '../screens/settings_shared.dart';

/// =========================================================================
/// PLACEHOLDER PANELS — Sync / System / Users / About. Each is a thin
/// wrapper around the shared `PanelPlaceholder` so the layout stays
/// consistent and there's a single place to update once real content
/// lands in any of them.
///
/// Once a section grows real UI (as Printers and Theme already have),
/// pull it out into its own file in this `panels/` folder rather than
/// growing it here — that's the whole point of the split.
/// =========================================================================

class SyncPanel extends StatelessWidget {
  const SyncPanel();

  @override
  Widget build(BuildContext context) {
    return const PanelPlaceholder(
      icon: Icons.sync_rounded,
      title: 'Sync',
      description:
          'Manage data sync with the back office — connection status, '
          'last sync time, and manual sync controls will live here.',
    );
  }
}

class SystemPanel extends StatelessWidget {
  const SystemPanel();

  @override
  Widget build(BuildContext context) {
    return const PanelPlaceholder(
      icon: Icons.tune_rounded,
      title: 'System',
      description:
          'Device-level settings — receipt footer text, tax rates, '
          'currency, language, and hardware diagnostics.',
    );
  }
}

class UsersPanel extends StatelessWidget {
  const UsersPanel();

  @override
  Widget build(BuildContext context) {
    return const PanelPlaceholder(
      icon: Icons.badge_rounded,
      title: 'Users',
      description:
          'Staff accounts, PIN/login setup, and role permissions '
          '(cashier vs. manager access).',
    );
  }
}

class AboutPanel extends StatelessWidget {
  const AboutPanel();

  @override
  Widget build(BuildContext context) {
    return const PanelPlaceholder(
      icon: Icons.info_outline_rounded,
      title: 'About',
      description:
          'App version, build number, licenses, and support/contact '
          'information.',
    );
  }
}