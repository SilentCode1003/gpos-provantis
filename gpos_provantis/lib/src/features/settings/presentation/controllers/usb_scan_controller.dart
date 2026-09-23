import 'dart:async';

import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/services/printing/usb_printing.dart';

part 'usb_scan_controller.g.dart';

/// State for an in-progress (or idle) USB printer scan.
class UsbScanState {
  const UsbScanState({this.isScanning = false, this.devices = const []});

  final bool isScanning;
  final List<Printer> devices;

  UsbScanState copyWith({bool? isScanning, List<Printer>? devices}) =>
      UsbScanState(
        isScanning: isScanning ?? this.isScanning,
        devices: devices ?? this.devices,
      );
}

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
@riverpod
class UsbScanController extends _$UsbScanController {
  final _service = UsbPrinterService();
  StreamSubscription<List<Printer>>? _subscription;

  @override
  UsbScanState build() {
    ref.onDispose(() {
      _subscription?.cancel();
    });
    return const UsbScanState();
  }

  /// Starts (or restarts) a USB scan, clearing any previously found
  /// devices first.
  Future<void> start() async {
    await _subscription?.cancel();
    state = const UsbScanState(isScanning: true, devices: []);

    _subscription = _service.devicesStream.listen((devices) {
      state = state.copyWith(devices: devices);
    });

    await _service.scan();
  }

  /// Stops listening for new devices. Devices already found stay visible
  /// so the user can still pick one.
  void stop() {
    _subscription?.cancel();
    _subscription = null;
    state = state.copyWith(isScanning: false);
  }
}
