// Location: src/core/theme/organic_pattern_background.dart
import 'dart:math';
import 'package:flutter/material.dart';

/// Concentric circle pattern background. Sparse, scattered rings with no overlaps.
/// Seeded randomly, rotates seed every 24 hours. Optimized to skip repaints.
abstract class _PatternSeed {
  static const _rotateAfter = Duration(hours: 24);

  static int? _seed;
  static DateTime? _generatedAt;

  /// Current seed, regenerating past 24h mark as needed.
  static int get current {
    final now = DateTime.now();
    final generatedAt = _generatedAt;
    final isExpired =
        generatedAt == null || now.difference(generatedAt) >= _rotateAfter;

    if (_seed == null || isExpired) {
      _seed = Random().nextInt(1 << 31);
      _generatedAt = now;
    }

    return _seed!;
  }
}

class OrganicPatternBackground extends StatelessWidget {
  const OrganicPatternBackground({
    super.key,
    this.lineColor = Colors.white,
    this.opacity = 0.16,
    this.clusterCount = 14,
    this.child,
  });

  final Color lineColor;

  /// Overall opacity of the pattern. Bumped up from an earlier near-
  /// invisible pass (0.06) to 0.16 by default — still background texture,
  /// but meant to actually read at a glance rather than disappear against
  /// a light surface.
  final double opacity;

  /// Number of concentric-ring circle clusters scattered across the
  /// canvas. Each cluster is one scattered point with 1-4 rings at that
  /// point, sizes randomized per cluster. Kept sparse by default — this
  /// is meant to read as light texture, not a packed/busy pattern.
  final int clusterCount;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ConcentricCirclePainter(
        seed: _PatternSeed.current,
        lineColor: lineColor,
        opacity: opacity,
        clusterCount: clusterCount,
      ),
      child: child,
    );
  }
}

class _ConcentricCirclePainter extends CustomPainter {
  _ConcentricCirclePainter({
    required this.seed,
    required this.lineColor,
    required this.opacity,
    required this.clusterCount,
  });

  final int seed;
  final Color lineColor;
  final double opacity;
  final int clusterCount;

  @override
  void paint(Canvas canvas, Size size) {
    // Seeded with the shared, 24h-rotating seed from `_PatternSeed` — same
    // seed in, same layout out, every time, until the seed itself rotates.
    // This is what stops hover/focus/rebuild churn from visibly reshuffling
    // the pattern: those rebuilds still call `paint()`, but with the same
    // seed they draw the identical circles in the identical spots.
    final random = Random(seed);

    // Track every cluster placed so far (center + outer radius) so each
    // new cluster can be checked against all previous ones before it's
    // committed to the canvas — this is what guarantees no two clusters'
    // circles ever overlap.
    final placed = <_ClusterPlacement>[];
    final margin = size.width * 0.04;

    // Cap on placement attempts per cluster. If the canvas is small or
    // `clusterCount` is high relative to the available area, it may
    // become impossible to find a non-colliding spot — rather than loop
    // forever (or silently overlap), give up on that one cluster and
    // move to the next. A denser pattern than the canvas can fit will
    // simply render sparser than requested, never overlapping.
    const maxAttemptsPerCluster = 40;

    for (var i = 0; i < clusterCount; i++) {
      // Each cluster gets its own outer radius, so clusters read as
      // varying sizes rather than a uniform repeated stamp — a hallmark
      // of a hand-drawn/doodled feel. Radius is picked before placement
      // so collision checks know how much space this cluster needs.
      final outerRadius =
          size.shortestSide * (0.06 + random.nextDouble() * 0.13);

      Offset? center;
      for (var attempt = 0; attempt < maxAttemptsPerCluster; attempt++) {
        final candidate = Offset(
          -margin + random.nextDouble() * (size.width + margin * 2),
          -margin + random.nextDouble() * (size.height + margin * 2),
        );

        final collides = placed.any((other) {
          final minDistance = outerRadius + other.radius;
          return (candidate - other.center).distance < minDistance;
        });

        if (!collides) {
          center = candidate;
          break;
        }
      }

      // No collision-free spot found within the attempt budget — skip
      // this cluster rather than force an overlap.
      if (center == null) continue;

      placed.add(_ClusterPlacement(center, outerRadius));

      final strokeWidth = 1.0 + random.nextDouble() * 1.5;
      // Vary opacity per cluster so the layering reads as depth, not a
      // flat repeated stroke.
      final clusterOpacity = opacity * (0.6 + random.nextDouble() * 0.8);

      final paint = Paint()
        ..color = lineColor.withValues(alpha: clusterOpacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      // 2-4 concentric rings per cluster, evenly spaced from the outer
      // radius down toward the center — the "target/spiral doodle" look.
      final ringCount = 2 + random.nextInt(3);
      for (var r = 0; r < ringCount; r++) {
        final t = ringCount == 1 ? 1.0 : 1.0 - (r / (ringCount - 1)) * 0.75;
        final radius = outerRadius * t;
        if (radius < 1) continue;
        canvas.drawCircle(center, radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_ConcentricCirclePainter oldDelegate) {
    // Standard comparison, same as any static-pattern CustomPainter: skip
    // repainting whenever none of the inputs (including the seed) changed.
    // Since `seed` is stable for 24h, this means hover/focus/rebuild
    // churn no longer triggers a repaint at all — the fix for the pattern
    // reshuffling on every button hover.
    return oldDelegate.seed != seed ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.opacity != opacity ||
        oldDelegate.clusterCount != clusterCount;
  }
}

/// One placed cluster's center + outer radius, kept only for the duration
/// of a single `paint()` call so later clusters can check for collisions
/// against every cluster placed before them.
class _ClusterPlacement {
  const _ClusterPlacement(this.center, this.radius);

  final Offset center;
  final double radius;
}
