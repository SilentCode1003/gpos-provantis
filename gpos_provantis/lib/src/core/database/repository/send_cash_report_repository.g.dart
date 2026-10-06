// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_cash_report_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sendCashReportRepository)
final sendCashReportRepositoryProvider = SendCashReportRepositoryProvider._();

final class SendCashReportRepositoryProvider
    extends
        $FunctionalProvider<
          SendCashReportRepository,
          SendCashReportRepository,
          SendCashReportRepository
        >
    with $Provider<SendCashReportRepository> {
  SendCashReportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendCashReportRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendCashReportRepositoryHash();

  @$internal
  @override
  $ProviderElement<SendCashReportRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SendCashReportRepository create(Ref ref) {
    return sendCashReportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SendCashReportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SendCashReportRepository>(value),
    );
  }
}

String _$sendCashReportRepositoryHash() =>
    r'3bc2ea02577f7b4f1c4f6341e3b2c4faf11a71db';
