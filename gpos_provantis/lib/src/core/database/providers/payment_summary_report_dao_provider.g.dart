// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_summary_report_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(paymentSummaryReportDao)
final paymentSummaryReportDaoProvider = PaymentSummaryReportDaoProvider._();

final class PaymentSummaryReportDaoProvider
    extends
        $FunctionalProvider<
          PaymentSummaryReportDao,
          PaymentSummaryReportDao,
          PaymentSummaryReportDao
        >
    with $Provider<PaymentSummaryReportDao> {
  PaymentSummaryReportDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentSummaryReportDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentSummaryReportDaoHash();

  @$internal
  @override
  $ProviderElement<PaymentSummaryReportDao> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PaymentSummaryReportDao create(Ref ref) {
    return paymentSummaryReportDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaymentSummaryReportDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaymentSummaryReportDao>(value),
    );
  }
}

String _$paymentSummaryReportDaoHash() =>
    r'2ba936face0e119fdf5d4ae6fb418f33362eed44';
