// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_report_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cashReportRepository)
final cashReportRepositoryProvider = CashReportRepositoryProvider._();

final class CashReportRepositoryProvider
    extends
        $FunctionalProvider<
          CashReportRepository,
          CashReportRepository,
          CashReportRepository
        >
    with $Provider<CashReportRepository> {
  CashReportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cashReportRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cashReportRepositoryHash();

  @$internal
  @override
  $ProviderElement<CashReportRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CashReportRepository create(Ref ref) {
    return cashReportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CashReportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CashReportRepository>(value),
    );
  }
}

String _$cashReportRepositoryHash() =>
    r'f11250ca27c1b07bd69373580fa2c4a32da81602';
