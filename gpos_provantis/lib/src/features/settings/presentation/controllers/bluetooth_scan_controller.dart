import 'dart:async';

import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/services/printing/bluetooth_printing.dart';

part 'bluetooth_scan_controller.g.dart';

class BluetoothScanState {
  const BluetoothScanState({
    this.isScanning = false,
    this.devices = const [],
    this.error,
  });

  final bool isScanning;
  final List<Printer> devices;
  final String? error;

  BluetoothScanState copyWith({
    bool? isScanning,
    List<Printer>? devices,
    String? error,
    bool clearError = false,
  }) => BluetoothScanState(
    isScanning: isScanning ?? this.isScanning,
    devices: devices ?? this.devices,
    error: clearError ? null : (error ?? this.error),
  );
}

@riverpod
class BluetoothScanController extends _$BluetoothScanController {
  /// BLE scans run until stopped, which drains battery. Stop automatically.
  static const _scanTimeout = Duration(seconds: 20);

  final _service = BluetoothPrinterService();
  StreamSubscription<List<Printer>>? _subscription;
  Timer? _timeout;
  bool _disposed = false;

  @override
  BluetoothScanState build() {
    ref.onDispose(() {
      _disposed = true;
      _timeout?.cancel();
      _subscription?.cancel();
      _service.stopScan();
    });
    return const BluetoothScanState();
  }

  /// The plugin shares one device stream across USB and BLE, and a BLE scan
  /// also picks up headphones, watches, etc. Keep only named BLE devices.
  List<Printer> _bleOnly(List<Printer> all) => all
      .where(
        (p) =>
            p.connectionType == ConnectionType.BLE &&
            (p.name ?? '').trim().isNotEmpty,
      )
      .toList();

  Future<void> start() async {
    _timeout?.cancel();
    await _subscription?.cancel();
    state = const BluetoothScanState(isScanning: true);

    _subscription = _service.devicesStream.listen((devices) {
      if (_disposed) return;
      state = state.copyWith(devices: _bleOnly(devices));
    });

    try {
      await _service.scan();
      if (_disposed) return;
      _timeout = Timer(_scanTimeout, stop);
    } catch (e) {
      await _subscription?.cancel();
      _subscription = null;
      if (_disposed) return;
      state = BluetoothScanState(
        error:
            'Could not start the Bluetooth scan. Make sure Bluetooth is on '
            'and the app has permission to use it. ($e)',
      );
    }
  }

  void stop() {
    _timeout?.cancel();
    _timeout = null;
    _subscription?.cancel();
    _subscription = null;
    _service.stopScan();
    if (!_disposed) {
      state = state.copyWith(isScanning: false);
    }
  }
}
