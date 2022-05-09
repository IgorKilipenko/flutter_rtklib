import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:flutter_rtklib/src/rtklib_bindings.dart';
//import 'package:flutter_rtklib/src/rcv/ublox_bindings.dart';
import 'package:dylib/dylib.dart';
import 'package:path/path.dart' as p;

RtkLib? _dylibRtklib;
RtkLib get dylibRtklib {
  if (_dylibRtklib != null) return _dylibRtklib!;

  String? path;
  if (Platform.environment.containsKey("FLUTTER_TEST")) {
    final script = File(Platform.script.path
        .replaceFirst(RegExp(r'^[/\\]+'), "")
        .replaceAll(RegExp(r'\\+'), "/"));
    path = p.join(script.parent.path, "example/build/windows/runner/Debug").replaceAll(RegExp(r'^\\+'), "/");
  }
  _dylibRtklib = RtkLib(ffi.DynamicLibrary.open(
    resolveDylibPath(
      'rtklib',
      //path: resolvedExecutable.parent.path,
      path: path,
      dartDefine: 'RTKLIB_PATH',
      environmentVariable: 'RTKLIB_PATH',
    ),
  ));

  return _dylibRtklib!;
}
