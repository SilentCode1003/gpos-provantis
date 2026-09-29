import 'dart:async';

import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/services/printing/usb_printing.dart';

part 'usb_scan_controller.g.dart';

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

  Future<void> start() async {
    await _subscription?.cancel();
    state = const UsbScanState(isScanning: true, devices: []);

    _subscription = _service.devicesStream.listen((devices) {
      state = state.copyWith(devices: devices);
    });

    await _service.scan();
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
    state = state.copyWith(isScanning: false);
  }
}
