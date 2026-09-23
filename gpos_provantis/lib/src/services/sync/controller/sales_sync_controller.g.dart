// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_sync_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SalesSyncController)
final salesSyncControllerProvider = SalesSyncControllerProvider._();

final class SalesSyncControllerProvider
    extends $NotifierProvider<SalesSyncController, SalesSyncState> {
  SalesSyncControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salesSyncControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salesSyncControllerHash();

  @$internal
  @override
  SalesSyncController create() => SalesSyncController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SalesSyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SalesSyncState>(value),
    );
  }
}

String _$salesSyncControllerHash() =>
    r'43b9b40d129ad1a054f81aa2537c592f2fb811a8';

abstract class _$SalesSyncController extends $Notifier<SalesSyncState> {
  SalesSyncState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SalesSyncState, SalesSyncState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SalesSyncState, SalesSyncState>,
              SalesSyncState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
