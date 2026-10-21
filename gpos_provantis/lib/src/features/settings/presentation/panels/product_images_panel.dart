import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/database/domain/settings_dto.dart';
import 'package:gpos_provantis/src/core/database/providers/settings_dao_provider.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/settings/presentation/controllers/product_images_controller.dart';
import 'package:gpos_provantis/src/shared/widgets/confirm_dialog.dart';
import '../screens/settings_cards.dart';
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

        SettingsToggleCard(
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

        SettingsToggleCard(
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

        SettingsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SettingsCardTitle(title: 'Refresh schedule'),
              const SizedBox(height: Space.xs),
              const SettingsCardDescription(
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
                    SettingsChoiceChip(
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

        SettingsActionCard(
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

        SettingsActionCard(
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
