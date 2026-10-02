// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_package_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(servicePackageRepository)
final servicePackageRepositoryProvider = ServicePackageRepositoryProvider._();

final class ServicePackageRepositoryProvider
    extends
        $FunctionalProvider<
          ServicePackageRepository,
          ServicePackageRepository,
          ServicePackageRepository
        >
    with $Provider<ServicePackageRepository> {
  ServicePackageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'servicePackageRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$servicePackageRepositoryHash();

  @$internal
  @override
  $ProviderElement<ServicePackageRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ServicePackageRepository create(Ref ref) {
    return servicePackageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServicePackageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServicePackageRepository>(value),
    );
  }
}

String _$servicePackageRepositoryHash() =>
    r'1bac77319875b5b633882450782ef7d8f7aa076b';
