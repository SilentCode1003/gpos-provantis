// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'denominations_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(denominationsDao)
final denominationsDaoProvider = DenominationsDaoProvider._();

final class DenominationsDaoProvider
    extends
        $FunctionalProvider<DenominationDao, DenominationDao, DenominationDao>
    with $Provider<DenominationDao> {
  DenominationsDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'denominationsDaoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$denominationsDaoHash();

  @$internal
  @override
  $ProviderElement<DenominationDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DenominationDao create(Ref ref) {
    return denominationsDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DenominationDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DenominationDao>(value),
    );
  }
}

String _$denominationsDaoHash() => r'a2366af74275ce3e1a6f2621a618acfd3056eb6f';
