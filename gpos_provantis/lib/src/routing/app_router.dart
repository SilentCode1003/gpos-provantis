import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';

import 'package:gpos_provantis/src/features/employees/presentation/screens/employees_screen.dart';

// TODO: Import your actual screens from the features folder
// import '../features/authentication/presentation/startup_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  // Later, you can watch an auth state provider here:
  // final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/employees',
    debugLogDiagnostics: true, // Great for seeing route changes in the console
    // The redirect callback is your global route guard.
    // redirect: (context, state) {
    //   if (!authState.isLoggedIn && state.matchedLocation != '/startup') {
    //     return '/startup';
    //   }s
    //   return null;
    // },
    routes: [
      GoRoute(
        path: '/employees',
        name: AppRoute.employees.name,
        builder: (context, state) => const EmployeesScreen(),
      ),
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
    ],
  );
});
