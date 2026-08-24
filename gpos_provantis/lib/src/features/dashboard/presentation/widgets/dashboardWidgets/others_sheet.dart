// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/others_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';

/// --- Others sheet: 13-item grid of secondary actions -----------------------
///
/// A bottom sheet is the right call here specifically because these are
/// one-off, low-frequency actions (discounts, void, returns, etc) rather
/// than the rapid tap-tap-tap loop that ruled out a sheet for categories.
/// Opens full-width (not right-panel-only) since it's launched from the
/// top bar, not from inside the category/product flow, and there's no
/// "covers the buttons I need to tap again immediately" problem here.
class OthersSheet extends ConsumerWidget {
  const OthersSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const OthersSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final controller = ref.watch(dashboardControllerProvider.notifier);
    final actions = controller.otherActions;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Text(
            'Other actions',
            style: AppTypography.display(
              color: colors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 160,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              return _OtherActionTile(action: actions[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _OtherActionTile extends StatelessWidget {
  const _OtherActionTile({required this.action});

  final OtherAction action;

  static const _iconMap = {
    'percent_rounded': Icons.percent_rounded,
    'credit_card_rounded': Icons.credit_card_rounded,
    'block_rounded': Icons.block_rounded,
    'search_rounded': Icons.search_rounded,
    'inbox_rounded': Icons.inbox_rounded,
    'person_search_rounded': Icons.person_search_rounded,
    'sticky_note_2_rounded': Icons.sticky_note_2_rounded,
    'assignment_return_rounded': Icons.assignment_return_rounded,
    'card_giftcard_rounded': Icons.card_giftcard_rounded,
    'receipt_long_rounded': Icons.receipt_long_rounded,
    'print_rounded': Icons.print_rounded,
    'summarize_rounded': Icons.summarize_rounded,
    'loyalty_rounded': Icons.loyalty_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final icon = _iconMap[action.icon] ?? Icons.touch_app_rounded;

    return Material(
      color: colors.surfaceVariant,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 26, color: colors.textPrimary),
              const SizedBox(height: 8),
              Text(
                action.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.ui(
                  color: colors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
