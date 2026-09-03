// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_detail_id_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(posDetailIdRepository)
final posDetailIdRepositoryProvider = PosDetailIdRepositoryProvider._();

final class PosDetailIdRepositoryProvider
    extends
        $FunctionalProvider<
          PosDetailIdRepository,
          PosDetailIdRepository,
          PosDetailIdRepository
        >
    with $Provider<PosDetailIdRepository> {
  PosDetailIdRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'posDetailIdRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$posDetailIdRepositoryHash();

  @$internal
  @override
  $ProviderElement<PosDetailIdRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PosDetailIdRepository create(Ref ref) {
    return posDetailIdRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PosDetailIdRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PosDetailIdRepository>(value),
    );
  }
}

String _$posDetailIdRepositoryHash() =>
    r'8ef1ef6f13d0d7265a4e71acc447025ee5fe73b9';
