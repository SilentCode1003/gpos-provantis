// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_config_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(branchConfigDao)
final branchConfigDaoProvider = BranchConfigDaoProvider._();

final class BranchConfigDaoProvider
    extends
        $FunctionalProvider<BranchConfigDao, BranchConfigDao, BranchConfigDao>
    with $Provider<BranchConfigDao> {
  BranchConfigDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'branchConfigDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$branchConfigDaoHash();

  @$internal
  @override
  $ProviderElement<BranchConfigDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BranchConfigDao create(Ref ref) {
    return branchConfigDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BranchConfigDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BranchConfigDao>(value),
    );
  }
}

String _$branchConfigDaoHash() => r'9ff9431a1f0332aaa7424b6e04a93397b18e7fac';
