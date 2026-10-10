// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mailer_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mailerService)
final mailerServiceProvider = MailerServiceProvider._();

final class MailerServiceProvider
    extends $FunctionalProvider<MailerService, MailerService, MailerService>
    with $Provider<MailerService> {
  MailerServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mailerServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mailerServiceHash();

  @$internal
  @override
  $ProviderElement<MailerService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MailerService create(Ref ref) {
    return mailerService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MailerService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MailerService>(value),
    );
  }
}

String _$mailerServiceHash() => r'b2c829992216f3e844688341f6435364a12d0588';
