// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addon_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(addonRepository)
final addonRepositoryProvider = AddonRepositoryProvider._();

final class AddonRepositoryProvider
    extends
        $FunctionalProvider<AddonRepository, AddonRepository, AddonRepository>
    with $Provider<AddonRepository> {
  AddonRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addonRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addonRepositoryHash();

  @$internal
  @override
  $ProviderElement<AddonRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AddonRepository create(Ref ref) {
    return addonRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddonRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddonRepository>(value),
    );
  }
}

String _$addonRepositoryHash() => r'a5e86d0015a16250edb9135554a6c56a52644f5e';
