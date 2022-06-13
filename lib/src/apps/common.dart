import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

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

class CppRequest {
  final SendPort? replyPort;
  final int? pendingCall;
  final String method;
  final Uint8List data;

  factory CppRequest.fromCppMessage(List message) {
    return CppRequest._(message[0], message[1], message[2], message[3]);
  }

  CppRequest._(this.replyPort, this.pendingCall, this.method, this.data);

  @override
  String toString() => 'CppRequest(method: $method, ${data.length} bytes)';
}

class CppResponse {
  CppResponseMessage message;

  CppResponse(this.message);

  @override
  String toString() => 'CppResponse(message: ${message.data.length})';
}

class CppResponseMessage {
  final int pendingCall;
  final Uint8List data;
  CppResponseMessage({required this.pendingCall, required this.data});
  List<dynamic> toList() => [pendingCall, data].toList(growable: true);
}

List<dynamic>? handleCppRequests(
    dynamic message, String methodName, int Function(CppRequest) callback) {
  final cppRequest = CppRequest.fromCppMessage(message);
  stdout.write('Dart:   Got message: $cppRequest\n');

  if (cppRequest.method == methodName) {
    //final int argument = cppRequest.data[0];
    final int result = callback(cppRequest);
    final cppResponse =
        CppResponse(CppResponseMessage(pendingCall: cppRequest.pendingCall!, data: Uint8List.fromList([result])));
    stdout.write('Dart:   Responding: $cppResponse\n');
    cppRequest.replyPort!.send(cppResponse.message.toList());
  }
  return null;
}

Future asyncSleep(int ms) {
  return Future.delayed(Duration(milliseconds: ms), () => true);
}
