// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usb_scan_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UsbScanController)
final usbScanControllerProvider = UsbScanControllerProvider._();

final class UsbScanControllerProvider
    extends $NotifierProvider<UsbScanController, UsbScanState> {
  UsbScanControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usbScanControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usbScanControllerHash();

  @$internal
  @override
  UsbScanController create() => UsbScanController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UsbScanState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UsbScanState>(value),
    );
  }
}

String _$usbScanControllerHash() => r'05cd8a006642f95b316046d08d57b97ca3472458';

abstract class _$UsbScanController extends $Notifier<UsbScanState> {
  UsbScanState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<UsbScanState, UsbScanState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UsbScanState, UsbScanState>,
              UsbScanState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
