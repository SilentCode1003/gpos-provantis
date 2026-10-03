// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_history_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(receiptHistoryRepository)
final receiptHistoryRepositoryProvider = ReceiptHistoryRepositoryProvider._();

final class ReceiptHistoryRepositoryProvider
    extends
        $FunctionalProvider<
          ReceiptHistoryRepository,
          ReceiptHistoryRepository,
          ReceiptHistoryRepository
        >
    with $Provider<ReceiptHistoryRepository> {
  ReceiptHistoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'receiptHistoryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$receiptHistoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReceiptHistoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReceiptHistoryRepository create(Ref ref) {
    return receiptHistoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReceiptHistoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReceiptHistoryRepository>(value),
    );
  }
}

String _$receiptHistoryRepositoryHash() =>
    r'4f0945e1aad81c8514aec0180dc4bd7b78b1ae32';
