import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/core/theme/organic_pattern_background.dart';
import '../controllers/startup_controller.dart';

/// =========================================================================
/// STARTUP / SPLASH SCREEN
///
/// The one true "brand moment" in the whole app — shown for a fixed
/// minimum duration on a cold boot while StartupController resolves
/// whether this device has already been configured (see
/// startup_controller.dart). Everything after this screen (login,
/// dashboard, settings) is operational chrome; this is the only place
/// that gets to be quiet and unhurried.
///
/// SIGNATURE ELEMENT: the same concentric-ring motif used as background
/// texture on SetupScreen (see organic_pattern_background.dart) is drawn
/// here as a single foreground ring, animating outward from the wordmark
/// like a signal settling — visually rhyming "this device is finding its
/// configuration" with the literal shape already established elsewhere
/// in the app, rather than reaching for a generic spinner.
/// =========================================================================

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

    // If we were sent here right after a successful Setup save (see
    // SetupScreen._handleSubmit), skip the artificial minimum splash
    // duration — this pass is just re-confirming the domain that was
    // just saved, not a genuine cold boot, so holding the splash for
    // the full duration would just look like a redundant extra screen
    // between Setup and Login.
    final fromSetup =
        GoRouterState.of(context).uri.queryParameters['fromSetup'] == 'true';
    final provider = startupControllerProvider(enforceMinDuration: !fromSetup);

    // ref.listen (not ref.watch alone) so navigation fires exactly once
    // when the destination resolves, rather than on every rebuild of this
    // widget — navigating from inside build() directly can trigger
    // "called during build" errors and can double-fire.
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

/// The still center of the mark: a single filled dot in brand teal. Stays
/// on screen whether or not the ring animation is running, so
/// `reduceMotion` users still get a complete, intentional mark rather
/// than an empty box.
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

/// Draws 3 concentric rings expanding outward from center and fading as
/// they grow, looping continuously — the same "target/doodle" language as
/// OrganicPatternBackground's static clusters, but foregrounded and in
/// motion for the one screen in the app where a brand moment is earned.
///
/// Rings are offset by 1/3 of the cycle from each other so a new ring is
/// always originating as another fades out — reads as a continuous pulse
/// rather than three rings resetting in sync.
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

      // Ease-out: rings move fastest right after originating, then slow
      // as they approach maxRadius — reads as settling, not mechanical.
      final eased = 1 - (1 - t) * (1 - t);
      final radius = eased * maxRadius;

      // Fade in quickly, then fade out over the back half of the cycle,
      // so a ring never just pops into existence or vanishes abruptly.
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
