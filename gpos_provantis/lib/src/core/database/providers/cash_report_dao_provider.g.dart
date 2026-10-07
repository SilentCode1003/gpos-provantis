// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_report_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cashReportDao)
final cashReportDaoProvider = CashReportDaoProvider._();

final class CashReportDaoProvider
    extends $FunctionalProvider<CashReportDao, CashReportDao, CashReportDao>
    with $Provider<CashReportDao> {
  CashReportDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cashReportDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cashReportDaoHash();

  @$internal
  @override
  $ProviderElement<CashReportDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CashReportDao create(Ref ref) {
    return cashReportDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CashReportDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CashReportDao>(value),
    );
  }
}

String _$cashReportDaoHash() => r'e81b074a0556ed3de1a71bba7b57a02f3d79deec';
