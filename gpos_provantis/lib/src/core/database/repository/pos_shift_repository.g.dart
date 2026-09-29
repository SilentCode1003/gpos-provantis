// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_shift_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(posShiftRepository)
final posShiftRepositoryProvider = PosShiftRepositoryProvider._();

final class PosShiftRepositoryProvider
    extends
        $FunctionalProvider<
          PosShiftRepository,
          PosShiftRepository,
          PosShiftRepository
        >
    with $Provider<PosShiftRepository> {
  PosShiftRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'posShiftRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$posShiftRepositoryHash();

  @$internal
  @override
  $ProviderElement<PosShiftRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PosShiftRepository create(Ref ref) {
    return posShiftRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PosShiftRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PosShiftRepository>(value),
    );
  }
}

String _$posShiftRepositoryHash() =>
    r'49491f8a215e24941b3301374f219aaf5a5869d2';
