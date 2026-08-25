// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userDataRepository)
final userDataRepositoryProvider = UserDataRepositoryProvider._();

final class UserDataRepositoryProvider
    extends
        $FunctionalProvider<
          UserDataRepository,
          UserDataRepository,
          UserDataRepository
        >
    with $Provider<UserDataRepository> {
  UserDataRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userDataRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userDataRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserDataRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserDataRepository create(Ref ref) {
    return userDataRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserDataRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserDataRepository>(value),
    );
  }
}

String _$userDataRepositoryHash() =>
    r'6416d92a152b6b2f3ef9bdc0ea6cab0d2b7b6645';
