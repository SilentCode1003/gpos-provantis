// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(emailDao)
final emailDaoProvider = EmailDaoProvider._();

final class EmailDaoProvider
    extends $FunctionalProvider<EmailDao, EmailDao, EmailDao>
    with $Provider<EmailDao> {
  EmailDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emailDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emailDaoHash();

  @$internal
  @override
  $ProviderElement<EmailDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EmailDao create(Ref ref) {
    return emailDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmailDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmailDao>(value),
    );
  }
}

String _$emailDaoHash() => r'd641f3615f585c3dcfd16ca70c7d154c5b09a8e4';
