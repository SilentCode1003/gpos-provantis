import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import 'package:gpos_provantis/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/screens/dashboard_others_panel.dart';
import 'package:gpos_provantis/src/features/setup/presentation/screens/setup_screen.dart';
import 'package:gpos_provantis/src/features/login/presentation/screens/login_screen.dart';
import 'package:gpos_provantis/src/features/startup/presentation/screens/startup_screen.dart';

/// Builds a page using [CupertinoPage], which gives every route the
/// native iOS-style slide-in/slide-out transition AND, crucially, the
/// native edge-swipe-to-pop gesture for free — dragging from the left
/// edge correctly reveals the actual previous screen underneath in
/// real time, with matching parallax, because Flutter's own routing
/// machinery handles the layering instead of a hand-rolled widget.
///
/// A previous version of this file tried to reproduce this with a
/// custom AnimatedBuilder transition plus a manual drag-detecting
/// wrapper. That approach only animated the current screen away on
/// drag with nothing genuinely rendered underneath it, which showed a
/// black screen mid-swipe. CupertinoPage avoids that entirely.
CupertinoPage<void> _buildPageWithTransition(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CupertinoPage<void>(key: state.pageKey, child: child);
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
      // Dashboard Others Panel
      GoRoute(
        path: '/cash-reports',
        name: AppRoute.cashReports.name,
        pageBuilder: (context, state) =>
            _buildPageWithTransition(context, state, const CashReportsScreen()),
      ),
      GoRoute(
        path: '/receipts',
        name: AppRoute.receipts.name,
        pageBuilder: (context, state) =>
            _buildPageWithTransition(context, state, const ReceiptsScreen()),
      ),
      GoRoute(
        path: '/refunds',
        name: AppRoute.refunds.name,
        pageBuilder: (context, state) =>
            _buildPageWithTransition(context, state, const RefundsScreen()),
      ),
      GoRoute(
        path: '/reports',
        name: AppRoute.reports.name,
        pageBuilder: (context, state) =>
            _buildPageWithTransition(context, state, const ReportsScreen()),
      ),
      GoRoute(
        path: '/reprint',
        name: AppRoute.reprint.name,
        pageBuilder: (context, state) =>
            _buildPageWithTransition(context, state, const ReprintScreen()),
      ),
      GoRoute(
        path: '/send-ereceipt',
        name: AppRoute.sendEreceipt.name,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const SendEreceiptScreen(),
        ),
      ),
      GoRoute(
        path: '/sold-items',
        name: AppRoute.soldItems.name,
        pageBuilder: (context, state) =>
            _buildPageWithTransition(context, state, const SoldItemsScreen()),
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
