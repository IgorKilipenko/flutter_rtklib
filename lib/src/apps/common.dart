import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:flutter_rtklib/ffi_extensions.dart';

List<String> splitConsoleCmdAgs(String strCmd) {
  final str = strCmd.replaceAllMapped(
      RegExp(r'[\u0027\u0022]([^\s]+)\s+([^\s]+)[\u0027\u0022]', unicode: true),
      (math) => '"${math.group(1)}{space}${math.group(2)}"');
  final cmd = str
      .split(RegExp(r'\s+'))
      .map((e) => e.replaceAll(RegExp(r'\{space\}'), " "))
      .toList(growable: false);
  return cmd;
}

CStringArray parseConsoleCmd(String strCmd,
    {ffi.Allocator allocator = pkg_ffi.calloc}) {
  final cmd = splitConsoleCmdAgs(strCmd);
  final argVars = cmd.toNativeArray(allocator: allocator);
  return argVars;
}
