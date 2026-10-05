// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_drop_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cashDropDao)
final cashDropDaoProvider = CashDropDaoProvider._();

final class CashDropDaoProvider
    extends $FunctionalProvider<CashDropDao, CashDropDao, CashDropDao>
    with $Provider<CashDropDao> {
  CashDropDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cashDropDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cashDropDaoHash();

  @$internal
  @override
  $ProviderElement<CashDropDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CashDropDao create(Ref ref) {
    return cashDropDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CashDropDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CashDropDao>(value),
    );
  }
}

String _$cashDropDaoHash() => r'8bfb0eeaf8b1d5abf5ec37e47cd3fe78d706622b';
