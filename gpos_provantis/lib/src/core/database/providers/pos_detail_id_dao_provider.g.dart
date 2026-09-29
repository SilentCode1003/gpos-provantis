// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_detail_id_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(posDetailIdDao)
final posDetailIdDaoProvider = PosDetailIdDaoProvider._();

final class PosDetailIdDaoProvider
    extends $FunctionalProvider<PosDetailIdDao, PosDetailIdDao, PosDetailIdDao>
    with $Provider<PosDetailIdDao> {
  PosDetailIdDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'posDetailIdDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$posDetailIdDaoHash();

  @$internal
  @override
  $ProviderElement<PosDetailIdDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PosDetailIdDao create(Ref ref) {
    return posDetailIdDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PosDetailIdDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PosDetailIdDao>(value),
    );
  }
}

String _$posDetailIdDaoHash() => r'bd4a8f75cecbba0a435829c8551ef78a91d9a440';
