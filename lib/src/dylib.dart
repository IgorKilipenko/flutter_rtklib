part of 'package:flutter_rtklib/src/bindings/rtklib.dart';

RtkLib? _dylibRtklib;
RtkLib _getDylibRtklib({int? traceLevel}) {
  if (_dylibRtklib != null) {
    final lib = _dylibRtklib!;
    if (traceLevel != null &&
        traceLevel >= 0 &&
        lib.gettracelevel() != traceLevel) {
      lib.tracelevel(traceLevel);
    }
    return lib;
  }

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

  final dl = ffi.DynamicLibrary.open(
    resolveDylibPath(
      'rtklib',
      path: path,
      dartDefine: 'RTKLIB_PATH',
      environmentVariable: 'RTKLIB_PATH',
    ),
  );

  _dylibRtklib = RtkLib._(dl);

  return _dylibRtklib!;
}
