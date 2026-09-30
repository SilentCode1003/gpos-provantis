// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sold_services_report_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(soldServicesReportDao)
final soldServicesReportDaoProvider = SoldServicesReportDaoProvider._();

final class SoldServicesReportDaoProvider
    extends
        $FunctionalProvider<
          SoldServicesReportDao,
          SoldServicesReportDao,
          SoldServicesReportDao
        >
    with $Provider<SoldServicesReportDao> {
  SoldServicesReportDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soldServicesReportDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soldServicesReportDaoHash();

  @$internal
  @override
  $ProviderElement<SoldServicesReportDao> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SoldServicesReportDao create(Ref ref) {
    return soldServicesReportDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoldServicesReportDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SoldServicesReportDao>(value),
    );
  }
}

String _$soldServicesReportDaoHash() =>
    r'53812cac5ccb69a0a2ea1c4c991a57557f7f109b';
