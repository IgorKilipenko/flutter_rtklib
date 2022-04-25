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
    //ublox = dylibUblox;
    //raw.value = ffi.calloc<rtklib.raw_t>();

    //print('IN : ADRESS -> ${raw.value.address}');
    //print('IN : DATA ADRESS -> ${raw.value.ref.obs.data.address}');
    //raw.value.ref.

/*
    _rtkInstance ??= dylibRtklib;
    if (_rtkInstance!.init_raw_2(raw, rtklib.STRFMT_UBX) == 0) {
      //ffi.calloc.free(raw);
      throw Exception('Memory allocation error');
    }

*/
    //__obs = raw.ref.obs;
    //print('OUT : ADRESS -> ${raw.value.address}');
    //print('OUT : DATA ADRESS -> ${raw.value.ref.obs.data.address}');

    _rtkInstance!.flutter_initialize(wrappedPrintPointer);
    _rtkInstance!.set_level_trace(5);
  }

  //var raw = ffi.calloc<ffi.Pointer<rtklib.raw_t>>();
  //var sss = ffi.malloc<rtklib.raw_t>();
  //ffi.malloc.allocate<rtklib.raw_t>(ffi.sizeOf<rtklib.raw_t>());
  //late rtklib.obs_t __obs;

/*
  int test_input_ubx(int data) {
    var _raw = ffi.Pointer<rtklib.raw_t>.fromAddress(
        raw.value.address); //raw.value.ref;
    print(_raw.ref.nbyte);
    print(raw.value.ref.icpc);
    //print(sss.ref.nbyte);
    final status = _rtkInstance!.input_ubx(_raw, data);
    if (status == -1) {
      const String msg = 'Error';
      //ffi.calloc.free(raw);
      //throw Exception(msg);
    }
    //_raw = raw.value.ref;

    if (_raw.ref.nbyte > 0) {
      print('!!!!!!!!!!!!!!!!!!');
    }
    // -1: error message, 0: no message, 1: input observation data, 2: input ephemeris, 3: input sbas message, 9: input ion/utc parameter
    switch (status) {
      case 0: // 0: no message
        return 0;
      case 1: // 1: input observation data
        final obs = ObservationControllerImpl._(_raw.ref.obs);
        //_obsSreamController.add(obs);
        print(obs.toString());
        return 1;
      case 2: // 2: input ephemeris
        return _raw.ref.ephsat;
    }
    return -1;
  }*/

  int test_input_ubx2(Uint8List buffer) {
    using((Arena arena) {
      final rawPrt = arena.allocate<rtklib.raw_t>(ffi.sizeOf<rtklib.raw_t>());
      print(rawPrt);
      final initRes = _rtkInstance!.init_raw(rawPrt, 4 /*rtklib.STRFMT_UBX*/);
      print('return : ${initRes.toString()}');
      print('nbyte : ${rawPrt.elementAt(0).ref.nbyte}');
      print(rawPrt);
      /*for (int i = 0; i < buffer.length; i++) {
        
        if (initRes == 1) {
          if (kDebugMode) {
            print('return : ${initRes.toString()}');
            print('nbyte : ${rawPrt.ref.nbyte}');
          }
        }
      }*/
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
    print('raw_t size: ${ffi.sizeOf<rtklib.raw2_t>()}');

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

/*
  extern void traceobs(int level, const obsd_t *obs, int n)
{
    char str[64],id[16];
    int i;
    
    if (!fp_trace||level>level_trace) return;
    for (i=0;i<n;i++) {
        time2str(obs[i].time,str,3);
        satno2id(obs[i].sat,id);
        fprintf(fp_trace," (%2d) %s %-3s rcv%d %13.3f %13.3f %13.3f %13.3f %d %d %d %d %x %x %3.1f %3.1f\n",
              i+1,str,id,obs[i].rcv,obs[i].L[0],obs[i].L[1],obs[i].P[0],
              obs[i].P[1],obs[i].LLI[0],obs[i].LLI[1],obs[i].code[0],
              obs[i].code[1],obs[i].Lstd[0],obs[i].Pstd[0],obs[i].SNR[0]*SNR_UNIT,obs[i].SNR[1]*SNR_UNIT);
    }
    fflush(fp_trace);
  }*/

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