// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employees_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(employeesRepository)
final employeesRepositoryProvider = EmployeesRepositoryProvider._();

final class EmployeesRepositoryProvider
    extends
        $FunctionalProvider<
          EmployeesRepository,
          EmployeesRepository,
          EmployeesRepository
        >
    with $Provider<EmployeesRepository> {
  EmployeesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeesRepositoryHash();

  @$internal
  @override
  $ProviderElement<EmployeesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EmployeesRepository create(Ref ref) {
    return employeesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmployeesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmployeesRepository>(value),
    );
  }
}

String _$employeesRepositoryHash() =>
    r'5261e7423a651711d2c710c2154cf79fab8c3635';
