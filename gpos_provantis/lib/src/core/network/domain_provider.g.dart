// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'domain_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DAO provider for DomainConfigTable, used both by the setup flow (to
/// write the domain) and by [activeDomainProvider] (to read it).

@ProviderFor(domainConfigDao)
final domainConfigDaoProvider = DomainConfigDaoProvider._();

/// DAO provider for DomainConfigTable, used both by the setup flow (to
/// write the domain) and by [activeDomainProvider] (to read it).

final class DomainConfigDaoProvider
    extends
        $FunctionalProvider<DomainConfigDao, DomainConfigDao, DomainConfigDao>
    with $Provider<DomainConfigDao> {
  /// DAO provider for DomainConfigTable, used both by the setup flow (to
  /// write the domain) and by [activeDomainProvider] (to read it).
  DomainConfigDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'domainConfigDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$domainConfigDaoHash();

  @$internal
  @override
  $ProviderElement<DomainConfigDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DomainConfigDao create(Ref ref) {
    return domainConfigDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DomainConfigDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DomainConfigDao>(value),
    );
  }
}

String _$domainConfigDaoHash() => r'515dc34eff124926f3e0e26e3a69744efcb65500';

/// Streams the currently configured domain (e.g. 'https://mystore.com')
/// from the local database. `apiClient` watches this to build its baseUrl,
/// so as soon as setup saves a new domain, any Dio calls made afterward
/// automatically pick it up — no manual provider invalidation needed.
///
/// Value is null before setup has ever run.

@ProviderFor(activeDomain)
final activeDomainProvider = ActiveDomainProvider._();

/// Streams the currently configured domain (e.g. 'https://mystore.com')
/// from the local database. `apiClient` watches this to build its baseUrl,
/// so as soon as setup saves a new domain, any Dio calls made afterward
/// automatically pick it up — no manual provider invalidation needed.
///
/// Value is null before setup has ever run.

final class ActiveDomainProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, Stream<String?>>
    with $FutureModifier<String?>, $StreamProvider<String?> {
  /// Streams the currently configured domain (e.g. 'https://mystore.com')
  /// from the local database. `apiClient` watches this to build its baseUrl,
  /// so as soon as setup saves a new domain, any Dio calls made afterward
  /// automatically pick it up — no manual provider invalidation needed.
  ///
  /// Value is null before setup has ever run.
  ActiveDomainProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeDomainProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeDomainHash();

  @$internal
  @override
  $StreamProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<String?> create(Ref ref) {
    return activeDomain(ref);
  }
}

String _$activeDomainHash() => r'7105452e8761e622a430082a7e1c7609bfbccd48';
