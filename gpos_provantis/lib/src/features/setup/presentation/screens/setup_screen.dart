import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/setup_controller.dart';

class SetupScreen extends ConsumerWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final state = ref.watch(setupControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Setup')),
      body: const Center(
        child: Text('Setup is working', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
