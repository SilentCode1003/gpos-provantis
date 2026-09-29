import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/dashboardWidgets/dashboard_constants.dart';
import '../widgets/dashboardWidgets/dashboard_layout.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final isWide = MediaQuery.sizeOf(context).width >= splitLayoutBreakpoint;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(child: isWide ? const WideLayout() : const NarrowLayout()),
    );
  }
}
