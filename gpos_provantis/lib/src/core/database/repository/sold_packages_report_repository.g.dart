// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sold_packages_report_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(soldPackagesReportRepository)
final soldPackagesReportRepositoryProvider =
    SoldPackagesReportRepositoryProvider._();

final class SoldPackagesReportRepositoryProvider
    extends
        $FunctionalProvider<
          SoldPackagesReportRepository,
          SoldPackagesReportRepository,
          SoldPackagesReportRepository
        >
    with $Provider<SoldPackagesReportRepository> {
  SoldPackagesReportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soldPackagesReportRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soldPackagesReportRepositoryHash();

  @$internal
  @override
  $ProviderElement<SoldPackagesReportRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SoldPackagesReportRepository create(Ref ref) {
    return soldPackagesReportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoldPackagesReportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SoldPackagesReportRepository>(value),
    );
  }
}

String _$soldPackagesReportRepositoryHash() =>
    r'3e9676d0e75ddd92d8ec38e32bdc18d1d5f2b21d';
