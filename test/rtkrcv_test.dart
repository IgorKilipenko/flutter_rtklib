import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:flutter_rtklib/flutter_rtklib.dart';
import 'package:flutter_rtklib/src/apps/common.dart';
import 'package:flutter_rtklib/src/apps/rtkrcv.dart';
import 'package:flutter_rtklib/src/bindings/rtklib.dart';
import 'package:flutter_test/flutter_test.dart' as testing;

void main() {
  testing.TestWidgetsFlutterBinding.ensureInitialized();

  testing.group("Rtkrcv tests", () {
    late final RtkLib rtklib;
    late final Rtkrcv rtkrcv;
    final sep = Platform.pathSeparator;
    final rootDir = getRootDirectory();
    final configDir = "$rootDir${sep}lib${sep}c_api${sep}apps${sep}conf";

    testing.setUpAll(() {
      rtklib = FlutterRtklib.getRtkLibInstance();
      rtkrcv = rtklib.getRtkrcv();
      print("Config dir = $configDir");
    });

    testing.tearDownAll(() {
      print("Rtkrcv tests done.");
    });

    testing.test("Test Rtkrcv", () async {
      final cmd = "./rtkrcv -t 2 -o $configDir/single.conf";
      final convbinResult = await rtkrcv.startServerCmd(cmd,
          timeLimit: const Duration(seconds: 10));
      testing.expect(convbinResult, testing.isNonNegative);
    });

    /*
    testing.test("Test Rtkrcv for rinex L1/L2 files input", () {
      final cmd = "./rtkrcv -t 4 -o $configDir/rtk_rinex_vsnk.conf";
      final convbinResult = _execRtkrcvCmd(cmd);
      testing.expect(convbinResult, testing.isNonNegative);
    });
    */
  });
}
