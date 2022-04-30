import 'dart:ffi' as ffi;
import 'dart:async';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rtklib/src/dylib.dart';

//import 'package:flutter_rtklib/src/rcv/ublox_bindings.dart' as ubx;
import 'package:flutter_rtklib/src/rtklib_bindings.dart' as rtklib;

typedef _wrappedPrint_C = ffi.Void Function(ffi.Pointer<ffi.Int8>, ffi.Uint64);
void wrappedPrint(ffi.Pointer<ffi.Int8> arg, int length) {
  print(arg.cast<Utf8>().toDartString(length: length));
}

final wrappedPrintPointer =
    ffi.Pointer.fromFunction<_wrappedPrint_C>(wrappedPrint);

// enum RawDataStatus {
// error(-1),
// empty(0);
//
// const RawDataStatus(this.value);
// final int value;
// }
class UbloxImpl {
  static const TAG = "UbloxImpl";
  //late final ubx.Ublox ublox;
  static final rtklib.RtkLib? _rtkInstance = dylibRtklib;

  final _obsSreamController = StreamController<ObservationControllerImpl>();

  Stream<ObservationControllerImpl> get observationStream {
    return _obsSreamController.stream;
  }

  UbloxImpl() {
    _rtkInstance!.flutter_initialize(wrappedPrintPointer);
    _rtkInstance!.set_level_trace(2);
  }


  int _input_ubx(ffi.Pointer<rtklib.raw_t> raw, int data) {
    final status = _rtkInstance!.input_ubx(raw, data);
    if (status == -1) {
      return -1;
    }
    // -1: error message, 0: no message, 1: input observation data, 2: input ephemeris, 3: input sbas message, 9: input ion/utc parameter
    switch (status) {
      case 0: // 0: no message
        return 0;
      case 1: // 1: input observation data
        final obs = ObservationControllerImpl._(raw.ref.obs);
        //final obsPtr = ffi.calloc<rtklib.obs_t>()..ref = raw.ref.obs.data;
        _obsSreamController.add(obs);
        //!print(obs.toString());
        _rtkInstance!.traceobs(2, raw.ref.obs.data, raw.ref.obs.n);
        return 1;
      case 2: // 2: input ephemeris
        return raw.ref.ephsat;
    }
    return -1;
  }

  void input_ubx(Uint8List buffer) {
    final raw = ffi.calloc<rtklib.raw_t>();
    final initStatus = _rtkInstance!.init_raw(raw, rtklib.STRFMT_UBX);
    if (initStatus == 0) {
      const String msg = 'Error';
      _rtkInstance!.free_raw(raw);
      ffi.calloc.free(raw);
      throw Exception(msg);
    }

    for (int i = 0; i < buffer.length; i++) {
      final inputStatus = _input_ubx(raw, buffer[i]);
      if (inputStatus == -1) {
        continue;
      }
    }
  }

  int test_input_ubx2(Uint8List buffer) {
    using((Arena arena) {
      final rawPrt = arena.allocate<rtklib.raw_t>(ffi.sizeOf<rtklib.raw_t>());
      print(rawPrt);
      final initRes = _rtkInstance!.init_raw(rawPrt, rtklib.STRFMT_UBX);
      print('return : ${initRes.toString()}');
      print('nbyte : ${rawPrt.elementAt(0).ref.nbyte}');
      print(rawPrt);
      for (int i = 0; i < buffer.length; i++) {
        if (initRes == 1) {
          if (kDebugMode) {
            print('return : ${initRes.toString()}');
            print('nbyte : ${rawPrt.ref.nbyte}');
          }
        }
      }
    });

    return 0;
  }

  int test_input_ubx3(Uint8List buffer) {
    final rawPtr = ffi.malloc<rtklib.raw_t>(1);
    print('adress before : ${rawPtr.toString()}');
    final initRes =
        _rtkInstance!.init_raw(rawPtr.cast(), 4 /*rtklib.STRFMT_UBX*/);
    print('adress after : ${rawPtr.toString()}');
    final rawVal = rawPtr.elementAt(0).ref;
    ffi.malloc.free(rawPtr);
    print('return : ${initRes.toString()}');
    print('nbyte : ${rawVal.nbyte}');

    return 0;
  }

  int test_input_ubx4(Uint8List buffer) {
    final statusPtr = ffi.calloc<ffi.Uint32>(1);
    //final rawPtr /*= ffi.calloc<rtklib.raw_t>(1)..ref*/ = _rtkInstance!.create_raw(4, statusPtr);
    //final rawPtr = ffi.calloc<rtklib.raw_t>(1)
    //  ..ref = _rtkInstance!.create_raw(4, statusPtr).ref;
    final rawPtr = ffi.Pointer<rtklib.raw_t>.fromAddress(
        _rtkInstance!.create_raw(4, statusPtr).address);
    print('status : ${statusPtr.value}');
    print('adress before : ${rawPtr.toString()}');
    //final initRes =
    //    _rtkInstance!.init_raw(rawPtr, 4 /*rtklib.STRFMT_UBX*/);
    print('adress after : ${rawPtr.toString()}');
    final rawVal = rawPtr.ref;
    //ffi.malloc.free(rawPtr);
    //print('return : ${initRes.toString()}');

    print('nbyte : ${rawVal.nbyte}');
    _rtkInstance!.free_raw(rawPtr);
    return 0;
  }

  int test_input_ubx5(Uint8List buffer) {
    final statusPtr = ffi.calloc<ffi.Uint32>(1);
    print('status : ${statusPtr.value}');

    print('gtime_t size: ${ffi.sizeOf<rtklib.gtime_t>()}');
    print('raw_t size: ${ffi.sizeOf<rtklib.raw_t>()}');

    final rawVal = _rtkInstance!.create_raw(4, statusPtr).ref;
    print('status : ${statusPtr.value}');
    print('nbyte : ${rawVal.nbyte}');
    return 0;
  }

  static String _traceobs(rtklib.obsd_t obs) {
    final id = satno2id(obs.sat);
    final time = time2str(obs.time, 3);

    return 'time: $time id: $id ';
  }

  static String time2str(rtklib.gtime_t time, int n) {
    final str = ffi.calloc.allocate<ffi.Int8>(64); //ffi.calloc<ffi.Int8>();
    _rtkInstance!.time2str(time, str, n);
    return str.cast<ffi.Utf8>().toDartString(/*length: n*/);
  }

  static String satno2id(int sat) {
    final id = ffi.calloc.allocate<ffi.Int8>(16);
    _rtkInstance!.satno2id(sat, id);
    return id.cast<ffi.Utf8>().toDartString();
  }
}

class RawData {
  rtklib.obs_t? observationData;
  int? ephemeris;
}

class ObservationControllerImpl {
  final rtklib.obs_t _obsRaw;
  final data = List<rtklib.obsd_t>.empty(growable: true);

  ObservationControllerImpl._(rtklib.obs_t obs) : _obsRaw = obs {
    _initData(_obsRaw);
  }

  void _initData(rtklib.obs_t obs) {
    final length = obs.n;
    data.clear();
    for (int i = 0; i < length; i++) {
      final item = obs.data.elementAt(i).ref;
      data.add(item);
    }
  }

  @override
  String toString() {
    if (data.isEmpty) {
      return "${super.toString()} is Empty";
    }
    String res = '';
    for (var obs in data) {
      res += UbloxImpl._traceobs(obs);
    }
    return res;
  }
}


/*

extension StringExtensions on String {
  ffi.Pointer<ffi.Int8> toInt8() {
    return ffi.Utf8.toUtf8(this).cast<ffi.Int8>();
  }
}

extension PointerExtensions<T extends ffi.NativeType> on ffi.Pointer<T> {
  String toStr() {
    if (T == ffi.Int8) {
      return ffi.Utf8.fromUtf8(cast<ffi.Utf8>());
    }

    throw UnsupportedError('$T unsupported');
  }
}*/