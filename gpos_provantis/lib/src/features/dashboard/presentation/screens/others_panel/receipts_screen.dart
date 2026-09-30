import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/core/database/providers/sales_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart'
    show SalesTableData;

import 'package:gpos_provantis/src/features/dashboard/presentation/widgets/dashboardWidgets/others_sheet/receipt_preview_sheet.dart';

class ReceiptsScreen extends ConsumerWidget {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final salesAsync = ref.watch(salesProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'Receipts',
          style: AppTypography.display(
            color: colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colors.surface,
      ),
      body: salesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ReceiptsMessage(
          icon: Icons.error_outline_rounded,
          text: 'Could not load receipts.\n$error',
        ),
        data: (sales) {
          if (sales.isEmpty) {
            return const _ReceiptsMessage(
              icon: Icons.receipt_long_rounded,
              text: 'No receipts yet.',
            );
          }

          final sorted = [...sales]
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: sorted.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _SaleTile(sale: sorted[index]),
          );
        },
      ),
    );
  }
}

class _ReceiptsMessage extends StatelessWidget {
  const _ReceiptsMessage({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: colors.textSecondary),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppTypography.ui(
                color: colors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaleTile extends StatelessWidget {
  const _SaleTile({required this.sale});

  final SalesTableData sale;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final total = double.tryParse(sale.total) ?? 0;

    return Material(
      color: colors.surfaceVariant,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => ReceiptPreviewSheet.show(context, sale: sale),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              _DateBadge(dateTime: sale.createdAt),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OR# ${sale.detailId}',
                      style: AppTypography.ui(
                        color: colors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${sale.paymentType} · ${sale.cashier}',
                      style: AppTypography.ui(
                        color: colors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    total.toStringAsFixed(2),
                    style: AppTypography.ui(
                      color: colors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: colors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.dateTime});

  final DateTime dateTime;

  static const _months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final twoDigitHour = ((dateTime.hour % 12 == 0) ? 12 : dateTime.hour % 12)
        .toString();
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final meridiem = dateTime.hour >= 12 ? 'PM' : 'AM';

    return Container(
      width: 56,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _months[dateTime.month - 1],
            style: AppTypography.ui(
              color: colors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '${dateTime.day}',
            style: AppTypography.display(
              color: colors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$twoDigitHour:$minute $meridiem',
            style: AppTypography.ui(color: colors.textSecondary, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
