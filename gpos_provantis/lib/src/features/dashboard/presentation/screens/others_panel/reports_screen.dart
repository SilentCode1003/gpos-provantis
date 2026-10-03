import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/reports_controller.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  @override
  void initState() {
    super.initState();
    // Always open on today.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(reportsControllerProvider.notifier).load(date: DateTime.now());
    });
  }

  Future<void> _pickDate(DateTime current) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current.isAfter(now) ? now : current,
      firstDate: DateTime(2020),
      lastDate: now,
    );
    if (picked == null || !mounted) return;
    ref.read(reportsControllerProvider.notifier).load(date: picked);
  }

  void _shiftDay(DateTime current, int days) {
    ref
        .read(reportsControllerProvider.notifier)
        .load(date: current.add(Duration(days: days)));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = ref.watch(reportsControllerProvider);

    // Tell the cashier how a print attempt went.
    ref.listen(reportsControllerProvider.select((s) => s.notice), (
      previous,
      next,
    ) {
      if (next == null || identical(previous, next)) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              next.message,
              style: next.isError
                  ? TextStyle(color: colors.onDangerContainer)
                  : null,
            ),
            backgroundColor: next.isError ? colors.dangerContainer : null,
          ),
        );
    });

    final today = DateTime.now();
    final isToday =
        state.date.year == today.year &&
        state.date.month == today.month &&
        state.date.day == today.day;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'Reports',
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
                : () => ref.read(reportsControllerProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _DateBar(
              date: state.date,
              canGoNext: !isToday,
              onPrevious: () => _shiftDay(state.date, -1),
              onNext: () => _shiftDay(state.date, 1),
              onPick: () => _pickDate(state.date),
            ),
            Expanded(child: _Body(state: state)),
          ],
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.state});

  final ReportsState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off_rounded, size: 44, color: colors.danger),
              const SizedBox(height: 12),
              Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
                style: AppTypography.ui(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    ref.read(reportsControllerProvider.notifier).refresh(),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.shifts.isEmpty) {
      return Center(
        child: Text(
          'No shifts found for this date.',
          style: AppTypography.ui(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.shifts.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == 0) return _SummaryCard(state: state);
        final shift = state.shifts[index - 1];
        return _ShiftCard(
          shift: shift,
          isPrinting: state.printingKey == shiftKey(shift),
          canPrint: state.printingKey == null,
          onPrint: () =>
              ref.read(reportsControllerProvider.notifier).printShift(shift),
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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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
                      _formatLongDate(date),
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.state});

  final ReportsState state;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fromCache = state.source == ReportsSource.localCache;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL SALES',
            style: AppTypography.ui(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: colors.onPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _money(state.totalSales),
            style: AppTypography.display(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: colors.onPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${state.shifts.length} shift${state.shifts.length == 1 ? '' : 's'}'
            '${fromCache ? '  ·  Saved copy (server unreachable)' : ''}',
            style: AppTypography.ui(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShiftCard extends StatelessWidget {
  const _ShiftCard({
    required this.shift,
    required this.isPrinting,
    required this.canPrint,
    required this.onPrint,
  });

  final ShiftReportTableData shift;

  /// This card's shift is the one being printed right now.
  final bool isPrinting;

  /// False while any shift is printing, so the printer is never hit twice.
  final bool canPrint;
  final VoidCallback onPrint;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isOpen = shift.status.toUpperCase() == 'OPEN';
    final chipBackground = isOpen
        ? colors.successContainer
        : colors.surfaceVariant;
    final chipForeground = isOpen
        ? colors.onSuccessContainer
        : colors.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SHIFT ${shift.shift}',
                      style: AppTypography.ui(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      shift.cashier,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.ui(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: chipBackground,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  shift.status,
                  style: AppTypography.ui(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: chipForeground,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _money(shift.totalSales),
            style: AppTypography.display(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _DetailRow(
            label: 'Sales',
            value:
                '${_money(shift.salesBeginning)}  →  ${_money(shift.salesEnding)}',
          ),
          const SizedBox(height: 6),
          _DetailRow(
            label: 'Receipts',
            value: '${shift.receiptBeginning}  –  ${shift.receiptEnding}',
          ),
          if (shift.approvedBy != null) ...[
            const SizedBox(height: 6),
            _DetailRow(label: 'Approved by', value: shift.approvedBy!),
          ],
          const SizedBox(height: 14),
          SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: canPrint ? onPrint : null,
              icon: isPrinting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : const Icon(Icons.print_rounded),
              label: Text(
                isPrinting ? 'PRINTING...' : 'PRINT REPORT',
                style: AppTypography.ui(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        SizedBox(
          width: 96,
          child: Text(
            label,
            style: AppTypography.ui(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTypography.ui(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

const _months = [
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

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

String _formatLongDate(DateTime d) =>
    '${_weekdays[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]} ${d.year}';

String _money(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  return '₱$whole.${parts[1]}';
}
