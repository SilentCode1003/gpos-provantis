import 'package:flutter/material.dart';

import '../screens/settings_shared.dart';

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
