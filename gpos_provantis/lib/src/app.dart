import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_preview_plus/device_preview_plus.dart';
import 'routing/app_router.dart';

class GposProvantisApp extends ConsumerWidget {
  const GposProvantisApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    // 1. Initialize ScreenUtil for the 2015-2026 Android range
    return ScreenUtilInit(
      designSize: const Size(360, 800), // Our "Golden Standard" base math
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // 2. Return the MaterialApp.router
        return MaterialApp.router(
          title: 'Gpos Provantis',
          debugShowCheckedModeBanner: false,

          // These two lines connect Device Preview's state to your app
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,

          routerConfig: goRouter,

          // Add your theme here later
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
        );
      },
    );
  }
}
