// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_config_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(posConfigDao)
final posConfigDaoProvider = PosConfigDaoProvider._();

final class PosConfigDaoProvider
    extends $FunctionalProvider<PosConfigDao, PosConfigDao, PosConfigDao>
    with $Provider<PosConfigDao> {
  PosConfigDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'posConfigDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$posConfigDaoHash();

  @$internal
  @override
  $ProviderElement<PosConfigDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PosConfigDao create(Ref ref) {
    return posConfigDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PosConfigDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PosConfigDao>(value),
    );
  }
}

String _$posConfigDaoHash() => r'cb6000c31c34201447cfaef5ba9d02dd3c775024';
