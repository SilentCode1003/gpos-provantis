import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import 'package:gpos_provantis/src/features/settings/presentation/screens/settings_screen.dart';

import 'package:gpos_provantis/src/features/dashboard/presentation/screens/dashboard_screen.dart';

import 'package:gpos_provantis/src/features/setup/presentation/screens/setup_screen.dart';

import 'package:gpos_provantis/src/features/login/presentation/screens/login_screen.dart';

// TODO: Import your actual screens from the features folder
// import '../features/authentication/presentation/startup_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  // Later, you can watch an auth state provider here:
  // final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/setup',
    debugLogDiagnostics: true, // Great for seeing route changes in the console
    // The redirect callback is your global route guard.
    // redirect: (context, state) {
    //   if (!authState.isLoggedIn && state.matchedLocation != '/startup') {
    //     return '/startup';
    //   }s
    //   return null;
    // },
    routes: [
      // GoRoute(
      //   path: '/startup',
      //   name: AppRoute.startup.name,
      //   builder: (context, state) => const StartupScreen(),
      // ),
      // Add more feature routes here as you build them
      // GoRoute(
      //   path: '/home',
      //   name: AppRoute.home.name,
      //   builder: (context, state) => const HomeScreen(),
      // ),
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/setup',
        name: AppRoute.setup.name,
        builder: (context, state) => const SetupScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: AppRoute.dashboard.name,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: AppRoute.settings.name,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
