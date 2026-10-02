// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(serviceDao)
final serviceDaoProvider = ServiceDaoProvider._();

final class ServiceDaoProvider
    extends $FunctionalProvider<ServiceDao, ServiceDao, ServiceDao>
    with $Provider<ServiceDao> {
  ServiceDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serviceDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serviceDaoHash();

  @$internal
  @override
  $ProviderElement<ServiceDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ServiceDao create(Ref ref) {
    return serviceDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServiceDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServiceDao>(value),
    );
  }
}

String _$serviceDaoHash() => r'9fb62712151f22ff0d053003616ede67812cd695';
