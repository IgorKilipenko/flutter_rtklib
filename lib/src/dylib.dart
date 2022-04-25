import 'dart:ffi' as ffi;

import 'package:flutter_rtklib/src/rtklib_bindings.dart';
//import 'package:flutter_rtklib/src/rcv/ublox_bindings.dart';
import 'package:dylib/dylib.dart';

RtkLib? _dylibRtklib;
RtkLib get dylibRtklib {
  return _dylibRtklib ??= RtkLib(ffi.DynamicLibrary.open(
    resolveDylibPath(
      'rtklib',
      dartDefine: 'LIBSERIALPORT_PATH',
      environmentVariable: 'LIBSERIALPORT_PATH',
    ),
  ));
}

/*Ublox? _dylibUblox;
Ublox get dylibUblox {
  return _dylibUblox ??= Ublox(ffi.DynamicLibrary.open(
    resolveDylibPath(
      'rtklib',
      dartDefine: 'LIBSERIALPORT_PATH',
      environmentVariable: 'LIBSERIALPORT_PATH',
    ),
  ));
}*/

