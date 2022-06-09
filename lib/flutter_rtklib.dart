// flutter_rtklib
library flutter_rtklib;

import 'package:flutter_rtklib/flutter_rtklib_method_channel.dart';
import 'package:flutter_rtklib/src/bindings/rtklib.dart';
export 'src/rcv/ublox/ublox.dart';
export 'src/rtklib_bindings.dart' hide RtkDylib;
export 'src/bindings/windows_overrides.dart';
export 'ffi_extensions.dart';

class FlutterRtklib extends MethodChannelFlutterRtklib{
  static RtkLib getRtkLibInstance({int? traceLevel}) {
    return RtkLib.getInstance(traceLevel: traceLevel);
  }
}
