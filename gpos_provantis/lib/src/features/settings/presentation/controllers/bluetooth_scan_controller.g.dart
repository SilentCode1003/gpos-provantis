// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bluetooth_scan_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BluetoothScanController)
final bluetoothScanControllerProvider = BluetoothScanControllerProvider._();

final class BluetoothScanControllerProvider
    extends $NotifierProvider<BluetoothScanController, BluetoothScanState> {
  BluetoothScanControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bluetoothScanControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bluetoothScanControllerHash();

  @$internal
  @override
  BluetoothScanController create() => BluetoothScanController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BluetoothScanState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BluetoothScanState>(value),
    );
  }
}

String _$bluetoothScanControllerHash() =>
    r'40fd20566d6dcce51e0b47a38b3d56ae6c91f194';

abstract class _$BluetoothScanController extends $Notifier<BluetoothScanState> {
  BluetoothScanState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<BluetoothScanState, BluetoothScanState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BluetoothScanState, BluetoothScanState>,
              BluetoothScanState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
