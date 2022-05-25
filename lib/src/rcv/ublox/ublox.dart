// ignore_for_file: camel_case_types

import 'dart:ffi' as ffi;
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:flutter/foundation.dart';
import 'package:flutter_rtklib/src/dylib.dart';

//import 'package:flutter_rtklib/src/rcv/ublox_bindings.dart' as ubx;
import 'package:flutter_rtklib/src/rtklib_bindings.dart' as rtklib;

class UbloxImpl {
  // ignore: constant_identifier_names
  static const TAG = "UbloxImpl";
  //late final ubx.Ublox ublox;
  static final rtklib.RtkLib _rtkInstance = getDylibRtklib(traceLevel: 4);

  final _obsSreamController = StreamController<ObservationControllerImpl>();

  Stream<ObservationControllerImpl> get observationStream {
    return _obsSreamController.stream;
  }

  int _inputUbx(ffi.Pointer<rtklib.raw_t> raw, int data) {
    final status = _rtkInstance.input_ubx(raw, data);
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
        //_rtkInstance.traceobs(2, raw.ref.obs.data, raw.ref.obs.n);
        for (var str in obs.toString().split('\n')) {
          print(str);
        }

        return 1;
      case 2: // 2: input ephemeris
        return raw.ref.ephsat;
    }
    return -1;
  }

  void decodeUbx(Uint8List buffer) {
    final raw = pkg_ffi.calloc<rtklib.raw_t>();
    final initStatus = _rtkInstance.init_raw(raw, rtklib.STRFMT_UBX);
    if (initStatus == 0) {
      const String msg = 'Error';
      if (raw.address != 0) {
        _rtkInstance.free_raw(raw);
      }
      //pkg_ffi.calloc.free(raw);
      throw Exception(msg);
    }

    for (int i = 0; i < buffer.length; i++) {
      final inputStatus = _inputUbx(raw, buffer[i]);
      if (inputStatus == -1) {
        continue;
      }
    }
    /*if (raw.address != 0) {
      _rtkInstance.free_raw(raw);
    }*/
  }

  /*static String _traceobs(rtklib.obsd_t obs) {
    final id = satno2id(obs.sat);
    final time = time2str(obs.time, 3);

    return 'time: $time id: $id ';
  }*/

  static String time2str(rtklib.gtime_t time, int n) {
    final str = pkg_ffi.calloc.allocate<ffi.Char>(64);
    _rtkInstance.time2str(time, str, n);
    return str.cast<pkg_ffi.Utf8>().toDartString(/*length: n*/);
  }

  static String satno2id(int sat) {
    final id = pkg_ffi.calloc.allocate<ffi.Char>(16);
    _rtkInstance.satno2id(sat, id);
    return id.cast<pkg_ffi.Utf8>().toDartString();
  }

  static String obsToString(rtklib.obsd_t obs) {
    final res = pkg_ffi.using((pkg_ffi.Arena arena) {
      final obsPtr = arena<rtklib.obsd_t>();
      obsPtr.ref = obs;
      final strLen = arena<ffi.Size>();
      final strPtr = _rtkInstance.obs2str(obsPtr, strLen);
      if (strLen.value <= 0) {
        return "";
      }
      final strResult =
          strPtr.cast<pkg_ffi.Utf8>().toDartString(length: strLen.value);
      if (strPtr.address != 0) {
        if (Platform.isWindows) {
          _rtkInstance.utils_free_str(strPtr);
        } else {
          arena.free(strPtr);
        }
      }
      return strResult;
    });
    return res;
  }

  static String obsToString2(rtklib.obsd_t obs) {
    final obsPtr = pkg_ffi.calloc<rtklib.obsd_t>();
    obsPtr.ref = obs;
    final strPtr = pkg_ffi.calloc<ffi.Pointer<ffi.Char>>();
    final strLen = _rtkInstance.obs2str2(obsPtr, strPtr);
    if (strLen <= 0) {
      return "";
    }

    final res = strPtr.value.cast<pkg_ffi.Utf8>().toDartString(length: strLen);

    pkg_ffi.calloc.free(obsPtr);
    pkg_ffi.calloc.free(strPtr.value);
    pkg_ffi.calloc.free(strPtr);

    return res;
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
    int idx = 0;
    for (var obs in data) {
      res +=
          "(${(++idx).toString().padLeft(3)}). ${UbloxImpl.obsToString(obs)}\n";
    }
    return res;
  }
}
