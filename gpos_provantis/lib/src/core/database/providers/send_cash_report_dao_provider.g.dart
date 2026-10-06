// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_cash_report_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sendCashReportDao)
final sendCashReportDaoProvider = SendCashReportDaoProvider._();

final class SendCashReportDaoProvider
    extends
        $FunctionalProvider<
          SendCashReportDao,
          SendCashReportDao,
          SendCashReportDao
        >
    with $Provider<SendCashReportDao> {
  SendCashReportDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendCashReportDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendCashReportDaoHash();

  @$internal
  @override
  $ProviderElement<SendCashReportDao> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SendCashReportDao create(Ref ref) {
    return sendCashReportDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SendCashReportDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SendCashReportDao>(value),
    );
  }
}

String _$sendCashReportDaoHash() => r'15f5715ffc65954c55ac1deeec10f6e6dfcc9ab5';
