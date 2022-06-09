import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:flutter/foundation.dart';
import 'package:flutter_rtklib/flutter_rtklib.dart';
import 'package:flutter_rtklib/src/apps/convbin.dart';
import 'package:flutter_rtklib/src/rtklib_bindings.dart';
import 'package:dylib/dylib.dart';

export 'package:flutter_rtklib/src/rtklib_bindings.dart';

part 'package:flutter_rtklib/src/dylib.dart';

typedef _WrappedPrintC = ffi.Void Function(
    ffi.Pointer<ffi.Char>, ffi.Size, ffi.Int);
typedef PrintCallback = ffi.Pointer<
    ffi.NativeFunction<
        ffi.Void Function(ffi.Pointer<ffi.Char>, ffi.Size, ffi.Int)>>;
typedef LookupFunction = ffi.Pointer<T> Function<T extends ffi.NativeType>(
    String symbolName);

class Printf extends ffi.Opaque {}

class RtkLib extends RtkDylib {
  static UbloxImpl? _ubloxInstance;
  static void Function(TraceMessage message)? _customPrintCallback;
  static final virtualConsole = TraceController.getController();

  /*
  static final PrintCallback _printCallback =
      ffi.Pointer.fromFunction<_WrappedPrintC>(_printDebug);
  */

  /// Holds the symbol lookup function.
  late final LookupFunction lookup;
  late final ReceivePort _receivePort;

  /*
  static void _printDebug(ffi.Pointer<ffi.Char> str, int len, int level) {
    final msg =
        TraceMessage(str.cast<pkg_ffi.Utf8>().toDartString(length: len));
    _flutterTrace(msg);
  }
  */

  static void _flutterTrace(TraceMessage msg) {
    RtkLib.virtualConsole.add(msg);
    if (RtkLib._customPrintCallback != null) {
      RtkLib._customPrintCallback!(msg);
    } else {
      if (msg.isError) {
        stderr.write(msg.message);
      } else {
        stdout.write(msg.message);
      }
    }
  }

  /// The symbols are looked up in [dynamicLibrary].
  RtkLib._(ffi.DynamicLibrary dynamicLibrary) : super(dynamicLibrary) {
    lookup = dynamicLibrary.lookup;
    _init();
  }

  /// Get [RtkLib] instance.
  ///
  /// [traceLevel] - Level of the trace passed to RTKLIB
  factory RtkLib.getInstance({int? traceLevel}) {
    final rtklib = _getDylibRtklib(traceLevel: traceLevel);
    if (traceLevel != null &&
        traceLevel >= 0 &&
        rtklib.gettracelevel() != traceLevel) {
      rtklib.tracelevel(traceLevel);
    }
    return rtklib;
  }

  void _init() {
    assert(InitDartApiDL(ffi.NativeApi.initializeApiDLData) == 0,
        "Init dart api failed");
    //RegisterPrintCallbackNonBlocking(nativePort, _printCallback);
    initTrace();
    _ubloxInstance ??= UbloxImpl(this);
  }

  void initTrace(
      {void Function(TraceMessage message)? printCallback, int? traceLevel}) {
    _receivePort = ReceivePort()
      ..listen((msgPtrAdrress) {
        if (msgPtrAdrress is int && msgPtrAdrress > 0) {
          final nativeMsgPtr =
              ffi.Pointer<FlutterTraceMessage>.fromAddress(msgPtrAdrress);
          assert(!nativeMsgPtr.isNullPointer);
          if (nativeMsgPtr.isNullPointer) {
            stderr.write(
                "[WARN] Incoming message from C (rtklib) is null pointer\n");
            return;
          }
          final level = nativeMsgPtr.ref.level;
          final length = nativeMsgPtr.ref.message_lenght;
          assert(length >= 0);
          assert(!nativeMsgPtr.ref.message.isNullPointer);
          final nativeMsg = nativeMsgPtr.ref.message
              .cast<pkg_ffi.Utf8>()
              .toDartString(length: length);

          final msg = TraceMessage(nativeMsg, traceLevel: level);
          _flutterTrace(msg);

          if (!nativeMsgPtr.isNullPointer) {
            if (!nativeMsgPtr.ref.message.isNullPointer) {
              if (Platform.isWindows && kDebugMode) {
                native_deleteArray(nativeMsgPtr.ref.message.cast());
              } else {
                pkg_ffi.calloc.free(nativeMsgPtr.ref.message);
              }
            }
            if (Platform.isWindows && kDebugMode) {
              native_delete_FlutterTraceMessage(nativeMsgPtr);
            } else {
              pkg_ffi.calloc.free(nativeMsgPtr);
            }
          }
        }
      });
    final int nativePort = _receivePort.sendPort.nativePort;
    _customPrintCallback = printCallback;
    flutter_initialize(nativePort);
    set_level_trace(traceLevel ?? (kDebugMode ? 3 : 2));
  }

  UbloxImpl getUblox() {
    return _ubloxInstance!;
  }

  Convbin getConvbin() {
    return Convbin();
  }

  TraceController get console {
    return virtualConsole;
  }
}

enum TraceLevels {
  systemCommand(-2),
  message(0),
  error(1),
  warning(2),
  debug(3),
  verbose(4),
  info(5);

  final int value;
  const TraceLevels(this.value);
  static TraceLevels getByValue(int? value) {
    return TraceLevels.values.firstWhere((item) => item.value == value,
        orElse: () => TraceLevels.message);
  }
}

class TraceMessage {
  late final String message;
  late final int traceLevel;

  TraceMessage(String message,
      {this.traceLevel = 0, bool formatMessage = true}) {
    this.message = _parseTraceLevel(message,
        level: traceLevel, formatMessage: formatMessage);
  }

  static String _parseTraceLevel(String message,
      {required int level, bool formatMessage = true}) {
    if (formatMessage) {
      message =
          'rtklib: [${TraceLevels.getByValue(level).name.toUpperCase()}] $message';
    }
    return message;
  }

  bool get isAppMessgae => traceLevel == 0;
  bool get isError => traceLevel == 1;
  bool get isWarn => traceLevel == 2;
  bool get isDebug => traceLevel == 3;
  bool get isVerbose => traceLevel >= 4;
  bool get isSystemMessage => traceLevel < 0;
}

class TraceController {
  static const tag = "TraceController";
  static TraceController? _instance;

  StreamController<TraceMessage>? _streamController;
  Stream<TraceMessage>? _stream;
  StreamSubscription? _subscription;
  TraceMessage? _lastMessage;
  int _subscribersCount = 0;

  TraceController._() {
    _init();
  }

  factory TraceController.getController() {
    _instance ??= TraceController._();
    return _instance!;
  }

  void add(TraceMessage message) {
    _streamController?.add(message);
  }

  void close() {
    if (kDebugMode) {
      print("[DEBUG] ($tag): TraceController closing.");
    }

    _lastMessage = null;
    _subscription?.cancel();
    _subscription = null;
    _stream = null;
    _streamController?.close();
    _streamController = null;
  }

  void reset() {
    if (kDebugMode) {
      print("[DEBUG] ($tag): TraceController reset.");
    }
    close();
    _init();
  }

  void _init() {
    if (kDebugMode) {
      print("[DEBUG] ($tag): TraceController init.");
    }

    _streamController = StreamController<TraceMessage>();
    _stream =
        _streamController!.stream.asBroadcastStream(onListen: ((subscription) {
      _subscribersCount += 1;
      if (kDebugMode) {
        print(
            "[DEBUG] ($tag): Subscription : $subscription connected. Total subscribers count = $_subscribersCount");
      }
    }), onCancel: (subscription) {
      _subscribersCount -= 1;
      if (kDebugMode) {
        print(
            "[DEBUG] ($tag): Subscription : $subscription cancel. Total subscribers count = $_subscribersCount");
      }
    });
    _subscription = _stream!.listen((msg) {
      _lastMessage = msg;
    }, onError: (error, stackTrace) {
      print("[ERROR] ($tag): Error message: $error. Stack trace: $stackTrace.");
      close();
    });
  }

  StreamSubscription<TraceMessage> listen(
    void Function(TraceMessage)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    if (_stream == null) {
      reset();
    }
    return _stream!.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  Future<TraceMessage?> getFirstMessage(
      {Duration timeLimit = const Duration(milliseconds: 100)}) async {
    var isEmpty = true;
    final res = await _stream?.firstWhere((element) {
      isEmpty = false;
      return true;
    }).timeout(timeLimit, onTimeout: () {
      isEmpty = true;
      return TraceMessage("");
    });
    return !isEmpty ? res : null;
  }

  Future<TraceMessage?> getLastMessage() async {
    await Future.delayed(const Duration(microseconds: 0));
    return _lastMessage;
  }

  Future<TraceMessage?> firstWhere(bool Function(TraceMessage) test,
      {TraceMessage Function()? orElse, Duration? timeLimit}) async {
    var isEmpty = true;
    final first = _stream?.firstWhere(test, orElse: orElse);
    final res = await (timeLimit == null
        ? first
        : first?.timeout(timeLimit, onTimeout: () {
            isEmpty = true;
            return TraceMessage("");
          }));
    return !isEmpty ? res : null;
  }
}
