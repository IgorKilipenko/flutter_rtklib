import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rtklib_example/src/controllers/ublox_controller.dart';
import 'package:flutter_test/flutter_test.dart' as testing;
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  testing.group('Ublox controller tests', () {
    testing.setUp(() {
      final executableArguments = Platform.executableArguments;
      final localHostname = Platform.localHostname;
      final packageConfig = Platform.packageConfig;
      final resolvedExecutable = Platform.resolvedExecutable;
      final script = Platform.script.toString();
      print(resolvedExecutable);
      Get.log("Put UbloxController");
      Get.put(UbloxController());
    });
    testing.tearDown(() {
      Get.log("Delete UbloxController");
      Get.delete<UbloxController>();
    });

    testing.test(
        'Test the state of the reactive variable "name" across all of its lifecycles',
        () {
      final controller = Get.find<UbloxController>();
      testing.expect(controller.name, 'UbloxController');
      testing.expect(controller.isInit, true);
    });
  });
}
