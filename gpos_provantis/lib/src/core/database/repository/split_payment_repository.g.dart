// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'split_payment_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(splitPaymentRepository)
final splitPaymentRepositoryProvider = SplitPaymentRepositoryProvider._();

final class SplitPaymentRepositoryProvider
    extends
        $FunctionalProvider<
          SplitPaymentRepository,
          SplitPaymentRepository,
          SplitPaymentRepository
        >
    with $Provider<SplitPaymentRepository> {
  SplitPaymentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splitPaymentRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splitPaymentRepositoryHash();

  @$internal
  @override
  $ProviderElement<SplitPaymentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SplitPaymentRepository create(Ref ref) {
    return splitPaymentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SplitPaymentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SplitPaymentRepository>(value),
    );
  }
}

String _$splitPaymentRepositoryHash() =>
    r'22a237d68fa00581989fe5073fbd301e6af8f190';
