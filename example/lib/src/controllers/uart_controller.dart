import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:get/get.dart';

class UartController extends GetxController {
  final _ports = <String, SerialPort>{};
  final availablePorts = Rx<List<String>>([]);

  @override
  void onInit() {
    super.onInit();
    updateAvailablePorts();
  }

  @override
  void onClose() {
    for (int i = 0; i < _ports.length; i++) {
      final p = _ports[i]!;
      p.dispose();
    }
    _ports.clear();
    super.onClose();
  }

  void updateAvailablePorts() {
    availablePorts.value = SerialPort.availablePorts;
  }

  SerialPort getPort(String address) {
    final port = _ports.putIfAbsent(address, () => SerialPort(address));
    return port;
  }
}

extension IntToString on int {
  String toHex() => '0x${toRadixString(16)}';
  String toPadded([int width = 3]) => toString().padLeft(width, '0');
  String toTransport() {
    switch (this) {
      case SerialPortTransport.usb:
        return 'USB';
      case SerialPortTransport.bluetooth:
        return 'Bluetooth';
      case SerialPortTransport.native:
        return 'Native';
      default:
        return 'Unknown';
    }
  }
}
