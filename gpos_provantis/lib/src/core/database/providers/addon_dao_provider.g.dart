// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addon_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(addonDao)
final addonDaoProvider = AddonDaoProvider._();

final class AddonDaoProvider
    extends $FunctionalProvider<AddonDao, AddonDao, AddonDao>
    with $Provider<AddonDao> {
  AddonDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addonDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addonDaoHash();

  @$internal
  @override
  $ProviderElement<AddonDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AddonDao create(Ref ref) {
    return addonDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddonDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddonDao>(value),
    );
  }
}

String _$addonDaoHash() => r'ebb0afb250fd0b8f06c1788900d2d7296f2ec3d4';
