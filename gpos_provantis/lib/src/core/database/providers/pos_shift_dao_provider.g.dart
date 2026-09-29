// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_shift_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(posShiftDao)
final posShiftDaoProvider = PosShiftDaoProvider._();

final class PosShiftDaoProvider
    extends $FunctionalProvider<PosShiftDao, PosShiftDao, PosShiftDao>
    with $Provider<PosShiftDao> {
  PosShiftDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'posShiftDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$posShiftDaoHash();

  @$internal
  @override
  $ProviderElement<PosShiftDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PosShiftDao create(Ref ref) {
    return posShiftDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PosShiftDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PosShiftDao>(value),
    );
  }
}

String _$posShiftDaoHash() => r'db1e13b0c1d5838e883fa2386ffa1d371a9e321b';
