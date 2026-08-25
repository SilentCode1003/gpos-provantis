// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_config_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(branchRepository)
final branchRepositoryProvider = BranchRepositoryProvider._();

final class BranchRepositoryProvider
    extends
        $FunctionalProvider<
          BranchRepository,
          BranchRepository,
          BranchRepository
        >
    with $Provider<BranchRepository> {
  BranchRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'branchRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$branchRepositoryHash();

  @$internal
  @override
  $ProviderElement<BranchRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BranchRepository create(Ref ref) {
    return branchRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BranchRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BranchRepository>(value),
    );
  }
}

String _$branchRepositoryHash() => r'44f505671bf2ec4b0303cfc3994d144acbf94353';
