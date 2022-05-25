import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:flutter/foundation.dart';
import 'package:flutter_rtklib/src/rtklib_bindings.dart';
//import 'package:flutter_rtklib/src/rcv/ublox_bindings.dart';
import 'package:dylib/dylib.dart';

typedef WrappedPrintC = ffi.Void Function(ffi.Pointer<ffi.Char>, ffi.Uint64);
void _printDebug(ffi.Pointer<ffi.Char> str, int len) {
  final msg = str.cast<pkg_ffi.Utf8>().toDartString(length: len);
  // ignore: avoid_print
  print(msg);
}

final _printCallback = ffi.Pointer.fromFunction<WrappedPrintC>(_printDebug);

RtkLib? _dylibRtklib;
RtkLib getDylibRtklib({int? traceLevel}) {
  if (_dylibRtklib != null) return _dylibRtklib!;

  String? path;
  if (Platform.environment.containsKey("FLUTTER_TEST")) {
    final script =
        File(Platform.script.toFilePath(windows: Platform.isWindows));
    String? platformSpecificPath;
    if (Platform.isLinux) {
      platformSpecificPath = "example/build/linux/x64/debug/bundle/lib";
    } else if (Platform.isWindows) {
      platformSpecificPath = "example/build/windows/runner/Debug";
    }

    if (platformSpecificPath != null) {
      final dir = Directory(
          '${script.parent.path.replaceFirst(RegExp(r'[/\\]example$'), "")}${Platform.pathSeparator}$platformSpecificPath');
      if (dir.existsSync()) {
        path = dir.path;
      }
    }
  }

  _dylibRtklib = RtkLib(ffi.DynamicLibrary.open(
    resolveDylibPath(
      'rtklib',
      path: path,
      dartDefine: 'RTKLIB_PATH',
      environmentVariable: 'RTKLIB_PATH',
    ),
  ));

  _dylibRtklib!.flutter_initialize(_printCallback);
  _dylibRtklib!.set_level_trace(traceLevel ?? (kDebugMode ? 3 : 2));

  return _dylibRtklib!;
}
