// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'split_payment_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(splitPaymentService)
final splitPaymentServiceProvider = SplitPaymentServiceProvider._();

final class SplitPaymentServiceProvider
    extends
        $FunctionalProvider<
          SplitPaymentService,
          SplitPaymentService,
          SplitPaymentService
        >
    with $Provider<SplitPaymentService> {
  SplitPaymentServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splitPaymentServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splitPaymentServiceHash();

  @$internal
  @override
  $ProviderElement<SplitPaymentService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SplitPaymentService create(Ref ref) {
    return splitPaymentService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SplitPaymentService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SplitPaymentService>(value),
    );
  }
}

String _$splitPaymentServiceHash() =>
    r'a0818b0ba3128738d69d86623b6bd8b9864de62a';
