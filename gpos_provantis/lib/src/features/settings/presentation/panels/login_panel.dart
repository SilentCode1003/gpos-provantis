import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/database/providers/settings_dao_provider.dart';
import 'package:gpos_provantis/src/core/security/remembered_login_service.dart';
import '../screens/settings_cards.dart';
import '../screens/settings_shared.dart';

class LoginPanel extends ConsumerWidget {
  const LoginPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remember = ref.watch(rememberLastLoginProvider);

    // A ListView (not a SingleChildScrollView around a Column): the settings
    // screen puts panels inside an AnimatedSwitcher, which centers anything
    // that doesn't fill the space. A ListView fills it, so the content starts
    // at the top and still scrolls when it is taller than the screen.
    return ListView(
      padding: settingsPanelPadding(context),
      children: [
        const PanelHeader(
          title: 'Login',
          subtitle: 'How the sign-in screen behaves on this device.',
        ),
        const SizedBox(height: Space.xxl),
        SettingsToggleCard(
          title: 'Remember last login',
          description:
              'Fill in the username and password of the last person who '
              'signed in, so they only need to tap Sign in. The password is '
              'kept in this device\'s secure storage. Turn this off on '
              'shared devices; doing so also removes the saved login.',
          value: remember,
          onChanged: (value) {
            ref.read(rememberedLoginServiceProvider).setEnabled(value);
          },
        ),
      ],
    );
  }
}
