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

    // Background sales-upload service for app lifetime (see sales_sync_controller.dart).
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

          // CatalogSyncOverlay renders above all screens to show sync status.
          locale: DevicePreview.locale(context),
          builder: (context, child) => CatalogSyncOverlay(
            child: DevicePreview.appBuilder(context, child),
          ),

          routerConfig: goRouter,

          // Theme with contextual AppColors extension (see theme/).
          theme: AppTheme.light,
          // Reminder to uncomment this later
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
        );
      },
    );
  }
}
