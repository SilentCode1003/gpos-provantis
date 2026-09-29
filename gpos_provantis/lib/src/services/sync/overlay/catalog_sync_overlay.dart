import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/shared/widgets/app_toast.dart';
import '../controller/catalog_sync_controller.dart';

class CatalogSyncOverlay extends ConsumerWidget {
  const CatalogSyncOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (overlayContext) => Directionality(
            textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
            child: Material(
              type: MaterialType.transparency,
              child: _CatalogSyncOverlayBody(child: child),
            ),
          ),
        ),
      ],
    );
  }
}

class _CatalogSyncOverlayBody extends ConsumerWidget {
  const _CatalogSyncOverlayBody({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(catalogSyncControllerProvider);

    ref.listen(catalogSyncControllerProvider, (previous, next) {
      if (previous?.status == CatalogSyncStatus.syncing &&
          next.status == CatalogSyncStatus.idle) {
        AppToast.show(
          context,
          message: 'Catalog updated',
          type: AppToastType.success,
        );
      }
    });

    return Stack(
      children: [
        child,
        if (syncState.status == CatalogSyncStatus.syncing)
          _SyncingBarrier(stepLog: syncState.stepLog),
        if (syncState.status == CatalogSyncStatus.failed)
          _SyncFailedBanner(message: syncState.errorMessage ?? 'Sync failed.'),
      ],
    );
  }
}

class _SyncingBarrier extends StatelessWidget {
  const _SyncingBarrier({required this.stepLog});

  final List<String> stepLog;

  static const _scrimColor = Color(0xE60A0D0D); // ~90% AppPalette.neutral1000
  static const _headlineColor = AppPalette.neutral0;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: ColoredBox(
            color: _scrimColor,
            child: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOut,
                builder: (context, value, child) =>
                    Opacity(opacity: value, child: child),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _RingBloom(),
                    const SizedBox(height: 12),
                    Text(
                      'Updating catalog',
                      textAlign: TextAlign.center,
                      style: AppTypography.display(
                        color: _headlineColor,
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 260,
                      height: 132,
                      child: _StepLog(entries: stepLog),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepLog extends StatefulWidget {
  const _StepLog({required this.entries});

  final List<String> entries;

  @override
  State<_StepLog> createState() => _StepLogState();
}

class _StepLogState extends State<_StepLog> {
  final _scrollController = ScrollController();

  int _revealedCount = 0;
  Timer? _revealTimer;

  static const _revealInterval = Duration(milliseconds: 140);

  @override
  void initState() {
    super.initState();
    _scheduleReveal();
  }

  @override
  void didUpdateWidget(_StepLog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.entries.length < oldWidget.entries.length) {
      _revealedCount = 0;
    }
    _scheduleReveal();
  }

  void _scheduleReveal() {
    _revealTimer?.cancel();
    if (_revealedCount >= widget.entries.length) return;
    _revealTimer = Timer.periodic(_revealInterval, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_revealedCount >= widget.entries.length) {
        timer.cancel();
        return;
      }
      setState(() => _revealedCount++);
      _scrollToEnd();
    });
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _revealTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = widget.entries.take(_revealedCount).toList();

    return ShaderMask(
      shaderCallback: (rect) => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Colors.black, Colors.black],
        stops: [0.0, 0.12, 1.0],
      ).createShader(rect),
      blendMode: BlendMode.dstIn,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: visible.length,
        itemBuilder: (context, index) {
          final isLatest = index == visible.length - 1;
          return _StepLogLine(label: visible[index], isLatest: isLatest);
        },
      ),
    );
  }
}

class _StepLogLine extends StatelessWidget {
  const _StepLogLine({required this.label, required this.isLatest});

  final String label;
  final bool isLatest;

  @override
  Widget build(BuildContext context) {
    final textColor = isLatest
        ? const Color(0xFFFFFFFF)
        : const Color(0x99FFFFFF); // white, 60% alpha
    final markerColor = isLatest
        ? AppPalette.teal400
        : const Color(0x66FFFFFF); // white, 40% alpha

    return TweenAnimationBuilder<double>(
      key: ValueKey(label),
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 6 * (1 - value)),
          child: child,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: markerColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.ui(color: textColor, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingBloom extends StatefulWidget {
  const _RingBloom();

  @override
  State<_RingBloom> createState() => _RingBloomState();
}

class _RingBloomState extends State<_RingBloom>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _cycleDuration = Duration(milliseconds: 3200);

  static const _clusters = [
    _ClusterSpec(offset: Offset.zero, outerRadius: 34, delayFraction: 0.0),
    _ClusterSpec(
      offset: Offset(-33, -18),
      outerRadius: 18,
      delayFraction: 0.16,
    ),
    _ClusterSpec(offset: Offset(33, -15), outerRadius: 14, delayFraction: 0.31),
    _ClusterSpec(offset: Offset(-24, 27), outerRadius: 16, delayFraction: 0.47),
    _ClusterSpec(offset: Offset(29, 24), outerRadius: 20, delayFraction: 0.63),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _cycleDuration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _RingBloomPainter(
              cyclePosition: _controller.value,
              clusters: _clusters,
              ringColor: AppPalette.teal400,
            ),
          );
        },
      ),
    );
  }
}

class _ClusterSpec {
  const _ClusterSpec({
    required this.offset,
    required this.outerRadius,
    required this.delayFraction,
  });

  final Offset offset;
  final double outerRadius;
  final double delayFraction;
}

class _RingBloomPainter extends CustomPainter {
  _RingBloomPainter({
    required this.cyclePosition,
    required this.clusters,
    required this.ringColor,
  });

  final double cyclePosition;
  final List<_ClusterSpec> clusters;
  final Color ringColor;

  static const _ringsPerCluster = 3;
  static const _ringStrokeWidth = 1.6;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final cluster in clusters) {
      final clusterCenter = center + cluster.offset;

      for (var r = 0; r < _ringsPerCluster; r++) {
        final tierScale = 1.0 - (r / (_ringsPerCluster - 1)) * 0.7;
        final ringDelay = cluster.delayFraction + (r * 0.15 / 3.2);

        final local = ((cyclePosition - ringDelay) % 1.0 + 1.0) % 1.0;

        double growth;
        double opacity;
        if (local < 0.5) {
          final t = local / 0.5;
          final eased = 1 - math.pow(1 - t, 3).toDouble();
          growth = eased;
          opacity = (t * 3).clamp(0.0, 1.0) * 0.85;
        } else {
          final t = (local - 0.5) / 0.5;
          growth = 1.0 + t * 0.15;
          opacity = 0.85 * (1 - t);
        }

        final radius = math.max(0.5, cluster.outerRadius * tierScale * growth);
        if (opacity <= 0.01) continue;

        final paint = Paint()
          ..color = ringColor.withValues(alpha: opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = _ringStrokeWidth;

        canvas.drawCircle(clusterCenter, radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_RingBloomPainter oldDelegate) {
    return oldDelegate.cyclePosition != cyclePosition ||
        oldDelegate.ringColor != ringColor;
  }
}

class _SyncFailedBanner extends ConsumerWidget {
  const _SyncFailedBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    return Positioned(
      top: MediaQuery.paddingOf(context).top + 12,
      left: 12,
      right: 12,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, -12 * (1 - value)),
            child: child,
          ),
        ),
        child: Material(
          color: colors.dangerContainer,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: colors.onDangerContainer.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.sync_problem_rounded,
                    color: colors.onDangerContainer,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Catalog sync failed',
                        style: AppTypography.ui(
                          color: colors.onDangerContainer,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        message,
                        style: AppTypography.ui(
                          color: colors.onDangerContainer.withValues(
                            alpha: 0.9,
                          ),
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => ref
                      .read(catalogSyncControllerProvider.notifier)
                      .dismissError(),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.close_rounded,
                      color: colors.onDangerContainer,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
