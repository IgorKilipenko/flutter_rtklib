import 'dart:ffi' as ffi;
import 'dart:async';
import 'dart:isolate';

import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:flutter_rtklib/ffi_extensions.dart';
import 'package:flutter_rtklib/src/apps/common.dart';
import 'package:flutter_rtklib/src/bindings/rtklib.dart';

abstract class RtkrcvBase {
  Future<int> startServerCmd(String strCmd, {Duration? timeLimit});
  void stopServer();
}

class Rtkrcv extends RtkrcvBase {
  static Rtkrcv? _instance;

  late final RtkLib _rtklib;
  late final ReceivePort _interactiveCppRequests;
  late final int _nativePort;
  late final StreamController<CppRequest> _cppPortStreamController;
  late final Stream<CppRequest> _cppPortStream;

  Rtkrcv._(RtkLib rtklib) : _rtklib = rtklib {
    _init();
  }

  factory Rtkrcv.create(RtkLib rtklib) {
    _instance ??= Rtkrcv._(rtklib);
    return _instance!;
  }

  void _init() {
    _cppPortStreamController = StreamController();
    _cppPortStream = _cppPortStreamController.stream.asBroadcastStream();
    _interactiveCppRequests = ReceivePort('Rtkrcv_ReceivePort');
    _nativePort = _interactiveCppRequests.sendPort.nativePort;
    _interactiveCppRequests.listen((message) {
      handleCppRequests(message, "rtksvrthread", (cppRequest) {
        print("CALLBACK: arg value: ${cppRequest.data[0]}");
        _cppPortStreamController.add(cppRequest);
        return 0;
      });
    });
    assert(_rtklib.rtkrcv_registerSendPort(_nativePort),
        "Register send port (on Rtkrcv) failed");
  }

  @override
  Future<int> startServerCmd(String strCmd, {Duration? timeLimit}) async {
    final stream = _rtklib.console.firstWhere((m) {
      final result = m.traceLevel == -2 &&
          m.message.contains(RegExp(
            r".*rtksever\.state.*stop",
            multiLine: true,
          ));
      return result;
    }, timeLimit: timeLimit);
    final convbinResult =
        Future<int>(() => pkg_ffi.using((pkg_ffi.Arena arena) {
              final args = splitConsoleCmdAgs(strCmd);
              final argVars = args.toNativeArray(allocator: arena);
              final res = _rtklib.run_rtkrcv_cmd(args.length, argVars);
              return res;
            }));
    String? ouputMsg = (await stream)?.message;

    if (ouputMsg == null) {
      return -1;
    }
    return await convbinResult;
  }

  @override
  void stopServer() {}

  void get stream => _cppPortStream;
}
