// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_local_data_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(loginLocalDataSource)
final loginLocalDataSourceProvider = LoginLocalDataSourceProvider._();

final class LoginLocalDataSourceProvider
    extends
        $FunctionalProvider<
          LoginLocalDataSource,
          LoginLocalDataSource,
          LoginLocalDataSource
        >
    with $Provider<LoginLocalDataSource> {
  LoginLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<LoginLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LoginLocalDataSource create(Ref ref) {
    return loginLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoginLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoginLocalDataSource>(value),
    );
  }
}

String _$loginLocalDataSourceHash() =>
    r'f542b05c675a227f738a6eb0c2594262df8f4edf';
