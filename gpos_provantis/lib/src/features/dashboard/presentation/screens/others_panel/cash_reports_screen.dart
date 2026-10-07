import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart'
    show CashReportTableData;
import 'package:gpos_provantis/src/core/database/domain/cash_report_dto.dart';

import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/cash_reports_controller.dart';

class CashReportsScreen extends ConsumerStatefulWidget {
  const CashReportsScreen({super.key});

  @override
  ConsumerState<CashReportsScreen> createState() => _CashReportsScreenState();
}

class _CashReportsScreenState extends ConsumerState<CashReportsScreen> {
  @override
  void initState() {
    super.initState();
    // Always open on today.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(cashReportsControllerProvider.notifier)
          .load(date: DateTime.now());
    });
  }

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Future<void> _pickDate(DateTime current) async {
    final today = _today;
    final picked = await showDatePicker(
      context: context,
      initialDate: current.isAfter(today) ? today : current,
      firstDate: DateTime(2020),
      lastDate: today,
    );
    if (picked == null || !mounted) return;
    ref.read(cashReportsControllerProvider.notifier).load(date: picked);
  }

  void _shiftDay(DateTime current, int days) {
    ref
        .read(cashReportsControllerProvider.notifier)
        .load(date: DateTime(current.year, current.month, current.day + days));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = ref.watch(cashReportsControllerProvider);
    final canGoNext = state.date.isBefore(_today);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'Cash Reports',
          style: AppTypography.display(
            color: colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colors.surface,
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: state.isLoading
                ? null
                : () => ref
                      .read(cashReportsControllerProvider.notifier)
                      .refresh(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          _DateBar(
            date: state.date,
            canGoNext: canGoNext,
            onPrevious: () => _shiftDay(state.date, -1),
            onNext: () => _shiftDay(state.date, 1),
            onPick: () => _pickDate(state.date),
          ),
          if (state.isLoading)
            LinearProgressIndicator(
              minHeight: 3,
              color: colors.primary,
              backgroundColor: colors.primaryContainer,
            ),
          if (state.warning != null) _WarningBanner(message: state.warning!),
          Expanded(child: _buildBody(state)),
        ],
      ),
    );
  }

  Widget _buildBody(CashReportsState state) {
    if (state.isLoading) return const SizedBox.shrink();

    if (state.errorMessage != null) {
      return _Message(
        icon: Icons.cloud_off_rounded,
        text: state.errorMessage!,
        onRetry: () =>
            ref.read(cashReportsControllerProvider.notifier).refresh(),
      );
    }

    if (state.reports.isEmpty) {
      return const _Message(
        icon: Icons.account_balance_wallet_rounded,
        text: 'No cash reports for this date.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: state.reports.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final report = state.reports[index];
        return _CashReportTile(
          report: report,
          onTap: () => _CashReportSheet.show(context, report),
        );
      },
    );
  }
}

class _DateBar extends StatelessWidget {
  const _DateBar({
    required this.date,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
    required this.onPick,
  });

  final DateTime date;
  final bool canGoNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onPick;

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label =
        '${_weekdays[date.weekday - 1]}, ${date.day} '
        '${_months[date.month - 1]} ${date.year}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: Row(
        children: [
          IconButton(
            iconSize: 28,
            tooltip: 'Previous day',
            onPressed: onPrevious,
            icon: Icon(Icons.chevron_left_rounded, color: colors.textPrimary),
          ),
          Expanded(
            child: InkWell(
              onTap: onPick,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      size: 22,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      label,
                      style: AppTypography.ui(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            iconSize: 28,
            tooltip: 'Next day',
            onPressed: canGoNext ? onNext : null,
            icon: Icon(Icons.chevron_right_rounded, color: colors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: colors.warningContainer,
      child: Row(
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 18,
            color: colors.onWarningContainer,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTypography.ui(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.onWarningContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text, this.onRetry});

  final IconData icon;
  final String text;
  final VoidCallback? onRetry;

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
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onRetry, child: const Text('Try again')),
            ],
          ],
        ),
      ),
    );
  }
}

class _CashReportTile extends StatelessWidget {
  const _CashReportTile({required this.report, required this.onTap});

  final CashReportTableData report;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.surfaceVariant,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              _ShiftBadge(shift: report.shift),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total cash',
                      style: AppTypography.ui(
                        color: colors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _money(report.totalCash),
                      style: AppTypography.ui(
                        color: colors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Float ${_money(report.cashFloat)}',
                      style: AppTypography.ui(
                        color: colors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShiftBadge extends StatelessWidget {
  const _ShiftBadge({required this.shift});

  final int shift;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 56,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'SHIFT',
            style: AppTypography.ui(
              color: colors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '$shift',
            style: AppTypography.display(
              color: colors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// The denominations behind one cash report.
class _CashReportSheet extends StatelessWidget {
  const _CashReportSheet({required this.report});

  final CashReportTableData report;

  static Future<void> show(BuildContext context, CashReportTableData report) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CashReportSheet(report: report),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final counted = report.countedLines;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Shift ${report.shift} · ${report.shiftDate}',
                        style: AppTypography.display(
                          color: colors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      iconSize: 26,
                      color: colors.textSecondary,
                      style: IconButton.styleFrom(
                        minimumSize: const Size(48, 48),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    _SummaryRow(
                      label: 'Cash float',
                      value: _money(report.cashFloat),
                    ),
                    _SummaryRow(
                      label: 'Total cash',
                      value: _money(report.totalCash),
                      emphasize: true,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'DENOMINATIONS COUNTED',
                      style: AppTypography.ui(
                        color: colors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (counted.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'No cash was counted in this report.',
                          style: AppTypography.ui(
                            color: colors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colors.border),
                        ),
                        child: Column(
                          children: [
                            for (final line in counted)
                              _DenominationRow(line: line),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: AppTypography.ui(
              color: colors.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTypography.ui(
              color: colors.textPrimary,
              fontSize: emphasize ? 20 : 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DenominationRow extends StatelessWidget {
  const _DenominationRow({required this.line});

  final CashReportLineDto line;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '${line.value}',
            style: AppTypography.ui(
              color: colors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '×  ${line.quantity}',
            style: AppTypography.ui(color: colors.textSecondary, fontSize: 14),
          ),
          const Spacer(),
          Text(
            _money(line.lineTotal.toDouble()),
            style: AppTypography.ui(
              color: colors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// 1234.5 -> "1,234.50"
String _money(double value) {
  final parts = value.toStringAsFixed(2).split('.');
  final whole = parts[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  return '$whole.${parts[1]}';
}
