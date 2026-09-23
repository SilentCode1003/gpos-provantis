import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_preview_plus/device_preview_plus.dart';
import 'core/theme/theme.dart';
import 'routing/app_router.dart';
import 'services/sync/overlay/catalog_sync_overlay.dart';
import 'services/sync/controller/sales_sync_controller.dart';

class GposProvantisApp extends ConsumerWidget {
  const GposProvantisApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeControllerProvider);

    // Starts the background sales-upload service for the lifetime of
    // the app — see sales_sync_controller.dart's file doc comment.
    // salesSyncControllerProvider is keepAlive, so simply reading it
    // once here is what makes its build() run (and its internal
    // Timer.periodic start) the first time the app widget tree builds;
    // nothing else about this widget needs the state itself, hence
    // ref.watch with the value unused rather than assigned to a
    // variable — watching (not read) so this stays wired up the same
    // way if the provider is ever invalidated/rebuilt.
    ref.watch(salesSyncControllerProvider);

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

          // These two lines connect Device Preview's state to your app.
          // CatalogSyncOverlay wraps AFTER DevicePreview.appBuilder so it
          // renders above the device-preview frame too — i.e. above
          // every screen, no matter what route is active. It watches
          // CatalogSyncController globally, so any call to
          // CatalogSyncController.runSync(...) — from login, a manual
          // sync button, anywhere — surfaces this same overlay on top of
          // whatever the user is currently looking at.
          locale: DevicePreview.locale(context),
          builder: (context, child) => CatalogSyncOverlay(
            child: DevicePreview.appBuilder(context, child),
          ),

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
