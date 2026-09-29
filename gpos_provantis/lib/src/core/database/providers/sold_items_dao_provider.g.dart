// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sold_items_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(soldItemsDao)
final soldItemsDaoProvider = SoldItemsDaoProvider._();

final class SoldItemsDaoProvider
    extends $FunctionalProvider<SoldItemsDao, SoldItemsDao, SoldItemsDao>
    with $Provider<SoldItemsDao> {
  SoldItemsDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soldItemsDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soldItemsDaoHash();

  @$internal
  @override
  $ProviderElement<SoldItemsDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SoldItemsDao create(Ref ref) {
    return soldItemsDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoldItemsDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SoldItemsDao>(value),
    );
  }
}

String _$soldItemsDaoHash() => r'878da5ce1732854a95b4174d0a227c0949c807a8';
