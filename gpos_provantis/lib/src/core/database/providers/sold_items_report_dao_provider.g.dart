// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sold_items_report_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(soldItemsReportDao)
final soldItemsReportDaoProvider = SoldItemsReportDaoProvider._();

final class SoldItemsReportDaoProvider
    extends
        $FunctionalProvider<
          SoldItemsReportDao,
          SoldItemsReportDao,
          SoldItemsReportDao
        >
    with $Provider<SoldItemsReportDao> {
  SoldItemsReportDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soldItemsReportDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soldItemsReportDaoHash();

  @$internal
  @override
  $ProviderElement<SoldItemsReportDao> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SoldItemsReportDao create(Ref ref) {
    return soldItemsReportDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoldItemsReportDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SoldItemsReportDao>(value),
    );
  }
}

String _$soldItemsReportDaoHash() =>
    r'05451d8b9fff8ba739a070a3ce18656eb456868c';
