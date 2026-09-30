import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';

import 'package:gpos_provantis/src/core/printutil/shift_report_generator.dart';

import 'package:gpos_provantis/src/core/database/repository/end_shift_report_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/sold_items_report_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/sold_services_report_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/sold_packages_report_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/payment_summary_report_repository.dart';
import 'package:gpos_provantis/src/core/database/repository/staff_sales_report_repository.dart';

part 'end_shift_service.g.dart';

/// Where a report came from. Useful if the UI wants to show
/// "Printed from saved copy" when offline.
enum ShiftReportSource { server, localCache }

class EndShiftResult {
  const EndShiftResult({
    required this.report,
    required this.source,
    this.soldItemsUnavailable = false,
    this.soldServicesUnavailable = false,
    this.soldPackagesUnavailable = false,
    this.paymentSummaryUnavailable = false,
    this.staffSalesUnavailable = false,
  });

  final EndShiftTableData report;
  final ShiftReportSource source;

  /// True when the SOLD ITEMS section could not be loaded (server unreachable
  /// and nothing saved for this shift) and the report was printed without it.
  final bool soldItemsUnavailable;

  /// Same as [soldItemsUnavailable], for the SOLD SERVICES section.
  final bool soldServicesUnavailable;

  /// Same as [soldItemsUnavailable], for the SOLD PACKAGES section.
  final bool soldPackagesUnavailable;

  /// Same as [soldItemsUnavailable], for the PAYMENTS SUMMARY section.
  final bool paymentSummaryUnavailable;

  /// Same as [soldItemsUnavailable], for the STAFF SALES section.
  final bool staffSalesUnavailable;

  bool get isComplete =>
      !soldItemsUnavailable &&
      !soldServicesUnavailable &&
      !soldPackagesUnavailable &&
      !paymentSummaryUnavailable &&
      !staffSalesUnavailable;
}

class EndShiftReportUnavailableException implements Exception {
  const EndShiftReportUnavailableException(this.message);
  final String message;

  @override
  String toString() => 'EndShiftReportUnavailableException: $message';
}

@Riverpod(keepAlive: true)
EndShiftService endShiftService(Ref ref) {
  return EndShiftService(
    repository: ref.watch(endShiftRepositoryProvider),
    soldItemsRepository: ref.watch(soldItemsReportRepositoryProvider),
    soldServicesRepository: ref.watch(soldServicesReportRepositoryProvider),
    soldPackagesRepository: ref.watch(soldPackagesReportRepositoryProvider),
    paymentSummaryRepository: ref.watch(paymentSummaryReportRepositoryProvider),
    staffSalesRepository: ref.watch(staffSalesReportRepositoryProvider),
    printer: ref.watch(shiftReportPrinterServiceProvider),
  );
}

class EndShiftService {
  EndShiftService({
    required EndShiftRepository repository,
    required SoldItemsReportRepository soldItemsRepository,
    required SoldServicesReportRepository soldServicesRepository,
    required SoldPackagesReportRepository soldPackagesRepository,
    required PaymentSummaryReportRepository paymentSummaryRepository,
    required StaffSalesReportRepository staffSalesRepository,
    required ShiftReportPrinterService printer,
  }) : _repository = repository,
       _soldItemsRepository = soldItemsRepository,
       _soldServicesRepository = soldServicesRepository,
       _soldPackagesRepository = soldPackagesRepository,
       _paymentSummaryRepository = paymentSummaryRepository,
       _staffSalesRepository = staffSalesRepository,
       _printer = printer;

  final EndShiftRepository _repository;
  final SoldItemsReportRepository _soldItemsRepository;
  final SoldServicesReportRepository _soldServicesRepository;
  final SoldPackagesReportRepository _soldPackagesRepository;
  final PaymentSummaryReportRepository _paymentSummaryRepository;
  final StaffSalesReportRepository _staffSalesRepository;
  final ShiftReportPrinterService _printer;

  /// Gets the shift report and prints it.
  ///
  /// 1. Tries the server; on success the report is saved to the local DB.
  /// 2. If the server is unreachable, falls back to the locally saved copy.
  /// 3. Uses that report's receipt range to load the sold items, services,
  ///    packages, payment summary and staff sales (server first, local copy as fallback).
  /// 4. Prints whichever report it ended up with.
  ///
  /// Throws [EndShiftReportUnavailableException] if the server can't be
  /// reached *and* there is no saved copy. Printer errors propagate so the
  /// caller can offer a retry (everything is already saved by then, so a
  /// retry can use [reprintShiftReport] without hitting the network).
  ///
  /// The extra sections never block the Z-reading: if one can't be loaded the
  /// report still prints and the matching `...Unavailable` flag on
  /// [EndShiftResult] is set.
  Future<EndShiftResult> printEndShiftReport({
    required String date,
    required int posId,
    required int shiftId,
  }) async {
    final result = await _loadReport(date, posId, shiftId);

    // If the report itself came from the local copy we already know the
    // server is unreachable, so skip straight to the local sections.
    final tryServer = result.source == ShiftReportSource.server;

    // Independent calls, so run them side by side.
    final soldFuture = _loadSoldItems(result.report, tryServer: tryServer);
    final servicesFuture = _loadSoldServices(
      result.report,
      tryServer: tryServer,
    );
    final packagesFuture = _loadSoldPackages(
      result.report,
      tryServer: tryServer,
    );
    final paymentsFuture = _loadPaymentSummary(
      result.report,
      tryServer: tryServer,
    );
    final staffFuture = _loadStaffSales(result.report, tryServer: tryServer);
    final sold = await soldFuture;
    final services = await servicesFuture;
    final packages = await packagesFuture;
    final payments = await paymentsFuture;
    final staff = await staffFuture;

    await _printer.printShiftReport(
      ShiftReportPrintData.fromTable(
        result.report,
        soldItems: sold.lines,
        soldServices: services.lines,
        soldPackages: packages.lines,
        paymentSummary: payments.lines,
        staffSales: staff.lines,
      ),
    );

    return EndShiftResult(
      report: result.report,
      source: result.source,
      soldItemsUnavailable: !sold.available,
      soldServicesUnavailable: !services.available,
      soldPackagesUnavailable: !packages.available,
      paymentSummaryUnavailable: !payments.available,
      staffSalesUnavailable: !staff.available,
    );
  }

  /// Reprints strictly from the local DB. Never touches the network.
  Future<EndShiftTableData> reprintShiftReport({
    required String date,
    required int posId,
    required int shiftId,
  }) async {
    final local = await _repository.getLocalEndShiftReport(
      date,
      posId,
      shiftId,
    );
    if (local == null) {
      throw const EndShiftReportUnavailableException(
        'No saved shift report on this device for that shift.',
      );
    }

    final items = await _soldItemsRepository.getLocalSoldItems(
      local.receiptBeginning,
      local.receiptEnding,
    );
    final services = await _soldServicesRepository.getLocalSoldServices(
      local.receiptBeginning,
      local.receiptEnding,
    );
    final packages = await _soldPackagesRepository.getLocalSoldPackages(
      local.receiptBeginning,
      local.receiptEnding,
    );
    final payments = await _paymentSummaryRepository.getLocalPaymentSummary(
      local.receiptBeginning,
      local.receiptEnding,
    );

    final staff = await _staffSalesRepository.getLocalStaffSales(
      local.receiptBeginning,
      local.receiptEnding,
    );

    await _printer.printShiftReport(
      ShiftReportPrintData.fromTable(
        local,
        soldItems: _soldToLines(items),
        soldServices: _servicesToLines(services),
        soldPackages: _packagesToLines(packages),
        paymentSummary: _paymentsToLines(payments),
        staffSales: _staffToLines(staff),
        isReprint: true,
      ),
    );
    return local;
  }

  Future<EndShiftResult> _loadReport(
    String date,
    int posId,
    int shiftId,
  ) async {
    try {
      final fresh = await _repository.fetchAndSaveEndShiftReport(
        date,
        posId,
        shiftId,
      );
      return EndShiftResult(report: fresh, source: ShiftReportSource.server);
    } on DioException catch (e) {
      // Only network-level failures fall back. A server that answers with
      // "no data" throws a plain Exception and is deliberately NOT caught.
      debugPrint(
        'EndShiftService: server unreachable (${e.type}), '
        'trying local copy.',
      );

      final local = await _repository.getLocalEndShiftReport(
        date,
        posId,
        shiftId,
      );
      if (local == null) {
        throw EndShiftReportUnavailableException(
          'Could not reach the server and no saved shift report exists on '
          'this device (date=$date, pos=$posId, shift=$shiftId).',
        );
      }
      return EndShiftResult(
        report: local,
        source: ShiftReportSource.localCache,
      );
    }
  }

  /// Server first (if [tryServer]), then the local copy for the same receipt
  /// range. Never throws: the Z-reading must still be able to print.
  ///
  /// [available] is false only when the server failed/was skipped AND there is
  /// nothing saved locally, i.e. the section is missing rather than
  /// legitimately empty.
  Future<({List<ShiftReportLine> lines, bool available})> _loadSoldItems(
    EndShiftTableData report, {
    required bool tryServer,
  }) async {
    final begin = report.receiptBeginning;
    final end = report.receiptEnding;

    if (tryServer) {
      try {
        final rows = await _soldItemsRepository.fetchAndSaveSoldItems(
          begin,
          end,
        );
        return (lines: _soldToLines(rows), available: true);
      } catch (e) {
        debugPrint(
          'EndShiftService: sold items fetch failed ($e), '
          'trying local copy.',
        );
      }
    }

    try {
      final local = await _soldItemsRepository.getLocalSoldItems(begin, end);
      return (lines: _soldToLines(local), available: local.isNotEmpty);
    } catch (e) {
      debugPrint('EndShiftService: local sold items read failed: $e');
      return (lines: const <ShiftReportLine>[], available: false);
    }
  }

  /// Same strategy as [_loadSoldItems], for the sold services.
  Future<({List<ShiftReportLine> lines, bool available})> _loadSoldServices(
    EndShiftTableData report, {
    required bool tryServer,
  }) async {
    final begin = report.receiptBeginning;
    final end = report.receiptEnding;

    if (tryServer) {
      try {
        final rows = await _soldServicesRepository.fetchAndSaveSoldServices(
          begin,
          end,
        );
        return (lines: _servicesToLines(rows), available: true);
      } catch (e) {
        debugPrint(
          'EndShiftService: sold services fetch failed ($e), '
          'trying local copy.',
        );
      }
    }

    try {
      final local = await _soldServicesRepository.getLocalSoldServices(
        begin,
        end,
      );
      return (lines: _servicesToLines(local), available: local.isNotEmpty);
    } catch (e) {
      debugPrint('EndShiftService: local sold services read failed: $e');
      return (lines: const <ShiftReportLine>[], available: false);
    }
  }

  /// Same strategy as [_loadSoldItems], for the sold packages.
  Future<({List<ShiftReportLine> lines, bool available})> _loadSoldPackages(
    EndShiftTableData report, {
    required bool tryServer,
  }) async {
    final begin = report.receiptBeginning;
    final end = report.receiptEnding;

    if (tryServer) {
      try {
        final rows = await _soldPackagesRepository.fetchAndSaveSoldPackages(
          begin,
          end,
        );
        return (lines: _packagesToLines(rows), available: true);
      } catch (e) {
        debugPrint(
          'EndShiftService: sold packages fetch failed ($e), '
          'trying local copy.',
        );
      }
    }

    try {
      final local = await _soldPackagesRepository.getLocalSoldPackages(
        begin,
        end,
      );
      return (lines: _packagesToLines(local), available: local.isNotEmpty);
    } catch (e) {
      debugPrint('EndShiftService: local sold packages read failed: $e');
      return (lines: const <ShiftReportLine>[], available: false);
    }
  }

  /// Same strategy as [_loadSoldItems], for the payment summary.
  Future<({List<ShiftReportAmountLine> lines, bool available})>
  _loadPaymentSummary(
    EndShiftTableData report, {
    required bool tryServer,
  }) async {
    final begin = report.receiptBeginning;
    final end = report.receiptEnding;

    if (tryServer) {
      try {
        final rows = await _paymentSummaryRepository.fetchAndSavePaymentSummary(
          begin,
          end,
        );
        return (lines: _paymentsToLines(rows), available: true);
      } catch (e) {
        debugPrint(
          'EndShiftService: payment summary fetch failed ($e), '
          'trying local copy.',
        );
      }
    }

    try {
      final local = await _paymentSummaryRepository.getLocalPaymentSummary(
        begin,
        end,
      );
      return (lines: _paymentsToLines(local), available: local.isNotEmpty);
    } catch (e) {
      debugPrint('EndShiftService: local payment summary read failed: $e');
      return (lines: const <ShiftReportAmountLine>[], available: false);
    }
  }

  /// Same strategy as [_loadSoldItems], for the staff sales.
  Future<({List<ShiftReportAmountLine> lines, bool available})> _loadStaffSales(
    EndShiftTableData report, {
    required bool tryServer,
  }) async {
    final begin = report.receiptBeginning;
    final end = report.receiptEnding;

    if (tryServer) {
      try {
        final rows = await _staffSalesRepository.fetchAndSaveStaffSales(
          begin,
          end,
        );
        return (lines: _staffToLines(rows), available: true);
      } catch (e) {
        debugPrint(
          'EndShiftService: staff sales fetch failed ($e), '
          'trying local copy.',
        );
      }
    }

    try {
      final local = await _staffSalesRepository.getLocalStaffSales(begin, end);
      return (lines: _staffToLines(local), available: local.isNotEmpty);
    } catch (e) {
      debugPrint('EndShiftService: local staff sales read failed: $e');
      return (lines: const <ShiftReportAmountLine>[], available: false);
    }
  }

  List<ShiftReportLine> _soldToLines(List<SoldItemsReportTableData> rows) => [
    for (final r in rows)
      ShiftReportLine(name: r.item, quantity: r.quantity, total: r.total),
  ];

  List<ShiftReportLine> _servicesToLines(
    List<SoldServicesReportTableData> rows,
  ) => [
    for (final r in rows)
      ShiftReportLine(name: r.item, quantity: r.quantity, total: r.total),
  ];

  List<ShiftReportLine> _packagesToLines(
    List<SoldPackagesReportTableData> rows,
  ) => [
    for (final r in rows)
      ShiftReportLine(name: r.item, quantity: r.quantity, total: r.total),
  ];

  List<ShiftReportAmountLine> _paymentsToLines(
    List<PaymentSummaryReportTableData> rows,
  ) => [
    for (final r in rows)
      ShiftReportAmountLine(label: r.paymentType, total: r.total),
  ];

  List<ShiftReportAmountLine> _staffToLines(
    List<StaffSalesReportTableData> rows,
  ) => [
    for (final r in rows)
      ShiftReportAmountLine(label: r.salesStaff, total: r.total),
  ];
}
