// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sold_items_report_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(soldItemsReportRepository)
final soldItemsReportRepositoryProvider = SoldItemsReportRepositoryProvider._();

final class SoldItemsReportRepositoryProvider
    extends
        $FunctionalProvider<
          SoldItemsReportRepository,
          SoldItemsReportRepository,
          SoldItemsReportRepository
        >
    with $Provider<SoldItemsReportRepository> {
  SoldItemsReportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soldItemsReportRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soldItemsReportRepositoryHash();

  @$internal
  @override
  $ProviderElement<SoldItemsReportRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SoldItemsReportRepository create(Ref ref) {
    return soldItemsReportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoldItemsReportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SoldItemsReportRepository>(value),
    );
  }
}

String _$soldItemsReportRepositoryHash() =>
    r'6a11f6dd128b5359e932f740fba740df5385ebe6';
