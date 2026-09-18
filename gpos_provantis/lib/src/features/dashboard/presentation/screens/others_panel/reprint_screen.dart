import 'package:flutter/material.dart';

/// Placeholder screen for Reprint Receipt.
/// Push with: context.push('/reprint');
class ReprintScreen extends StatelessWidget {
  const ReprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reprint Receipt'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Reprint Receipt screen coming soon',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}