// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userDataDao)
final userDataDaoProvider = UserDataDaoProvider._();

final class UserDataDaoProvider
    extends $FunctionalProvider<UserDataDao, UserDataDao, UserDataDao>
    with $Provider<UserDataDao> {
  UserDataDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userDataDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userDataDaoHash();

  @$internal
  @override
  $ProviderElement<UserDataDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserDataDao create(Ref ref) {
    return userDataDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserDataDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserDataDao>(value),
    );
  }
}

String _$userDataDaoHash() => r'7ae34dcbc824c150662067ac4795312e39c1261c';
