// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refund_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(refundRepository)
final refundRepositoryProvider = RefundRepositoryProvider._();

final class RefundRepositoryProvider
    extends
        $FunctionalProvider<
          RefundRepository,
          RefundRepository,
          RefundRepository
        >
    with $Provider<RefundRepository> {
  RefundRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refundRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refundRepositoryHash();

  @$internal
  @override
  $ProviderElement<RefundRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RefundRepository create(Ref ref) {
    return refundRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RefundRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RefundRepository>(value),
    );
  }
}

String _$refundRepositoryHash() => r'207654d631d0577b19f36c66e1ba03604356822f';
