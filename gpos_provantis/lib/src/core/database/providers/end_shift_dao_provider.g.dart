// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'end_shift_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(endShiftDao)
final endShiftDaoProvider = EndShiftDaoProvider._();

final class EndShiftDaoProvider
    extends $FunctionalProvider<EndShiftDao, EndShiftDao, EndShiftDao>
    with $Provider<EndShiftDao> {
  EndShiftDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'endShiftDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$endShiftDaoHash();

  @$internal
  @override
  $ProviderElement<EndShiftDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EndShiftDao create(Ref ref) {
    return endShiftDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EndShiftDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EndShiftDao>(value),
    );
  }
}

String _$endShiftDaoHash() => r'bac852d372c0f756e2970f04b00f2ab619675ea1';
