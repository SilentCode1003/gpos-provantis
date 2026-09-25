import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/core/database/providers/branch_config_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_detail_id_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_shift_dao_provider.dart';
import 'package:gpos_provantis/src/shared/widgets/confirm_dialog.dart';
import 'package:gpos_provantis/src/services/check_health_service.dart';

const double _topBarHeight = 100;

class TopBar extends ConsumerWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final branchName = _watchBranchName(ref);
    final detailID = _watchDetailID(ref);
    final shiftID = _watchShiftID(ref);

    return Container(
      width: double.infinity,
      height: _topBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _StatusItem(label: 'Branch', value: branchName),
                  _StatusDivider(),
                  const _ClockStatusItem(),
                  _StatusDivider(),

                  _StatusItem(label: 'Shift', value: shiftID),
                  _StatusDivider(),
                  _StatusItem(label: 'OR number', value: detailID),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          const _ProfileMenu(),
        ],
      ),
    );
  }
}

String _watchBranchName(WidgetRef ref) {
  final asyncConfig = ref.watch(branchConfigProvider);
  return asyncConfig.when(
    data: (config) {
      final name = config?.branchName.trim() ?? '';
      return name.isNotEmpty ? name : '—';
    },
    error: (_, __) => '—',
    loading: () => '—',
  );
}

String _watchDetailID(WidgetRef ref) {
  final detailIdConfig = ref.watch(posDetailIdProvider);
  return detailIdConfig.when(
    data: (config) {
      final detailID = config?.posDetailId.trim() ?? '';
      return detailID.isNotEmpty ? detailID : '-';
    },
    error: (_, _) => '-',
    loading: () => '-',
  );
}

/// Maps the server health status to the avatar border color: gray while the
/// first check hasn't resolved yet, green when reachable, red when not.
/// Uses the theme's own success/danger/textDisabled tokens so this tracks
/// light/dark mode automatically instead of a hardcoded hex.
Color _healthBorderColor(AppColors colors, ServerHealthStatus status) {
  switch (status) {
    case ServerHealthStatus.checking:
      return colors.textDisabled;
    case ServerHealthStatus.online:
      return colors.success;
    case ServerHealthStatus.offline:
      return colors.danger;
  }
}

String _watchShiftID(WidgetRef ref) {
  final shiftIDConfig = ref.watch(posShiftProvider);
  return shiftIDConfig.when(
    data: (config) {
      if (config.isEmpty) return '-';
      final shiftID = config.first.shift.trim();
      return shiftID.isNotEmpty ? shiftID : '-';
    },
    error: (_, _) => '-',
    loading: () => '-',
  );
}

class _StatusDivider extends StatelessWidget {
  const _StatusDivider();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 18),
      color: colors.borderSubtle,
    );
  }
}

class _StatusItem extends StatelessWidget {
  const _StatusItem({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppTypography.ui(
            color: colors.textDisabled,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.ui(
            color: valueColor ?? colors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ClockStatusItem extends StatefulWidget {
  const _ClockStatusItem();

  @override
  State<_ClockStatusItem> createState() => _ClockStatusItemState();
}

class _ClockStatusItemState extends State<_ClockStatusItem> {
  late DateTime _now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();

    final msToNextMinute =
        Duration(minutes: 1) -
        Duration(seconds: _now.second, milliseconds: _now.millisecond);
    Timer(msToNextMinute, _tick);
  }

  void _tick() {
    if (!mounted) return;
    setState(() => _now = DateTime.now());
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formatted {
    final hour24 = _now.hour;
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final minute = _now.minute.toString().padLeft(2, '0');
    final period = hour24 < 12 ? 'AM' : 'PM';
    return '$hour12:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return _StatusItem(label: 'Time', value: _formatted);
  }
}

enum _ProfileMenuAction { settings, refreshHealth, logout }

const double _topBarTapTarget = 72;

// Widened from 208 — 'Refresh connection' was clipping/overflowing at the
// old width.
const double _profileMenuWidth = 240;
// 120 fit exactly 2 rows (Settings, Logout); bumped to fit the new
// "Refresh connection" row at the same per-row height.
const double _profileMenuHeight = 176;

const Duration _profileMenuMorphDuration = Duration(milliseconds: 260);

class _ProfileMenu extends ConsumerStatefulWidget {
  const _ProfileMenu();

  @override
  ConsumerState<_ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends ConsumerState<_ProfileMenu>
    with SingleTickerProviderStateMixin {
  final _layerLink = LayerLink();
  late final AnimationController _controller;
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _profileMenuMorphDuration,
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSelection(_ProfileMenuAction action) async {
    await _close();
    if (!mounted) return;
    switch (action) {
      case _ProfileMenuAction.settings:
        context.push('/settings');

      case _ProfileMenuAction.refreshHealth:
        // Fire-and-forget, same as the sync tile in OthersSheet — the
        // avatar border already watches serverHealthControllerProvider, so
        // it updates on its own once this resolves. Nothing more to await
        // or display here.
        ref.read(serverHealthControllerProvider.notifier).refresh();

      case _ProfileMenuAction.logout:
        final confirmed = await showConfirmDialog(
          context,
          title: 'Logout?',
          body: 'You\u2019ll need to sign back in to continue using the till.',
          confirmLabel: 'LOGOUT',
        );
        if (confirmed == true && context.mounted) {
          context.go('/login');
        }
    }
  }

  void _toggle() {
    if (_isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    if (_isOpen) return;
    _isOpen = true;
    _overlayEntry = OverlayEntry(
      builder: (context) => _ProfileMenuOverlay(
        layerLink: _layerLink,
        controller: _controller,
        onSelected: _handleSelection,
        onDismiss: _close,
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();
  }

  Future<void> _close() async {
    if (!_isOpen) return;
    _isOpen = false;
    await _controller.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final healthStatus = ref.watch(serverHealthControllerProvider);
    final borderColor = _healthBorderColor(colors, healthStatus);

    return CompositedTransformTarget(
      link: _layerLink,

      child: GestureDetector(
        onTap: _toggle,
        child: Container(
          width: _topBarTapTarget,
          height: _topBarTapTarget,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.surfaceVariant,

            border: Border.all(color: borderColor, width: 3.5),
          ),
          alignment: Alignment.center,

          child: const ClipOval(child: _BranchLogo()),
        ),
      ),
    );
  }
}

class _ProfileMenuOverlay extends ConsumerWidget {
  const _ProfileMenuOverlay({
    required this.layerLink,
    required this.controller,
    required this.onSelected,
    required this.onDismiss,
  });

  final LayerLink layerLink;
  final AnimationController controller;
  final ValueChanged<_ProfileMenuAction> onSelected;
  final VoidCallback onDismiss;

  static const _avatarFadeOutEnd = 0.35;
  static const _menuFadeInStart = 0.55;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final healthStatus = ref.watch(serverHealthControllerProvider);
    final borderColor = _healthBorderColor(colors, healthStatus);

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onDismiss,
          ),
        ),
        CompositedTransformFollower(
          link: layerLink,

          targetAnchor: Alignment.topRight,
          followerAnchor: Alignment.topRight,
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              final clampedT = _panelProgress(controller);

              final width = _lerp(
                _topBarTapTarget,
                _profileMenuWidth,
                clampedT,
              );
              final height = _lerp(
                _topBarTapTarget,
                _profileMenuHeight,
                clampedT,
              );

              final radius = _lerp(_topBarTapTarget / 2, 20, clampedT);
              final borderWidth = _lerp(3.5, 0, clampedT);

              return Container(
                width: width,
                height: height,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Color.lerp(
                    colors.surfaceVariant,
                    colors.surfaceRaised,
                    clampedT,
                  ),
                  borderRadius: BorderRadius.circular(radius),
                  border: borderWidth > 0.01
                      ? Border.all(color: borderColor, width: borderWidth)
                      : null,
                ),
                child: child,
              );
            },
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                final clampedT = _panelProgress(controller);
                final width = _lerp(
                  _topBarTapTarget,
                  _profileMenuWidth,
                  clampedT,
                );

                final avatarOpacity = (1 - controller.value / _avatarFadeOutEnd)
                    .clamp(0.0, 1.0);
                final menuT =
                    ((controller.value - _menuFadeInStart) /
                            (1 - _menuFadeInStart))
                        .clamp(0.0, 1.0);

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    if (avatarOpacity > 0)
                      Opacity(
                        opacity: avatarOpacity,
                        child: const ClipOval(child: _BranchLogo()),
                      ),

                    if (menuT > 0)
                      Opacity(
                        opacity: menuT,
                        child: Transform.scale(
                          scale: (width / _profileMenuWidth).clamp(0.0, 1.0),
                          child: OverflowBox(
                            minWidth: _profileMenuWidth,
                            maxWidth: _profileMenuWidth,
                            minHeight: _profileMenuHeight,
                            maxHeight: _profileMenuHeight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 6,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _ProfileMenuRow(
                                    icon: Icons.settings_outlined,
                                    label: 'Settings',
                                    onTap: () =>
                                        onSelected(_ProfileMenuAction.settings),
                                  ),
                                  _ProfileMenuRow(
                                    icon: Icons.refresh_rounded,
                                    label: 'Refresh connection',
                                    onTap: () => onSelected(
                                      _ProfileMenuAction.refreshHealth,
                                    ),
                                  ),
                                  _ProfileMenuRow(
                                    icon: Icons.logout_rounded,
                                    label: 'Logout',
                                    destructive: true,
                                    onTap: () =>
                                        onSelected(_ProfileMenuAction.logout),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  static double _panelProgress(AnimationController controller) {
    final isClosing = controller.status == AnimationStatus.reverse;
    final t = isClosing
        ? Curves.easeInCubic.transform(controller.value)
        : Curves.easeOutBack.transform(controller.value);
    return t.clamp(0.0, 1.0);
  }
}

class _BranchLogo extends ConsumerWidget {
  const _BranchLogo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncConfig = ref.watch(branchConfigProvider);
    final rawLogo = asyncConfig.when(
      data: (config) => config?.logo.trim() ?? '',
      error: (_, __) => '',
      loading: () => '',
    );

    final decoded = _decodeLogoBytes(rawLogo);
    if (decoded == null) {
      return const _BranchLogoFallback();
    }

    switch (decoded.format) {
      case _LogoFormat.svg:
        return SvgPicture.memory(
          decoded.bytes,
          width: _topBarTapTarget,
          height: _topBarTapTarget,
          fit: BoxFit.cover,

          placeholderBuilder: (context) => const _BranchLogoFallback(),
          errorBuilder: (context, error, stackTrace) =>
              const _BranchLogoFallback(),
        );
      case _LogoFormat.raster:
        return Image.memory(
          decoded.bytes,
          width: _topBarTapTarget,
          height: _topBarTapTarget,
          fit: BoxFit.cover,

          errorBuilder: (context, error, stackTrace) =>
              const _BranchLogoFallback(),
        );
    }
  }
}

enum _LogoFormat { svg, raster }

class _DecodedLogo {
  const _DecodedLogo(this.bytes, this.format);

  final Uint8List bytes;
  final _LogoFormat format;
}

_DecodedLogo? _decodeLogoBytes(String raw) {
  if (raw.isEmpty) return null;

  final commaIndex = raw.indexOf(',');
  final looksLikeDataUri = raw.startsWith('data:') && commaIndex != -1;
  final payload = looksLikeDataUri ? raw.substring(commaIndex + 1) : raw;

  if (payload.isEmpty) return null;

  try {
    final bytes = base64.decode(base64.normalize(payload));
    return _DecodedLogo(bytes, _sniffLogoFormat(bytes));
  } on FormatException {
    return null;
  }
}

_LogoFormat _sniffLogoFormat(Uint8List bytes) {
  if (bytes.isEmpty) return _LogoFormat.raster;

  final sampleLength = bytes.length < 200 ? bytes.length : 200;
  final sample = bytes.sublist(0, sampleLength);

  try {
    final text = utf8.decode(sample, allowMalformed: false).trimLeft();

    final withoutBom = text.startsWith('\uFEFF') ? text.substring(1) : text;
    final lower = withoutBom.trimLeft().toLowerCase();
    if (lower.startsWith('<?xml') || lower.startsWith('<svg')) {
      return _LogoFormat.svg;
    }
  } on FormatException {}

  return _LogoFormat.raster;
}

class _BranchLogoFallback extends StatelessWidget {
  const _BranchLogoFallback();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.person_rounded,
      size: 34,
      color: AppPalette.neutral0,
    );
  }
}

class _ProfileMenuRow extends StatelessWidget {
  const _ProfileMenuRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = destructive ? colors.danger : colors.textPrimary;

    final iconBackdrop = destructive
        ? colors.danger.withOpacity(0.12)
        : colors.textPrimary.withOpacity(0.06);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconBackdrop,
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: AppTypography.ui(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
