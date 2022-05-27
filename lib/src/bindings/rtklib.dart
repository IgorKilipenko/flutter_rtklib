import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:flutter/foundation.dart';
import 'package:flutter_rtklib/flutter_rtklib.dart';
import 'package:flutter_rtklib/src/apps/convbin.dart';
import 'package:flutter_rtklib/src/rtklib_bindings.dart';
import 'package:dylib/dylib.dart';

export 'package:flutter_rtklib/src/rtklib_bindings.dart';

part 'package:flutter_rtklib/src/dylib.dart';

typedef _WrappedPrintC = ffi.Void Function(ffi.Pointer<ffi.Char>, ffi.Uint64);
typedef PrintCallback = ffi.Pointer<
    ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Char>, ffi.Uint64)>>;
void _printDebug(ffi.Pointer<ffi.Char> str, int len) {
  final msg = str.cast<pkg_ffi.Utf8>().toDartString(length: len);
  // ignore: avoid_print
  print(msg);
}

final PrintCallback _printCallback =
    ffi.Pointer.fromFunction<_WrappedPrintC>(_printDebug);

class RtkLib extends RtkDylib {
  static UbloxImpl? _ubloxInstance;

  /// The symbols are looked up in [dynamicLibrary].
  RtkLib._(ffi.DynamicLibrary dynamicLibrary) : super(dynamicLibrary) {
    _init();
  }

  /// Get [RtkLib] instance.
  ///
  /// [traceLevel] - Level of the trace passed to RTKLIB
  factory RtkLib.getInstance({int? traceLevel}) {
    return _getDylibRtklib(traceLevel: traceLevel);
  }

  void _init() {
    initTrace();
    _ubloxInstance ??= UbloxImpl(this);
  }

  void initTrace({PrintCallback? printCallback, int? traceLevel}) {
    flutter_initialize(printCallback ?? _printCallback);
    set_level_trace(traceLevel ?? (kDebugMode ? 3 : 2));
  }

  UbloxImpl getUblox() {
    return _ubloxInstance!;
  }

  Convbin getConvbin() {
    return Convbin();
  }
}
