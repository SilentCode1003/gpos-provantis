// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'end_shift_report_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(endShiftRepository)
final endShiftRepositoryProvider = EndShiftRepositoryProvider._();

final class EndShiftRepositoryProvider
    extends
        $FunctionalProvider<
          EndShiftRepository,
          EndShiftRepository,
          EndShiftRepository
        >
    with $Provider<EndShiftRepository> {
  EndShiftRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'endShiftRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$endShiftRepositoryHash();

  @$internal
  @override
  $ProviderElement<EndShiftRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EndShiftRepository create(Ref ref) {
    return endShiftRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EndShiftRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EndShiftRepository>(value),
    );
  }
}

String _$endShiftRepositoryHash() =>
    r'357460dfa4995107e49362d2e23c6dc9a23a1a7e';
