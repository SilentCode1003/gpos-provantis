import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_preview_plus/device_preview_plus.dart';
import 'core/theme/theme.dart';
import 'routing/app_router.dart';

class GposProvantisApp extends ConsumerWidget {
  const GposProvantisApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeControllerProvider);

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

          // Real theme system (see src/core/theme/) — AppTheme builds
          // each ThemeData with its AppColors attached as a
          // ThemeExtension, which is what context.colors reads from
          // (see app_colors_extension.dart). themeMode is the user's
          // saved light/dark/system preference from
          // themeModeControllerProvider (theme_mode_provider.dart);
          // watching it here is what makes MaterialApp actually rebuild
          // when the user changes it.
          theme: AppTheme.light,
          // Reminder to uncomment this later
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
        );
      },
    );
  }
}
