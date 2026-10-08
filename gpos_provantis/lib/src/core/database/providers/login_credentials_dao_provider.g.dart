// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_credentials_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(loginCredentialsDao)
final loginCredentialsDaoProvider = LoginCredentialsDaoProvider._();

final class LoginCredentialsDaoProvider
    extends
        $FunctionalProvider<
          LoginCredentialsDao,
          LoginCredentialsDao,
          LoginCredentialsDao
        >
    with $Provider<LoginCredentialsDao> {
  LoginCredentialsDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginCredentialsDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginCredentialsDaoHash();

  @$internal
  @override
  $ProviderElement<LoginCredentialsDao> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LoginCredentialsDao create(Ref ref) {
    return loginCredentialsDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoginCredentialsDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoginCredentialsDao>(value),
    );
  }
}

String _$loginCredentialsDaoHash() =>
    r'd6285a25a2ac71f3de5cb594f5b80d5a2127ddcd';
