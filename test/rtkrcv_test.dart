import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:flutter_rtklib/flutter_rtklib.dart';
import 'package:flutter_rtklib/src/apps/common.dart';
import 'package:flutter_rtklib/src/rtklib_bindings.dart';
import 'package:flutter_test/flutter_test.dart' as testing;

void main() {
  testing.TestWidgetsFlutterBinding.ensureInitialized();

  testing.group("Rtkrcv tests", () {
    late final RtkDylib rtkrcv;
    final sep = Platform.pathSeparator;
    final rootDir = getRootDirectory();
    final configDir = "$rootDir${sep}lib${sep}c_api${sep}apps${sep}conf";

    int _execRtkrcvCmd(String strCmd) {
      final convbinResult = pkg_ffi.using((pkg_ffi.Arena arena) {
        final args = splitConsoleCmdAgs(strCmd);
        final argVars = args.toNativeArray(allocator: arena);
        final res = rtkrcv.run_rtkrcv_cmd(args.length, argVars);
        return res;
      });
      return convbinResult;
    }

    testing.setUpAll(() {
      rtkrcv = FlutterRtklib.getRtkLibInstance();
      print("Config dir = $configDir");
    });

    testing.tearDownAll(() {
      print("Rtkrcv tests done.");
    });

    testing.test("Rtkrcv is not null", () {
      testing.expect(rtkrcv, testing.isNotNull);
    });

    testing.test("Test Rtkrcv", () {
      final cmd = "./rtkrcv -t 4 -o $configDir/single.conf";
      final convbinResult = _execRtkrcvCmd(cmd);
      testing.expect(convbinResult, testing.isNonNegative);
    });
  });
}
