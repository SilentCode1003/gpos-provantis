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
        $FunctionalProvider<
          DenominationsDao,
          DenominationsDao,
          DenominationsDao
        >
    with $Provider<DenominationsDao> {
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
  $ProviderElement<DenominationsDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DenominationsDao create(Ref ref) {
    return denominationsDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DenominationsDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DenominationsDao>(value),
    );
  }
}

String _$denominationsDaoHash() => r'ee0b74980e86c2e5f6026b343cd2633111279068';
