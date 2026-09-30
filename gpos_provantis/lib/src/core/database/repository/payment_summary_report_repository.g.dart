// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_summary_report_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(paymentSummaryReportRepository)
final paymentSummaryReportRepositoryProvider =
    PaymentSummaryReportRepositoryProvider._();

final class PaymentSummaryReportRepositoryProvider
    extends
        $FunctionalProvider<
          PaymentSummaryReportRepository,
          PaymentSummaryReportRepository,
          PaymentSummaryReportRepository
        >
    with $Provider<PaymentSummaryReportRepository> {
  PaymentSummaryReportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentSummaryReportRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentSummaryReportRepositoryHash();

  @$internal
  @override
  $ProviderElement<PaymentSummaryReportRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PaymentSummaryReportRepository create(Ref ref) {
    return paymentSummaryReportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaymentSummaryReportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaymentSummaryReportRepository>(
        value,
      ),
    );
  }
}

String _$paymentSummaryReportRepositoryHash() =>
    r'f697adf5f90fc00ad86be5212a8ecc3529c0c93b';
