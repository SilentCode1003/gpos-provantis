import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final state = ref.watch(settingsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(
        child: Text('Settings is working', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
