// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_reports_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CashReportsController)
final cashReportsControllerProvider = CashReportsControllerProvider._();

final class CashReportsControllerProvider
    extends $NotifierProvider<CashReportsController, CashReportsState> {
  CashReportsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cashReportsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cashReportsControllerHash();

  @$internal
  @override
  CashReportsController create() => CashReportsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CashReportsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CashReportsState>(value),
    );
  }
}

String _$cashReportsControllerHash() =>
    r'05376638e667301a5fceccc077e05d5a7b40a3ec';

abstract class _$CashReportsController extends $Notifier<CashReportsState> {
  CashReportsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CashReportsState, CashReportsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CashReportsState, CashReportsState>,
              CashReportsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
