// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_history_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(receiptHistoryDao)
final receiptHistoryDaoProvider = ReceiptHistoryDaoProvider._();

final class ReceiptHistoryDaoProvider
    extends
        $FunctionalProvider<
          ReceiptHistoryDao,
          ReceiptHistoryDao,
          ReceiptHistoryDao
        >
    with $Provider<ReceiptHistoryDao> {
  ReceiptHistoryDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'receiptHistoryDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$receiptHistoryDaoHash();

  @$internal
  @override
  $ProviderElement<ReceiptHistoryDao> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReceiptHistoryDao create(Ref ref) {
    return receiptHistoryDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReceiptHistoryDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReceiptHistoryDao>(value),
    );
  }
}

String _$receiptHistoryDaoHash() => r'286309509fcbf96f0741d0dfbc308024b0ce2d95';
