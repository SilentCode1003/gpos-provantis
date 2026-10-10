import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/core/database/providers/sales_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/branch_config_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart'
    show SalesTableData, ReceiptHistoryTableData;
import 'package:gpos_provantis/src/core/database/domain/receipt_history_mapper.dart';

import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/receipts_controller.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/widgets/dashboardWidgets/others_sheet/receipt_preview_sheet.dart';

class ReceiptsScreen extends ConsumerStatefulWidget {
  const ReceiptsScreen({super.key});

  @override
  ConsumerState<ReceiptsScreen> createState() => _ReceiptsScreenState();
}

class _ReceiptsScreenState extends ConsumerState<ReceiptsScreen> {
  @override
  void initState() {
    super.initState();
    // Always open on today.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final today = DateTime.now();
      ref
          .read(receiptsControllerProvider.notifier)
          .load(from: today, to: today);
    });
  }

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Future<void> _pickRange(ReceiptsState state) async {
    final today = _today;
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: state.dateFrom.isAfter(today) ? today : state.dateFrom,
        end: state.dateTo.isAfter(today) ? today : state.dateTo,
      ),
      firstDate: DateTime(2020),
      lastDate: today,
      helpText: 'Select receipt dates',
    );
    if (picked == null || !mounted) return;
    ref
        .read(receiptsControllerProvider.notifier)
        .load(from: picked.start, to: picked.end);
  }

  /// Moves the whole range earlier (-1) or later (+1) by its own length.
  void _shiftRange(ReceiptsState state, int direction) {
    final today = _today;
    final span = _daysBetween(state.dateFrom, state.dateTo) + 1;

    var from = _addDays(state.dateFrom, span * direction);
    var to = _addDays(state.dateTo, span * direction);

    // Never run past today.
    if (to.isAfter(today)) {
      to = today;
      from = _addDays(today, -(span - 1));
    }

    ref.read(receiptsControllerProvider.notifier).load(from: from, to: to);
  }

  Future<void> _open(_ReceiptItem item) async {
    // A receipt that also exists on this device keeps using the local sale row,
    // so it previews and prints exactly as before.
    final sale = item.sale;
    if (sale != null) {
      ReceiptPreviewSheet.show(context, sale: sale);
      return;
    }

    final history = item.history;
    if (history == null) return;

    // The server doesn't send the branch, so use the one configured here.
    var branchId = '';
    try {
      final branch = await ref.read(branchConfigDaoProvider).getBranch();
      final configured = branch?.branchId;
      if (configured != null && configured != 'UNREGISTERED') {
        branchId = configured;
      }
    } catch (_) {
      // Leave it blank rather than block the preview.
    }
    if (!mounted) return;

    ReceiptPreviewSheet.show(
      context,
      saleData: receiptHistoryToSaleData(history, branchId: branchId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = ref.watch(receiptsControllerProvider);
    final salesAsync = ref.watch(salesProvider);

    // Diagnostic (safe to delete): prints when the local sales list changes, so
    // you can see whether this device's sales are reaching the screen.
    ref.listen(salesProvider, (previous, next) {
      debugPrint(
        'Receipts: ${next.value?.length ?? 'no'} local sale(s) available',
      );
    });

    final items = _mergeReceipts(
      history: state.receipts,
      sales: salesAsync.value ?? const <SalesTableData>[],
      from: state.dateFrom,
      to: state.dateTo,
    );

    final canGoNext = state.dateTo.isBefore(_today);

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
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: state.isLoading
                ? null
                : () => ref.read(receiptsControllerProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          _DateBar(
            from: state.dateFrom,
            to: state.dateTo,
            canGoNext: canGoNext,
            onPrevious: () => _shiftRange(state, -1),
            onNext: () => _shiftRange(state, 1),
            onPick: () => _pickRange(state),
          ),
          if (state.isLoading)
            LinearProgressIndicator(
              minHeight: 3,
              color: colors.primary,
              backgroundColor: colors.primaryContainer,
            ),
          if (state.warning != null) _WarningBanner(message: state.warning!),
          Expanded(child: _buildList(items, state, salesAsync.hasError)),
        ],
      ),
    );
  }

  Widget _buildList(
    List<_ReceiptItem> items,
    ReceiptsState state,
    bool salesFailed,
  ) {
    if (items.isEmpty) {
      if (state.isLoading) return const SizedBox.shrink();
      if (salesFailed && state.receipts.isEmpty) {
        return const _ReceiptsMessage(
          icon: Icons.error_outline_rounded,
          text: 'Could not load receipts.',
        );
      }
      return const _ReceiptsMessage(
        icon: Icons.receipt_long_rounded,
        text: 'No receipts for the selected dates.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return _ReceiptTile(item: item, onTap: () => _open(item));
      },
    );
  }
}

/// One row of the list, whichever place it came from.
class _ReceiptItem {
  const _ReceiptItem({
    required this.detailId,
    required this.dateTime,
    required this.paymentType,
    required this.cashier,
    required this.total,
    this.status,
    this.sale,
    this.history,
  });

  final String detailId;
  final DateTime dateTime;
  final String paymentType;
  final String cashier;
  final double total;

  /// From the server, e.g. SOLD or REFUNDED. Null for a sale only known
  /// locally.
  final String? status;

  /// The sale as saved on this device, if any. Preferred for preview/print.
  final SalesTableData? sale;

  /// The copy pulled from the server, if any.
  final ReceiptHistoryTableData? history;

  /// A sale saved on this device that the server doesn't have yet (made
  /// offline, or not uploaded yet).
  bool get isNotSynced =>
      sale != null && history == null && sale!.isSync != '1';
}

/// Server receipts plus this device's own sales in the range, one row per OR.
///
/// The device's sales are included so a sale that hasn't reached the server yet
/// (e.g. made offline) can still be found and reprinted. When a receipt is in
/// both, the local row is used for preview/print and the server's status
/// (REFUNDED etc.) is shown.
List<_ReceiptItem> _mergeReceipts({
  required List<ReceiptHistoryTableData> history,
  required List<SalesTableData> sales,
  required DateTime from,
  required DateTime to,
}) {
  bool inRange(DateTime d) {
    final day = DateTime(d.year, d.month, d.day);
    return !day.isBefore(from) && !day.isAfter(to);
  }

  final byId = <String, _ReceiptItem>{};

  for (final h in history) {
    byId[h.detailId] = _ReceiptItem(
      detailId: h.detailId,
      dateTime: h.createdAt,
      paymentType: h.paymentType,
      cashier: h.cashier,
      total: h.total,
      status: h.status,
      history: h,
    );
  }

  for (final s in sales) {
    // The sale's own `date` (the moment it was rung up, the same value that is
    // sent to the server) decides which day it belongs to. `createdAt` is a
    // database default and is only the fallback.
    final when = DateTime.tryParse(s.date.toString()) ?? s.createdAt;
    if (!inRange(when)) continue;
    final id = s.detailId.toString();
    final existing = byId[id];
    byId[id] = _ReceiptItem(
      detailId: id,
      dateTime: when,
      paymentType: s.paymentType.toString(),
      cashier: s.cashier.toString(),
      total: double.tryParse(s.total.toString()) ?? 0,
      status: existing?.status,
      sale: s,
      history: existing?.history,
    );
  }

  return byId.values.toList()..sort((a, b) => b.dateTime.compareTo(a.dateTime));
}

/// Whole days from [a] to [b]. Goes through UTC so a daylight-saving change
/// can't turn 7 days into 6.
int _daysBetween(DateTime a, DateTime b) {
  final start = DateTime.utc(a.year, a.month, a.day);
  final end = DateTime.utc(b.year, b.month, b.day);
  return end.difference(start).inDays;
}

DateTime _addDays(DateTime d, int days) =>
    DateTime(d.year, d.month, d.day + days);

class _DateBar extends StatelessWidget {
  const _DateBar({
    required this.from,
    required this.to,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
    required this.onPick,
  });

  final DateTime from;
  final DateTime to;
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

  String get _label {
    String day(DateTime d, {bool year = false}) =>
        '${d.day} ${_months[d.month - 1]}${year ? ' ${d.year}' : ''}';

    if (from == to) {
      return '${_weekdays[from.weekday - 1]}, ${day(from, year: true)}';
    }
    if (from.year == to.year) {
      return '${day(from)} – ${day(to, year: true)}';
    }
    return '${day(from, year: true)} – ${day(to, year: true)}';
  }

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
            tooltip: 'Earlier',
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
                      Icons.date_range_rounded,
                      size: 22,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        _label,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.ui(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            iconSize: 28,
            tooltip: 'Later',
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

class _ReceiptTile extends StatelessWidget {
  const _ReceiptTile({required this.item, required this.onTap});

  final _ReceiptItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isRefunded = item.status?.toUpperCase() == 'REFUNDED';

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
              _DateBadge(dateTime: item.dateTime),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'OR# ${item.detailId}',
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.ui(
                              color: colors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (isRefunded) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colors.refund,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'REFUNDED',
                              style: AppTypography.ui(
                                color: colors.onRefund,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ],
                        if (item.isNotSynced) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colors.warningContainer,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'NOT SYNCED',
                              style: AppTypography.ui(
                                color: colors.onWarningContainer,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.paymentType} · ${item.cashier}',
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
                    item.total.toStringAsFixed(2),
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
