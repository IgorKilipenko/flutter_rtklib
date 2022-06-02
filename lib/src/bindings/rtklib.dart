import 'dart:async';
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

class RtkLib extends RtkDylib {
  static UbloxImpl? _ubloxInstance;
  static void Function(TraceMessage message)? _customPrintCallback;
  static final virtualConsole = TraceController.getController();
  static final PrintCallback _printCallback =
      ffi.Pointer.fromFunction<_WrappedPrintC>(_printDebug);

  static void _printDebug(ffi.Pointer<ffi.Char> str, int len) {
    final msg =
        TraceMessage(str.cast<pkg_ffi.Utf8>().toDartString(length: len));
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
    initTrace();
    _ubloxInstance ??= UbloxImpl(this);
  }

  void initTrace(
      {void Function(TraceMessage message)? printCallback, int? traceLevel}) {
    _customPrintCallback = printCallback;
    flutter_initialize(_printCallback);
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
  //notDefined(-1),
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
  static final _levelRegex =
      RegExp(r'^\(level: (?<level>[0-5])\)\s+(?<msg>.*[\n\r\s])$', multiLine: true);
  late final String message;
  late final int traceLevel;
  TraceMessage(String message, {int? traceLevel, bool formatMessage = true}) {
    const defaultTraceLevel = 0;
    MapEntry<int, String>? parsedLevel = _parseTraceLevel(message, formatMessage: formatMessage);
    traceLevel ??= parsedLevel?.key;
    this.traceLevel = traceLevel ?? defaultTraceLevel;
    this.message = parsedLevel?.value ?? message;
  }

  static MapEntry<int, String>? _parseTraceLevel(String message,
      {bool formatMessage = true}) {
    final match = _levelRegex.firstMatch(message);
    final levelStr = match?.namedGroup("level");
    if (levelStr != null) {
      final parsedLevel = int.tryParse(levelStr);
      if (parsedLevel != null) {
        if (formatMessage && match?.namedGroup("msg") != null) {
          message =
              '[${TraceLevels.getByValue(parsedLevel).name.toUpperCase()}] ${match!.namedGroup("msg")!}';
        }
        return MapEntry<int, String>(parsedLevel, message);
      }
    }
    return null;
  }

  bool get isAppMessgae => traceLevel == 0;
  bool get isError => traceLevel == 1;
  bool get isWarn => traceLevel == 2;
  bool get isDebug => traceLevel == 3;
  bool get isVerbose => traceLevel >= 4;
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
}
