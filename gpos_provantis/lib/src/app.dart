import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_preview_plus/device_preview_plus.dart';
import 'core/theme/theme.dart';
import 'routing/app_router.dart';
import 'services/sync/overlay/catalog_sync_overlay.dart';
import 'services/sync/controller/sales_sync_controller.dart';
import 'services/check_health_service.dart';

class GposProvantisApp extends ConsumerWidget {
  const GposProvantisApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeControllerProvider);

    ref.watch(salesSyncControllerProvider);
    // Starts the 10s health-check poll loop as soon as the app boots, same
    // as the sales sync watcher above. See ServerHealthController for why
    // this is foreground-only and keepAlive.
    ref.watch(serverHealthControllerProvider);

    return ScreenUtilInit(
      designSize: const Size(360, 800), // Our "Golden Standard" base math
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Gpos Provantis',
          debugShowCheckedModeBanner: false,

          locale: DevicePreview.locale(context),
          builder: (context, child) => CatalogSyncOverlay(
            child: DevicePreview.appBuilder(context, child),
          ),

          routerConfig: goRouter,

          theme: AppTheme.light,

          darkTheme: AppTheme.dark,
          themeMode: themeMode,
        );
      },
    );
  }
}
