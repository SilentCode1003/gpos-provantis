// Location: src/features/auth/screens/login_screen.dart
//
// Requires `google_fonts` in pubspec.yaml (used indirectly via
// AppTypography in core/theme) — add it if it isn't there yet.
// Check https://pub.dev/packages/google_fonts for the current version:
//   dependencies:
//     google_fonts: ^<latest>
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/core/theme/organic_pattern_background.dart';
import 'package:gpos_provantis/src/shared/widgets/confirm_dialog.dart';
import 'package:gpos_provantis/src/services/sync/initial_sync.dart';
import 'package:gpos_provantis/src/core/database/providers/branch_config_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_config_dao_provider.dart';
import 'package:gpos_provantis/src/shared/widgets/app_toast.dart';
import '../controllers/login_controller.dart';

/// =========================================================================
/// LOGIN SCREEN — flat, lightweight, V1-teal split layout.
///
/// PERFORMANCE NOTE: this app targets low-spec touchscreen POS hardware.
/// Deliberately avoided here: BackdropFilter/blur, gradients-as-decoration,
/// glow shadows, and any per-frame animation. Everything is a flat fill —
/// cheap to paint and cheap to repaint on every keystroke/focus change.
/// If a design later calls for something heavier, that's a conscious
/// per-widget trade-off, not a default.
///
/// THEME-AWARE: every widget below reads `context.colors` (see
/// `app_colors_extension.dart`) rather than a hardcoded `AppColors.light`
/// constant, so the screen follows the user's light/dark preference
/// (`themeModeControllerProvider`) like the rest of the app. The brand
/// panel's teal fill (`AppPalette.teal500`) is intentionally NOT
/// theme-aware — it's the fixed brand color in both modes — but text/icons
/// drawn on top of it still resolve via `context.colors.onPrimary` since
/// that role is itself defined per-mode (see `app_colors.dart`).
///
/// Layout: 3:5 split (≈37.5/62.5, close to golden ratio) — brand panel on
/// the left, form on the right. Collapses to a stacked layout below the
/// breakpoint for phone-sized/portrait screens.
/// =========================================================================

const double _splitLayoutBreakpoint = 720;

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWide = MediaQuery.sizeOf(context).width >= _splitLayoutBreakpoint;
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: isWide ? const _WideLayout() : const _NarrowLayout(),
      ),
    );
  }
}

/// --- Wide: side-by-side brand panel + form --------------------------------

class _WideLayout extends StatelessWidget {
  const _WideLayout();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        const Expanded(flex: 3, child: _BrandPanel()),
        Expanded(
          flex: 5,
          child: OrganicPatternBackground(
            lineColor: colors.textPrimary,
            opacity: 0.05,
            child: const Stack(
              children: [
                Center(child: _LoginForm()),
                Positioned(top: 20, left: 20, child: _SetupButton()),
                Positioned(top: 20, right: 20, child: _SyncButton()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// --- Narrow: compact brand band + form below ------------------------------

class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      children: [
        Column(
          children: [
            const _BrandBand(),
            Expanded(
              child: OrganicPatternBackground(
                lineColor: colors.textPrimary,
                opacity: 0.05,
                child: const Center(child: _LoginForm()),
              ),
            ),
          ],
        ),
        const Positioned(top: 12, left: 12, child: _SetupButton()),
        const Positioned(top: 12, right: 12, child: _SyncButton()),
      ],
    );
  }
}

/// --- Brand panel — flat V1 teal, placeholder for a future image ---------
///
/// The teal fill itself stays fixed brand color in both light and dark
/// mode (a POS brand panel isn't expected to go "dark mode teal") — only
/// the text/icon color drawn on top resolves through `context.colors`,
/// since `onPrimary` is itself defined differently per mode in
/// `app_colors.dart` (near-white on light, near-black on dark) to keep
/// contrast correct against the teal.

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Flat fill only — no gradient. Swap this Container's `color` for a
    // full-bleed Image widget later when the picture is ready; layout
    // and text below are already positioned to sit on top of it.
    return Container(
      color: AppPalette.teal500,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LogoMark(color: colors.onPrimary),
              const SizedBox(height: 20),
              Text(
                'GPOS PROVANTIS',
                style: AppTypography.display(
                  color: colors.onPrimary,
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Point of sale, simplified.',
                style: AppTypography.ui(
                  color: colors.onPrimary.withValues(alpha: 0.85),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// --- Compact brand band (narrow layout) -----------------------------------

class _BrandBand extends StatelessWidget {
  const _BrandBand();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      color: AppPalette.teal500,
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LogoMark(color: colors.onPrimary, size: 44),
          const SizedBox(height: 10),
          Text(
            'GPOS PROVANTIS',
            style: AppTypography.display(
              color: colors.onPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple flat logo mark — no shadow/glow (cheap to paint). Swap for a real
/// asset (Image.asset) once branding exists.
class _LogoMark extends StatelessWidget {
  const _LogoMark({required this.color, this.size = 60});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(Icons.point_of_sale_rounded, color: color, size: size * 0.5),
    );
  }
}

/// --- The form ------------------------------------------------------------

class _LoginForm extends ConsumerStatefulWidget {
  const _LoginForm();

  @override
  ConsumerState<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<_LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final ok = await ref.read(loginControllerProvider.notifier).submit();
    if (ok && mounted) {
      context.go('/dashboard');
      AppToast.show(
        context,
        message: 'Login successful!',
        type: AppToastType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);
    final colors = context.colors;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 380),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back',
              style: AppTypography.display(
                color: colors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Sign in to continue',
              style: AppTypography.ui(
                color: colors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),

            _FlatField(
              label: 'Username',
              controller: _usernameController,
              icon: Icons.person_outline_rounded,
              hint: 'admin',
              onChanged: ref
                  .read(loginControllerProvider.notifier)
                  .usernameChanged,
            ),
            const SizedBox(height: 16),
            _FlatField(
              label: 'Password',
              controller: _passwordController,
              icon: Icons.lock_outline_rounded,
              hint: 'admin',
              obscure: state.obscurePassword,
              onChanged: ref
                  .read(loginControllerProvider.notifier)
                  .passwordChanged,
              onSubmitted: (_) => _handleSubmit(),
              trailing: IconButton(
                icon: Icon(
                  state.obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: colors.textSecondary,
                  size: 20,
                ),
                onPressed: ref
                    .read(loginControllerProvider.notifier)
                    .togglePasswordVisibility,
              ),
            ),

            if (state.errorMessage != null) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: colors.dangerContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: colors.onDangerContainer,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.errorMessage!,
                        style: AppTypography.ui(
                          color: colors.onDangerContainer,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 28),
            _SignInButton(
              isLoading: state.isSubmitting,
              onPressed: _handleSubmit,
            ),

            const SizedBox(height: 16),
            Center(
              child: Text(
                'admin / admin — placeholder credentials',
                style: AppTypography.ui(
                  color: colors.textDisabled,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// --- Flat input field — solid fill, no blur/animation --------------------

class _FlatField extends StatelessWidget {
  const _FlatField({
    required this.label,
    required this.controller,
    required this.icon,
    required this.hint,
    required this.onChanged,
    this.onSubmitted,
    this.obscure = false,
    this.trailing,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool obscure;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.ui(
            color: colors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          style: AppTypography.ui(color: colors.textPrimary, fontSize: 15),
          cursorColor: AppPalette.teal500,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.ui(color: colors.textDisabled),
            prefixIcon: Icon(icon, color: colors.textSecondary, size: 20),
            suffixIcon: trailing,
            filled: true,
            fillColor: colors.surfaceVariant,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppPalette.teal500, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

/// --- Sign in button — flat fill, no gradient/shadow ------------------

class _SignInButton extends StatelessWidget {
  const _SignInButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.teal500,
          foregroundColor: colors.onPrimary,
          disabledBackgroundColor: AppPalette.teal300,
          disabledForegroundColor: colors.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: colors.onPrimary,
                ),
              )
            : Text(
                'Sign in',
                style: AppTypography.ui(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

/// --- Setup / Sync — flat icon buttons -----------------------------------

class _SetupButton extends StatelessWidget {
  const _SetupButton();

  @override
  Widget build(BuildContext context) {
    return _FlatIconButton(
      icon: Icons.dns_outlined,
      tooltip: 'Setup',
      onPressed: () => _confirmReturnToSetup(context),
    );
  }
}

/// Leaving login for /setup mid-session is disruptive — it interrupts
/// whoever's signing in and re-opens the domain/branch/POS config. A
/// stray tap on a touchscreen POS shouldn't be able to trigger that, so
/// this requires a deliberate second confirmation before navigating.
Future<void> _confirmReturnToSetup(BuildContext context) async {
  final confirmed = await showConfirmDialog(
    context,
    eyebrow: 'RETURN TO SETUP',
    title: 'Leave login for domain setup?',
    body:
        'This reopens domain, branch, and POS configuration. Anyone '
        'signing in on this device will need to wait until setup is '
        'finished again.',
    confirmLabel: 'PROCEED',
  );

  if (confirmed == true && context.mounted) {
    context.go('/setup');
  }
}

/// Re-runs [InitialSyncService] using the branchId/posId already saved
/// locally during setup (there's no form on this screen to type them in —
/// they come from BranchConfigDao/PosConfigDao). Guards against double-taps
/// with [_isSyncing] since a stray tap on a touchscreen POS could otherwise
/// fire two syncs; the second would just hit InitialSyncService's own
/// duplicate-request no-op, but disabling here avoids the wasted request.
class _SyncButton extends ConsumerStatefulWidget {
  const _SyncButton();

  @override
  ConsumerState<_SyncButton> createState() => _SyncButtonState();
}

class _SyncButtonState extends ConsumerState<_SyncButton> {
  bool _isSyncing = false;

  Future<void> _handleSync() async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);

    try {
      final branch = await ref.read(branchConfigDaoProvider).getBranch();
      final pos = await ref.read(posConfigDaoProvider).getPos();

      if (branch == null || pos == null) {
        if (mounted) {
          AppToast.show(
            context,
            message:
                'No branch/POS config found on this device. Run setup first.',
            type: AppToastType.error,
          );
        }
        return;
      }

      final result = await ref
          .read(initialSyncServiceProvider)
          .run(branchId: branch.branchId, posId: pos.posId.toString());

      if (!mounted) return;

      if (result.success) {
        AppToast.show(
          context,
          message: 'Sync completed successfully.',
          type: AppToastType.success,
        );
      } else if (result.errorMessage != null) {
        // A real failure (network, missing/empty server response, etc).
        AppToast.show(
          context,
          message: 'Failed to sync: ${result.errorMessage}',
          type: AppToastType.error,
        );
      }
      // errorMessage == null with success == false means a duplicate
      // request was blocked — the original sync is still in flight, so
      // stay silent rather than showing a misleading error or success toast.
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FlatIconButton(
      icon: Icons.sync_rounded,
      tooltip: 'Sync',
      isLoading: _isSyncing,
      onPressed: _handleSync,
    );
  }
}

/// Flat circular icon button — solid fill, no shadow/blur/animation.
/// Shared so Setup/Sync stay visually identical.
class _FlatIconButton extends StatelessWidget {
  const _FlatIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.isLoading = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: colors.surfaceVariant,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: isLoading ? null : onPressed,
          child: SizedBox(
            width: 40,
            height: 40,
            child: isLoading
                ? Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.textSecondary,
                      ),
                    ),
                  )
                : Icon(icon, size: 18, color: colors.textSecondary),
          ),
        ),
      ),
    );
  }
}
