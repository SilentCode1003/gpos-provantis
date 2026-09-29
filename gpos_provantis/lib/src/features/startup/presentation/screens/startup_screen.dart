import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/core/theme/organic_pattern_background.dart';
import '../controllers/startup_controller.dart';

class StartupScreen extends ConsumerStatefulWidget {
  const StartupScreen({super.key});

  @override
  ConsumerState<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends ConsumerState<StartupScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ringController;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final fromSetup =
        GoRouterState.of(context).uri.queryParameters['fromSetup'] == 'true';
    final provider = startupControllerProvider(enforceMinDuration: !fromSetup);

    ref.listen<AsyncValue<StartupDestination>>(provider, (previous, next) {
      next.whenData((destination) {
        if (!mounted) return;
        switch (destination) {
          case StartupDestination.login:
            context.go('/login');
          case StartupDestination.setup:
            context.go('/setup');
        }
      });
    });

    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: OrganicPatternBackground(
        lineColor: colors.primary,
        opacity: 0.10,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 132,
                height: 132,
                child: reduceMotion
                    ? _StaticMark(colors: colors)
                    : AnimatedBuilder(
                        animation: _ringController,
                        builder: (context, _) {
                          return CustomPaint(
                            painter: _SignalRingPainter(
                              progress: _ringController.value,
                              ringColor: colors.primary,
                            ),
                            child: _StaticMark(colors: colors),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 28),
              Column(
                children: [
                  Text(
                    'GPOS',
                    style: AppTypography.display(
                      letterSpacing: 5,
                      fontSize: 50,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    'Provantis',
                    style: AppTypography.display(
                      letterSpacing: 2,
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Starting up',
                    style: AppTypography.ui(
                      fontSize: 13,
                      color: colors.textSecondary,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StaticMark extends StatelessWidget {
  const _StaticMark({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: colors.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _SignalRingPainter extends CustomPainter {
  _SignalRingPainter({required this.progress, required this.ringColor});

  final double progress;
  final Color ringColor;

  static const _ringCount = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.shortestSide / 2;

    for (var i = 0; i < _ringCount; i++) {
      final offset = i / _ringCount;
      final t = (progress + offset) % 1.0;

      final eased = 1 - (1 - t) * (1 - t);
      final radius = eased * maxRadius;

      final fadeIn = (t / 0.15).clamp(0.0, 1.0);
      final fadeOut = 1 - ((t - 0.4) / 0.6).clamp(0.0, 1.0);
      final opacity = (fadeIn * fadeOut).clamp(0.0, 1.0) * 0.55;

      if (opacity <= 0.01 || radius <= 1) continue;

      final paint = Paint()
        ..color = ringColor.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_SignalRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.ringColor != ringColor;
  }
}
