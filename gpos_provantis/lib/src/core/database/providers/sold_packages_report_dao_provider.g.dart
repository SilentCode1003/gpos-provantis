// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sold_packages_report_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(soldPackagesReportDao)
final soldPackagesReportDaoProvider = SoldPackagesReportDaoProvider._();

final class SoldPackagesReportDaoProvider
    extends
        $FunctionalProvider<
          SoldPackagesReportDao,
          SoldPackagesReportDao,
          SoldPackagesReportDao
        >
    with $Provider<SoldPackagesReportDao> {
  SoldPackagesReportDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soldPackagesReportDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soldPackagesReportDaoHash();

  @$internal
  @override
  $ProviderElement<SoldPackagesReportDao> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SoldPackagesReportDao create(Ref ref) {
    return soldPackagesReportDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoldPackagesReportDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SoldPackagesReportDao>(value),
    );
  }
}

String _$soldPackagesReportDaoHash() =>
    r'e439eb42a0aa5cadb96f4be14113507a416c8fc0';
