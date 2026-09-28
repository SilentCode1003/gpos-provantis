// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_drawer_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cashDrawerDao)
final cashDrawerDaoProvider = CashDrawerDaoProvider._();

final class CashDrawerDaoProvider
    extends $FunctionalProvider<CashDrawerDao, CashDrawerDao, CashDrawerDao>
    with $Provider<CashDrawerDao> {
  CashDrawerDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cashDrawerDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cashDrawerDaoHash();

  @$internal
  @override
  $ProviderElement<CashDrawerDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CashDrawerDao create(Ref ref) {
    return cashDrawerDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CashDrawerDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CashDrawerDao>(value),
    );
  }
}

String _$cashDrawerDaoHash() => r'e8b87c713383225541eeaa8b7b747d9fff5c3546';
