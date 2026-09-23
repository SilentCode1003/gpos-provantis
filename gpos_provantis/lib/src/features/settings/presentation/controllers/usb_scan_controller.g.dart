// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usb_scan_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Transient USB-scan state for the add/edit printer sheet.
///
/// This is the Riverpod equivalent of the old GetX app's
/// `startUsbScan` / `stopUsbScan` / `scannedUsbDevices` / `isScanningUsb`,
/// which lived on the app-wide `SettingsController` there because GetX
/// controllers are long-lived singletons anyway. Here that same state
/// would be an awkward fit on `SettingsController` — that controller's
/// job is the saved printer list (`AsyncNotifier<List<PrinterDto>>`), and
/// a live-updating scan stream doesn't belong alongside it. Instead this
/// is its own provider, `autoDispose` so scanning stops and the found
/// devices are forgotten the moment the printer-form sheet that started
/// it closes — you never come back to Settings later and find a scan
/// still silently running.
///
/// Cleanup is automatic: once the form sheet stops watching/reading this
/// provider (i.e. it's popped), Riverpod disposes this notifier and
/// `ref.onDispose` below cancels the stream subscription. The widget side
/// deliberately does NOT call `.stop()` from its own `dispose()` — using
/// `ref` inside a `State.dispose()` is unsafe, since the provider may
/// already be gone by the time that runs.

@ProviderFor(UsbScanController)
final usbScanControllerProvider = UsbScanControllerProvider._();

/// Transient USB-scan state for the add/edit printer sheet.
///
/// This is the Riverpod equivalent of the old GetX app's
/// `startUsbScan` / `stopUsbScan` / `scannedUsbDevices` / `isScanningUsb`,
/// which lived on the app-wide `SettingsController` there because GetX
/// controllers are long-lived singletons anyway. Here that same state
/// would be an awkward fit on `SettingsController` — that controller's
/// job is the saved printer list (`AsyncNotifier<List<PrinterDto>>`), and
/// a live-updating scan stream doesn't belong alongside it. Instead this
/// is its own provider, `autoDispose` so scanning stops and the found
/// devices are forgotten the moment the printer-form sheet that started
/// it closes — you never come back to Settings later and find a scan
/// still silently running.
///
/// Cleanup is automatic: once the form sheet stops watching/reading this
/// provider (i.e. it's popped), Riverpod disposes this notifier and
/// `ref.onDispose` below cancels the stream subscription. The widget side
/// deliberately does NOT call `.stop()` from its own `dispose()` — using
/// `ref` inside a `State.dispose()` is unsafe, since the provider may
/// already be gone by the time that runs.
final class UsbScanControllerProvider
    extends $NotifierProvider<UsbScanController, UsbScanState> {
  /// Transient USB-scan state for the add/edit printer sheet.
  ///
  /// This is the Riverpod equivalent of the old GetX app's
  /// `startUsbScan` / `stopUsbScan` / `scannedUsbDevices` / `isScanningUsb`,
  /// which lived on the app-wide `SettingsController` there because GetX
  /// controllers are long-lived singletons anyway. Here that same state
  /// would be an awkward fit on `SettingsController` — that controller's
  /// job is the saved printer list (`AsyncNotifier<List<PrinterDto>>`), and
  /// a live-updating scan stream doesn't belong alongside it. Instead this
  /// is its own provider, `autoDispose` so scanning stops and the found
  /// devices are forgotten the moment the printer-form sheet that started
  /// it closes — you never come back to Settings later and find a scan
  /// still silently running.
  ///
  /// Cleanup is automatic: once the form sheet stops watching/reading this
  /// provider (i.e. it's popped), Riverpod disposes this notifier and
  /// `ref.onDispose` below cancels the stream subscription. The widget side
  /// deliberately does NOT call `.stop()` from its own `dispose()` — using
  /// `ref` inside a `State.dispose()` is unsafe, since the provider may
  /// already be gone by the time that runs.
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

/// Transient USB-scan state for the add/edit printer sheet.
///
/// This is the Riverpod equivalent of the old GetX app's
/// `startUsbScan` / `stopUsbScan` / `scannedUsbDevices` / `isScanningUsb`,
/// which lived on the app-wide `SettingsController` there because GetX
/// controllers are long-lived singletons anyway. Here that same state
/// would be an awkward fit on `SettingsController` — that controller's
/// job is the saved printer list (`AsyncNotifier<List<PrinterDto>>`), and
/// a live-updating scan stream doesn't belong alongside it. Instead this
/// is its own provider, `autoDispose` so scanning stops and the found
/// devices are forgotten the moment the printer-form sheet that started
/// it closes — you never come back to Settings later and find a scan
/// still silently running.
///
/// Cleanup is automatic: once the form sheet stops watching/reading this
/// provider (i.e. it's popped), Riverpod disposes this notifier and
/// `ref.onDispose` below cancels the stream subscription. The widget side
/// deliberately does NOT call `.stop()` from its own `dispose()` — using
/// `ref` inside a `State.dispose()` is unsafe, since the provider may
/// already be gone by the time that runs.

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
