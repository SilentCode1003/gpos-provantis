// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employees_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(employeesDao)
final employeesDaoProvider = EmployeesDaoProvider._();

final class EmployeesDaoProvider
    extends $FunctionalProvider<EmployeesDao, EmployeesDao, EmployeesDao>
    with $Provider<EmployeesDao> {
  EmployeesDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeesDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeesDaoHash();

  @$internal
  @override
  $ProviderElement<EmployeesDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EmployeesDao create(Ref ref) {
    return employeesDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmployeesDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmployeesDao>(value),
    );
  }
}

String _$employeesDaoHash() => r'b76c7494ed6756353fec417c0ab8f1b16aaeb7e8';
