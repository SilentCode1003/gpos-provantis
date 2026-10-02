// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_package_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(servicePackageDao)
final servicePackageDaoProvider = ServicePackageDaoProvider._();

final class ServicePackageDaoProvider
    extends
        $FunctionalProvider<
          ServicePackageDao,
          ServicePackageDao,
          ServicePackageDao
        >
    with $Provider<ServicePackageDao> {
  ServicePackageDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'servicePackageDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$servicePackageDaoHash();

  @$internal
  @override
  $ProviderElement<ServicePackageDao> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ServicePackageDao create(Ref ref) {
    return servicePackageDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServicePackageDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServicePackageDao>(value),
    );
  }
}

String _$servicePackageDaoHash() => r'2478d5213c8767615b9900ac64492ab6a3904444';
