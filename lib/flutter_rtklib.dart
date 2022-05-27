// flutter_rtklib
library flutter_rtklib;

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_rtklib/src/bindings/rtklib.dart';
export 'src/rcv/ublox/ublox.dart';
//export 'src/bindings/rtklib.dart';
export 'src/rtklib_bindings.dart' hide RtkDylib;
export 'src/bindings/windows_overrides.dart';
export 'ffi_extensions.dart';

class FlutterRtklib {
  static const MethodChannel _channel = MethodChannel('flutter_rtklib');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static RtkLib getRtkLibInstance({int? traceLevel}) {
    return RtkLib.getInstance(traceLevel: traceLevel);
  }
}
