// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sold_services_report_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(soldServicesReportRepository)
final soldServicesReportRepositoryProvider =
    SoldServicesReportRepositoryProvider._();

final class SoldServicesReportRepositoryProvider
    extends
        $FunctionalProvider<
          SoldServicesReportRepository,
          SoldServicesReportRepository,
          SoldServicesReportRepository
        >
    with $Provider<SoldServicesReportRepository> {
  SoldServicesReportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soldServicesReportRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soldServicesReportRepositoryHash();

  @$internal
  @override
  $ProviderElement<SoldServicesReportRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SoldServicesReportRepository create(Ref ref) {
    return soldServicesReportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoldServicesReportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SoldServicesReportRepository>(value),
    );
  }
}

String _$soldServicesReportRepositoryHash() =>
    r'd38f9518b67b12f794b864390447a4f3bd0bbf92';
