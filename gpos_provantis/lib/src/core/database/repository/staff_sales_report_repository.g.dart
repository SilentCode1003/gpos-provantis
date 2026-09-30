// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_sales_report_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(staffSalesReportRepository)
final staffSalesReportRepositoryProvider =
    StaffSalesReportRepositoryProvider._();

final class StaffSalesReportRepositoryProvider
    extends
        $FunctionalProvider<
          StaffSalesReportRepository,
          StaffSalesReportRepository,
          StaffSalesReportRepository
        >
    with $Provider<StaffSalesReportRepository> {
  StaffSalesReportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'staffSalesReportRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$staffSalesReportRepositoryHash();

  @$internal
  @override
  $ProviderElement<StaffSalesReportRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StaffSalesReportRepository create(Ref ref) {
    return staffSalesReportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StaffSalesReportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StaffSalesReportRepository>(value),
    );
  }
}

String _$staffSalesReportRepositoryHash() =>
    r'244100c9655893938c4108e7e0380d1fe020a8b2';
