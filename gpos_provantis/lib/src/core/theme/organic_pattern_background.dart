import 'dart:math';
import 'package:flutter/material.dart';

abstract class _PatternSeed {
  static const _rotateAfter = Duration(hours: 24);

  static int? _seed;
  static DateTime? _generatedAt;

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

  final double opacity;

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
    final random = Random(seed);

    final placed = <_ClusterPlacement>[];
    final margin = size.width * 0.04;

    const maxAttemptsPerCluster = 40;

    for (var i = 0; i < clusterCount; i++) {
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

      if (center == null) continue;

      placed.add(_ClusterPlacement(center, outerRadius));

      final strokeWidth = 1.0 + random.nextDouble() * 1.5;

      final clusterOpacity = opacity * (0.6 + random.nextDouble() * 0.8);

      final paint = Paint()
        ..color = lineColor.withValues(alpha: clusterOpacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

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
    return oldDelegate.seed != seed ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.opacity != opacity ||
        oldDelegate.clusterCount != clusterCount;
  }
}

class _ClusterPlacement {
  const _ClusterPlacement(this.center, this.radius);

  final Offset center;
  final double radius;
}
