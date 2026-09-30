// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_sales_report_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(staffSalesReportDao)
final staffSalesReportDaoProvider = StaffSalesReportDaoProvider._();

final class StaffSalesReportDaoProvider
    extends
        $FunctionalProvider<
          StaffSalesReportDao,
          StaffSalesReportDao,
          StaffSalesReportDao
        >
    with $Provider<StaffSalesReportDao> {
  StaffSalesReportDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'staffSalesReportDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$staffSalesReportDaoHash();

  @$internal
  @override
  $ProviderElement<StaffSalesReportDao> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StaffSalesReportDao create(Ref ref) {
    return staffSalesReportDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StaffSalesReportDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StaffSalesReportDao>(value),
    );
  }
}

String _$staffSalesReportDaoHash() =>
    r'524a8e24f14425bcdf28264657fa926893c8a4f2';
