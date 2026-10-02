// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(serviceRepository)
final serviceRepositoryProvider = ServiceRepositoryProvider._();

final class ServiceRepositoryProvider
    extends
        $FunctionalProvider<
          ServiceRepository,
          ServiceRepository,
          ServiceRepository
        >
    with $Provider<ServiceRepository> {
  ServiceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serviceRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serviceRepositoryHash();

  @$internal
  @override
  $ProviderElement<ServiceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ServiceRepository create(Ref ref) {
    return serviceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServiceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServiceRepository>(value),
    );
  }
}

String _$serviceRepositoryHash() => r'f8372cf1a83f3800503188dcda2acff8e5f14a4d';
