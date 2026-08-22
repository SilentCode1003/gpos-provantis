import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:window_manager/window_manager.dart'; // Optional: for desktop window sizing
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // If running on Windows, set the window size to a phone aspect ratio
  if (!kIsWeb && Platform.isWindows) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(450, 850), // The "container" on your PC
      center: true,
      title: "Gpos Provantis - Android Debug Mode",
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(
    ProviderScope(
      child: DevicePreview(
        // Enable preview only in debug mode
        enabled: !kReleaseMode,
        builder: (context) => const GposProvantisApp(),
      ),
    ),
  );
}
