import 'dart:ffi' as ffi;

import 'package:dylib/dylib.dart';

import 'package:flutter_rtklib/src/rcv/ublox_bindings.dart' as ubx;

class UbloxImpl {
  late final ubx.Ublox ublox;
  final _path = resolveDylibPath(
    'rtklib', // foo.dll vs. libfoo.so vs. libfoo.dylib
    dartDefine: 'LIBFOO_PATH',
    environmentVariable: 'LIBFOO_PATH',
  );
  UbloxImpl() {
    ublox = ubx.Ublox(ffi.DynamicLibrary.open(_path));
  }
}
