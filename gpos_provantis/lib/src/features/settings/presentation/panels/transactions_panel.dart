// Location: src/features/settings/panels/transactions_panel.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/database/domain/settings_dto.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import '../controllers/app_settings_controller.dart';
import '../screens/settings_shared.dart';

/// =========================================================================
/// TRANSACTIONS PANEL — receipt/transaction behavior toggles.
///
/// Every toggle is saved to the database the moment it is tapped, through
/// `appSettingsProvider` (the single settings row in `SettingsTable`).
/// There is no Save button and no local state here — the switches always
/// show what is actually stored, so they stay correct after a restart.
/// =========================================================================

class TransactionsPanel extends ConsumerWidget {
  const TransactionsPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final settingsAsync = ref.watch(appSettingsProvider);
    final controller = ref.read(appSettingsProvider.notifier);

    // While loading (or if the read failed) show the defaults, so the
    // panel never flashes a blank screen.
    final settings = settingsAsync.value ?? SettingsDto.defaults();

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Space.xxxl,
        Space.xxl,
        Space.xxxl,
        Space.xxxl,
      ),
      children: [
        const PanelHeader(
          title: 'Transactions',
          subtitle: 'Control what appears on receipts and in the sale flow',
        ),
        const SizedBox(height: Space.lg),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.borderSubtle),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: Column(
              children: [
                _ToggleRow(
                  icon: Icons.receipt_long_rounded,
                  title: 'Show VAT on Receipt',
                  subtitle: 'Print the VAT breakdown on every receipt',
                  value: settings.showVatOnReceipt,
                  onChanged: (v) => controller.saveChanges(
                    (s) => s.copyWith(showVatOnReceipt: v),
                  ),
                ),
                Divider(height: 1, thickness: 1, color: colors.borderSubtle),
                _ToggleRow(
                  icon: Icons.notes_rounded,
                  title: 'Show official receipt message',
                  subtitle:
                      'Print the "This serves as an Official Receipt" '
                      'line at the bottom',
                  value: settings.showOfficialReceiptMessageAtTheBottom,
                  onChanged: (v) => controller.saveChanges(
                    (s) => s.copyWith(showOfficialReceiptMessageAtTheBottom: v),
                  ),
                ),
                Divider(height: 1, thickness: 1, color: colors.borderSubtle),
                _ToggleRow(
                  icon: Icons.verified_rounded,
                  title: 'BIR Accredited',
                  subtitle:
                      'Mark this terminal as BIR-accredited for receipt '
                      'compliance fields',
                  value: settings.birAccredited,
                  onChanged: (v) => controller.saveChanges(
                    (s) => s.copyWith(birAccredited: v),
                  ),
                ),
                Divider(height: 1, thickness: 1, color: colors.borderSubtle),
                _ToggleRow(
                  icon: Icons.preview_rounded,
                  title: 'Show Receipt Preview',
                  subtitle: 'Preview the receipt before it prints',
                  value: settings.showReceiptPreview,
                  onChanged: (v) => controller.saveChanges(
                    (s) => s.copyWith(showReceiptPreview: v),
                  ),
                ),
                Divider(height: 1, thickness: 1, color: colors.borderSubtle),
                _ToggleRow(
                  icon: Icons.person_add_alt_rounded,
                  title: 'Add Customer to Transaction',
                  subtitle: 'Let the cashier attach a customer to a sale',
                  value: settings.addCustomerToTransaction,
                  onChanged: (v) => controller.saveChanges(
                    (s) => s.copyWith(addCustomerToTransaction: v),
                  ),
                ),
                Divider(height: 1, thickness: 1, color: colors.borderSubtle),
                _ToggleRow(
                  icon: Icons.assignment_rounded,
                  title: 'Add Purchase Order to Transaction',
                  subtitle: 'Let the cashier attach a purchase order to a sale',
                  value: settings.addPurchaseOrderToTransaction,
                  onChanged: (v) => controller.saveChanges(
                    (s) => s.copyWith(addPurchaseOrderToTransaction: v),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// One toggle row: icon, title + optional subtitle, and a touch-sized
/// switch. Local to this panel for now — if a second panel ends up
/// needing the exact same row shape, pull it into `settings_shared.dart`
/// then (see that file's own note on when something earns a shared home).
class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.surface,
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Container(
          constraints: const BoxConstraints(minHeight: 76),
          padding: const EdgeInsets.symmetric(
            horizontal: Space.lg,
            vertical: Space.md,
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: colors.textSecondary),
              const SizedBox(width: Space.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.ui(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTypography.ui(
                          fontSize: 13,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: Space.md),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: colors.onPrimary,
                activeTrackColor: colors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
