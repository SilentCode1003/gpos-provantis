// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'split_payment_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(splitPaymentDao)
final splitPaymentDaoProvider = SplitPaymentDaoProvider._();

final class SplitPaymentDaoProvider
    extends
        $FunctionalProvider<SplitPaymentDao, SplitPaymentDao, SplitPaymentDao>
    with $Provider<SplitPaymentDao> {
  SplitPaymentDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splitPaymentDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splitPaymentDaoHash();

  @$internal
  @override
  $ProviderElement<SplitPaymentDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SplitPaymentDao create(Ref ref) {
    return splitPaymentDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SplitPaymentDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SplitPaymentDao>(value),
    );
  }
}

String _$splitPaymentDaoHash() => r'f5c0b7ac2ff5498dccae33c0c4aab93720aeaa69';
