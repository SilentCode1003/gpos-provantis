// Location: src/services/sync/catalog_sync_overlay.dart
//
// Wrap this once near the app root (e.g. inside MaterialApp.builder, or
// around the root Navigator) so it can show on top of ANY screen — not
// just login. It reacts to CatalogSyncController's global state, so
// triggering a sync from login, a manual sync button, or anywhere else
// all surface through this same overlay.
//
// Success is reported via AppToast rather than an overlay banner —
// AppToast already owns "transient, self-dismissing, stacks above
// everything" as a concern (see app_toast.dart), so a sync-succeeded
// message reuses that instead of this widget inventing a second,
// slightly-different version of the same idea. Only the two states that
// need to BLOCK or persist on screen (syncing / failed) are drawn here.
//
// SELF-CONTAINED OVERLAY: this widget hosts its own `Overlay` (see
// `build` below) rather than relying on one already being present above
// it in the tree. Reason: when this widget is wired in via
// `MaterialApp.router`'s `builder` parameter — the documented, intended
// place to put it — `builder` runs OUTSIDE the subtree Navigator/Overlay
// actually construct. `builder`'s `child` argument is the routed app;
// `builder` itself (and anything wrapping `child`, including this
// widget) sits ABOVE that Navigator, not below it. So a BuildContext
// taken from this widget's own `build()` has no Overlay ancestor, and
// AppToast.show(context) — which needs one to insert its OverlayEntry —
// throws "No Overlay widget found." Giving this widget its own local
// Overlay makes AppToast.show work no matter where in the app's tree
// CatalogSyncOverlay ends up wired in, without depending on reaching
// into `child`'s subtree (which may not always be mounted, or may
// change shape independent of this file).
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
    // The Overlay itself needs no rebuild logic of its own — everything
    // reactive lives inside the OverlayEntry's builder below, which
    // Overlay re-invokes whenever the entry is marked dirty (via
    // setState on the entry, or — as here — because the ConsumerWidget
    // inside it rebuilds on provider changes same as any other).
    //
    // Directionality + Material wrap the entry's content because this
    // Overlay sits ABOVE MaterialApp.router in the tree (see the class
    // doc above) — it does NOT inherit either from a Scaffold/Material
    // further down like normal in-app widgets do. Without them, Text
    // widgets here paint as Flutter's debug fallback: red text with a
    // yellow double underline, which is the render-error indicator for
    // "no Directionality/Material ancestor," not a font-loading state.
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

/// Everything that used to live directly in `CatalogSyncOverlay.build`.
/// Split out so its `BuildContext` (used for `AppToast.show`) is one
/// that's actually inside the `OverlayEntry` above — i.e. guaranteed to
/// have this file's own `Overlay` as an ancestor.
class _CatalogSyncOverlayBody extends ConsumerWidget {
  const _CatalogSyncOverlayBody({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(catalogSyncControllerProvider);

    // ref.listen (not ref.watch) for the success toast — this is exactly
    // what it's for: react to a state TRANSITION with a one-off side
    // effect, without that side effect being tied to build() re-running.
    // Riverpod calls this after the frame that changed the state, so
    // there's no need to manually track "previous status" or defer with
    // addPostFrameCallback the way build()-based side effects would.
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

/// Full-screen, non-dismissible barrier shown while catalog sync runs.
/// Blocks interaction with whatever screen is underneath (e.g. the
/// dashboard the user just landed on right after login).
///
/// DESIGN: the underlying screen stays visible — blurred and dimmed,
/// never fully replaced — so this reads as "the app paused for a
/// moment," not a crash/takeover screen. The scrim is a fixed dark,
/// frosted surface (NOT theme-driven): whether the app is in light or
/// dark mode, this overlay always darkens what's behind it to the same
/// degree, the way a native OS permission sheet or camera modal does.
/// That's a deliberate exception to the app's usual context.colors
/// pattern — light mode's own scrim (colors.overlay, ~40% black) isn't
/// dark enough to keep white text/teal rings legible over a bright
/// dashboard, and flipping text color per-mode instead would make the
/// overlay look like two different products depending on theme. A
/// single fixed dark scrim keeps it visually consistent everywhere.
///
/// The ring-bloom animation reuses OrganicPatternBackground's own
/// concentric-circle motif as the loading motion itself, instead of a
/// generic spinner — rings drawing outward in staggered clusters reads
/// as "your catalog is assembling," which ties the loading state back
/// to the same brand texture used elsewhere, rather than a loader that
/// could belong to any app.
class _SyncingBarrier extends StatelessWidget {
  const _SyncingBarrier({required this.stepLog});

  final List<String> stepLog;

  // Fixed regardless of AppColors.light/dark — see class doc.
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

/// Scrolling, terminal/console-style log of every step announced so
/// far — each entry stays on screen (like a chat history or `tail -f`)
/// instead of the old design where a new label replaced the previous
/// one. New lines append at the bottom and the view auto-scrolls to
/// keep the latest entry visible, the way a CLI or chat transcript
/// does.
///
/// [entries] is the raw, unthrottled log from CatalogSyncState —
/// CatalogSyncService fires several `notify` calls back-to-back in the
/// same tick (see its class doc), so entries can arrive several at a
/// time rather than one by one. This widget owns the "reveal one line
/// at a time" pacing itself, purely as a client-side presentation
/// effect — nothing upstream is slowed down to accommodate it, so a
/// fast sync still finishes exactly as fast; this just animates
/// catching up to whatever's already in [entries] once it does.
class _StepLog extends StatefulWidget {
  const _StepLog({required this.entries});

  final List<String> entries;

  @override
  State<_StepLog> createState() => _StepLogState();
}

class _StepLogState extends State<_StepLog> {
  final _scrollController = ScrollController();

  /// How many of widget.entries have been revealed in the log so far.
  /// Ticks up on a short timer rather than jumping straight to
  /// entries.length, so a burst of simultaneous entries still reads as
  /// a sequence of lines being printed rather than all appearing at
  /// once.
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
      // A new sync started and the log was reset.
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

/// Single line in the step log, styled like a console/chat line: a
/// small marker followed by the label. The most recent line is
/// highlighted (full opacity, teal marker) while older lines recede
/// (dimmer, neutral marker) — reads as "this just happened" vs. "this
/// already happened," the way a chat transcript distinguishes the
/// newest message without needing timestamps.
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

/// The loading motion: 5 clusters of concentric rings bloom outward and
/// fade in a staggered, looping sequence — the same "cluster of
/// concentric circles" language as OrganicPatternBackground, used here
/// as active motion instead of static texture. Positions/sizes are
/// fixed (not randomized per the app's brand pattern) since this needs
/// to look identical and intentional every time it appears, not vary
/// like the ambient background pattern does.
///
/// Pure CustomPainter + AnimationController — no new package.
class _RingBloom extends StatefulWidget {
  const _RingBloom();

  @override
  State<_RingBloom> createState() => _RingBloomState();
}

class _RingBloomState extends State<_RingBloom>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _cycleDuration = Duration(milliseconds: 3200);

  // Cluster centers (relative to the 120x120 canvas center) + outer
  // radius + stagger delay (as a fraction of the cycle). Five clusters:
  // one centered, four scattered around it — echoes the "sparse,
  // scattered cluster" composition from OrganicPatternBackground at a
  // small scale.
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

        // Each ring's local animation phase: 0->1 loops, offset by this
        // ring's own delay so clusters/rings bloom in a staggered
        // sequence rather than all pulsing in lockstep.
        final local = ((cyclePosition - ringDelay) % 1.0 + 1.0) % 1.0;

        double growth;
        double opacity;
        if (local < 0.5) {
          // Grow phase: eased outward from nothing to full size,
          // fading in quickly at the start.
          final t = local / 0.5;
          final eased = 1 - math.pow(1 - t, 3).toDouble();
          growth = eased;
          opacity = (t * 3).clamp(0.0, 1.0) * 0.85;
        } else {
          // Fade phase: keeps drifting slightly outward while fading
          // out, like a ripple dissipating.
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

/// Persistent banner shown when sync fails, so the app remains usable
/// (the user already logged in successfully — sync failing shouldn't
/// trap them) while still surfacing the problem clearly until they
/// dismiss it.
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
