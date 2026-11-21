import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/widgets/order_slip_prompt.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import '../widgets/dashboardWidgets/dashboard_constants.dart';
import '../widgets/dashboardWidgets/dashboard_layout.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final isWide = MediaQuery.sizeOf(context).width >= splitLayoutBreakpoint;

    // Read here, above the Scaffold: inside its body the keyboard inset can
    // already be subtracted.
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    // Shows the "Print order slip?" dialog when a finished sale queues one.
    // It lives here (a route, so below the Navigator) because it opens a dialog.
    return OrderSlipPromptHost(
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: isWide
              ? const WideLayout()
              : PhoneLayout(hideCartBar: keyboardOpen),
        ),
      ),
    );
  }
}
