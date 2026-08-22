// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employees_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EmployeesController)
final employeesControllerProvider = EmployeesControllerProvider._();

final class EmployeesControllerProvider
    extends $StreamNotifierProvider<EmployeesController, List<EmployeesModel>> {
  EmployeesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeesControllerHash();

  @$internal
  @override
  EmployeesController create() => EmployeesController();
}

String _$employeesControllerHash() =>
    r'c5a81967b058119fb9278fa0887cbf282551e565';

abstract class _$EmployeesController
    extends $StreamNotifier<List<EmployeesModel>> {
  Stream<List<EmployeesModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<EmployeesModel>>, List<EmployeesModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<EmployeesModel>>,
                List<EmployeesModel>
              >,
              AsyncValue<List<EmployeesModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
