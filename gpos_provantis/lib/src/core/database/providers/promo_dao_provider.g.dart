// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(promoDao)
final promoDaoProvider = PromoDaoProvider._();

final class PromoDaoProvider
    extends $FunctionalProvider<PromoDao, PromoDao, PromoDao>
    with $Provider<PromoDao> {
  PromoDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'promoDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$promoDaoHash();

  @$internal
  @override
  $ProviderElement<PromoDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PromoDao create(Ref ref) {
    return promoDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PromoDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PromoDao>(value),
    );
  }
}

String _$promoDaoHash() => r'1ccb9444008f4a167b64be6fd8661ab76237c0c7';
