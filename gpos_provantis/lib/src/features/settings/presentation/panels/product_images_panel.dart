import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/database/domain/settings_dto.dart';
import 'package:gpos_provantis/src/core/database/providers/settings_dao_provider.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/settings/presentation/controllers/product_images_controller.dart';
import 'package:gpos_provantis/src/shared/widgets/confirm_dialog.dart';
import '../screens/settings_shared.dart';

/// Largest schedule the custom box accepts (10 years).
const _maxRefetchDays = 3650;

const _presets = <(int, String)>[
  (0, 'Off'),
  (1, 'Every day'),
  (7, 'Every 7 days'),
  (30, 'Every 30 days'),
  (365, 'Every 365 days'),
];

class ProductImagesPanel extends ConsumerStatefulWidget {
  const ProductImagesPanel({super.key});

  @override
  ConsumerState<ProductImagesPanel> createState() => _ProductImagesPanelState();
}

class _ProductImagesPanelState extends ConsumerState<ProductImagesPanel> {
  final _daysController = TextEditingController();
  String? _daysError;

  @override
  void dispose() {
    _daysController.dispose();
    super.dispose();
  }

  void _setDays(int days) {
    FocusScope.of(context).unfocus();
    setState(() => _daysError = null);
    _daysController.clear();
    ref.read(productImagesJobProvider.notifier).setRefetchDays(days);
  }

  void _applyCustomDays() {
    final days = int.tryParse(_daysController.text.trim());
    if (days == null || days < 1 || days > _maxRefetchDays) {
      setState(() => _daysError = 'Enter a number from 1 to $_maxRefetchDays.');
      return;
    }
    _setDays(days);
  }

  Future<void> _onDeleteAndRefetch() async {
    final confirmed = await showConfirmDialog(
      context,
      eyebrow: 'DELETE AND DOWNLOAD AGAIN',
      title: 'Delete all product images?',
      body:
          'Every picture saved on this device will be deleted, then all of '
          'them are downloaded again from the server. Products show without '
          'pictures until each one has been downloaded again. You can keep '
          'using the till meanwhile. Needs a connection to the server.',
      confirmLabel: 'Delete and download',
    );
    if (confirmed != true || !mounted) return;
    await ref.read(productImagesJobProvider.notifier).deleteAndRefetch();
  }

  Future<void> _onDeleteAndStop() async {
    final confirmed = await showConfirmDialog(
      context,
      eyebrow: 'DELETE AND STOP DOWNLOADING',
      title: 'Delete images and stop downloads?',
      body:
          'Every picture saved on this device will be deleted and automatic '
          'downloading will be turned off, so the pictures do not come back. '
          'To get them back later, turn on "Automatic download" again.',
      confirmLabel: 'Delete and stop',
    );
    if (confirmed != true || !mounted) return;
    await ref.read(productImagesJobProvider.notifier).deleteAndStop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final settings =
        ref.watch(productImageSettingsProvider).value ??
        const ProductImageSettings();
    final job = ref.watch(productImagesJobProvider);
    final controller = ref.read(productImagesJobProvider.notifier);
    final busy = job.busy;

    return ListView(
      padding: settingsPanelPadding(context),
      children: [
        const PanelHeader(
          title: 'Product Images',
          subtitle: 'Choose how product pictures are shown and downloaded',
        ),
        const SizedBox(height: Space.lg),

        if (busy) ...[
          _ProgressCard(job: job),
          const SizedBox(height: Space.md),
        ],

        _ToggleCard(
          title: 'Show product images',
          description:
              'Shows the pictures on the product list. Turn off to go back to '
              'the compact cards without pictures. The pictures stay on this '
              'device and nothing is deleted, so turning it back on is '
              'instant.',
          value: settings.show,
          onChanged: controller.setShowImages,
        ),
        const SizedBox(height: Space.md),

        _ToggleCard(
          title: 'Automatic download',
          description:
              'After each catalog sync, downloads the pictures of any product '
              'that does not have one yet, in the background, one at a time. '
              'Turn off to stop downloading: pictures already on this device '
              'are kept and still shown. "Delete and download again" below '
              'still works.',
          value: settings.autoFetch,
          onChanged: controller.setAutoFetch,
        ),
        const SizedBox(height: Space.md),

        _CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CardTitle(title: 'Refresh schedule'),
              const SizedBox(height: Space.xs),
              const _CardDescription(
                text:
                    'Downloads every picture again after this many days, '
                    'replacing the old ones. Useful when pictures change on '
                    'the server. It is checked after a catalog sync, so it '
                    'runs the first sync after the days have passed. Only '
                    'works while Automatic download is on.',
              ),
              const SizedBox(height: Space.md),
              Wrap(
                spacing: Space.sm,
                runSpacing: Space.sm,
                children: [
                  for (final (days, label) in _presets)
                    _DayChip(
                      label: label,
                      selected: settings.refetchDays == days,
                      onTap: () => _setDays(days),
                    ),
                ],
              ),
              const SizedBox(height: Space.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _daysController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.done,
                      onChanged: (_) {
                        if (_daysError != null) {
                          setState(() => _daysError = null);
                        }
                      },
                      onSubmitted: (_) => _applyCustomDays(),
                      decoration: InputDecoration(
                        labelText: 'Or a number of days',
                        hintText: 'e.g. 14',
                        errorText: _daysError,
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: Space.md),
                  SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: _applyCustomDays,
                      child: const Text('Set'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Space.md),
              Text(
                _scheduleSummary(settings),
                style: AppTypography.ui(
                  fontSize: 13,
                  height: 1.4,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Space.md),

        _ActionCard(
          title: 'Delete and download again',
          description:
              'Deletes every picture saved on this device, then downloads them '
              'all again from the server. Use it if pictures look wrong or '
              'are out of date. It will not start if the server cannot be '
              'reached, so you are never left with no pictures.',
          buttonLabel: 'Delete and download again',
          icon: Icons.refresh_rounded,
          enabled: !busy,
          onPressed: _onDeleteAndRefetch,
        ),
        const SizedBox(height: Space.md),

        _ActionCard(
          title: 'Delete images and stop downloading',
          description:
              'Deletes every picture saved on this device AND turns off '
              'Automatic download, so nothing is downloaded again afterwards. '
              'Free up space and keep the list picture-free until you turn '
              'Automatic download back on.',
          buttonLabel: 'Delete and stop',
          icon: Icons.delete_outline_rounded,
          destructive: true,
          enabled: !busy,
          onPressed: _onDeleteAndStop,
        ),
      ],
    );
  }

  String _scheduleSummary(ProductImageSettings s) {
    final lines = <String>[];
    lines.add(
      s.refetchDays <= 0
          ? 'Schedule: off. Pictures are only downloaded when missing.'
          : 'Schedule: every ${s.refetchDays == 1 ? 'day' : '${s.refetchDays} days'}.',
    );
    lines.add(
      s.lastRefetchedAt == null
          ? 'Last full refresh: not yet.'
          : 'Last full refresh: ${_date(s.lastRefetchedAt!)}.',
    );
    if (s.refetchDays > 0) {
      if (!s.autoFetch) {
        lines.add('Paused while Automatic download is off.');
      } else {
        final next = s.nextRefetchAt;
        lines.add(
          next == null
              ? 'Next full refresh: counted from the next catalog sync.'
              : 'Next full refresh: after the first catalog sync on or after '
                    '${_date(next)}.',
        );
      }
    }
    return lines.join('\n');
  }

  static String _date(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.borderSubtle),
        color: colors.surface,
      ),
      child: child,
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Text(
      title,
      style: AppTypography.ui(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
      ),
    );
  }
}

class _CardDescription extends StatelessWidget {
  const _CardDescription({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Text(
      text,
      style: AppTypography.ui(
        fontSize: 13,
        height: 1.4,
        color: colors.textSecondary,
      ),
    );
  }
}

class _ToggleCard extends StatelessWidget {
  const _ToggleCard({
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CardTitle(title: title),
                const SizedBox(height: Space.xs),
                _CardDescription(text: description),
              ],
            ),
          ),
          const SizedBox(width: Space.md),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.icon,
    required this.enabled,
    required this.onPressed,
    this.destructive = false,
  });

  final String title;
  final String description;
  final String buttonLabel;
  final IconData icon;
  final bool enabled;
  final bool destructive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(title: title),
          const SizedBox(height: Space.xs),
          _CardDescription(text: description),
          const SizedBox(height: Space.md),
          FilledButton.icon(
            onPressed: enabled ? onPressed : null,
            icon: Icon(icon, size: 20),
            label: Text(buttonLabel),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: destructive ? colors.danger : colors.primary,
              foregroundColor: destructive ? Colors.white : colors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: selected ? colors.primary : colors.surfaceVariant,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: Space.lg),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTypography.ui(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: selected ? colors.onPrimary : colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.job});

  final ProductImagesJobState job;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: colors.primaryContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            job.total > 0
                ? '${job.label}  ${job.done} of ${job.total}'
                : job.label ?? '',
            style: AppTypography.ui(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colors.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: Space.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(value: job.fraction, minHeight: 6),
          ),
        ],
      ),
    );
  }
}
