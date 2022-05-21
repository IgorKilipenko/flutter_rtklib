import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:flutter_rtklib/src/rtklib_bindings.dart';
//import 'package:flutter_rtklib/src/rcv/ublox_bindings.dart';
import 'package:dylib/dylib.dart';

RtkLib? _dylibRtklib;
RtkLib get dylibRtklib {
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

  return _dylibRtklib!;
}
