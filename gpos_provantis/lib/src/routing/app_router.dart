import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import 'package:gpos_provantis/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:gpos_provantis/src/features/setup/presentation/screens/setup_screen.dart';
import 'package:gpos_provantis/src/features/login/presentation/screens/login_screen.dart';
import 'package:gpos_provantis/src/features/startup/presentation/screens/startup_screen.dart';

/// Shared page transition for all top-level routes: a restrained fade +
/// subtle scale (0.98 -> 1.0), not a dramatic zoom-from-center. Cheap to
/// paint (no blur) — fits this app's low-spec POS hardware target (see
/// login_screen.dart's performance notes).
CustomTransitionPage<void> _buildPageWithTransition(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.98, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/startup',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/startup',
        name: AppRoute.startup.name,
        pageBuilder: (context, state) =>
            _buildPageWithTransition(context, state, const StartupScreen()),
      ),
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        pageBuilder: (context, state) =>
            _buildPageWithTransition(context, state, const LoginScreen()),
      ),
      GoRoute(
        path: '/setup',
        name: AppRoute.setup.name,
        pageBuilder: (context, state) =>
            _buildPageWithTransition(context, state, const SetupScreen()),
      ),
      GoRoute(
        path: '/dashboard',
        name: AppRoute.dashboard.name,
        pageBuilder: (context, state) =>
            _buildPageWithTransition(context, state, const DashboardScreen()),
      ),
      GoRoute(
        path: '/settings',
        name: AppRoute.settings.name,
        pageBuilder: (context, state) =>
            _buildPageWithTransition(context, state, const SettingsScreen()),
      ),
    ],
  );
});
