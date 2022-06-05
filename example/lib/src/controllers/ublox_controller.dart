import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rtklib/flutter_rtklib.dart';
import 'package:get/get.dart';

class UbloxController extends GetxController {
  final name = 'UbloxController';
  late final StreamSubscription<ObservationControllerImpl>
      _obsStreamSubscription;
  late final UbloxImpl _ublox;
  final observations = Rx<ObservationControllerImpl?>(null);
  
  bool _isInit = false;

  @visibleForTesting
  bool get isInit {
    return _isInit;
  }

  @override
  void onInit() {
    super.onInit();
    _ublox = FlutterRtklib.getRtkLibInstance().getUblox();
    _obsStreamSubscription = _ublox.observationStream.handleError((error) {
      if (kDebugMode) {
        Get.log(error.toString(), isError : true);
      }
    }).listen((obs) {
      observations.value = obs;
    });
    //testUbx2();
    _isInit = true;
  }

  @override
  void onClose() {
    _obsStreamSubscription.cancel();
    super.onClose();
  }

  Future<void> testDecodeUbxData() async {
    final bytes = await rootBundle.load('assets/data/ubx_20080526.ubx');
    final buffer =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    await _ublox.decodeUbx(buffer);
  }
}
