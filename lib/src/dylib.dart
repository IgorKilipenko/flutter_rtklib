import 'dart:ffi' as ffi;

import 'package:flutter_rtklib/src/rtklib_bindings.dart';
//import 'package:flutter_rtklib/src/rcv/ublox_bindings.dart';
import 'package:dylib/dylib.dart';

RtkLib? _dylibRtklib;
RtkLib get dylibRtklib {
  return _dylibRtklib ??= RtkLib(ffi.DynamicLibrary.open(
    resolveDylibPath(
      'rtklib',
      dartDefine: 'RTKLIB_PATH',
      environmentVariable: 'RTKLIB_PATH',
    ),
  ));
}

