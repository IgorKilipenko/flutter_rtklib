import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:flutter_rtklib/flutter_rtklib.dart';
import 'package:flutter_rtklib/src/apps/common.dart';
import 'package:flutter_rtklib/src/bindings/rtklib.dart';
import 'package:flutter_test/flutter_test.dart' as testing;

void main() {
  testing.TestWidgetsFlutterBinding.ensureInitialized();

  testing.group("Rtkrcv tests", () {
    late final RtkLib rtkrcv;
    final sep = Platform.pathSeparator;
    final rootDir = getRootDirectory();
    final configDir = "$rootDir${sep}lib${sep}c_api${sep}apps${sep}conf";

    Future<int> _execRtkrcvCmd(String strCmd) async {
      final stream = rtkrcv.console.firstWhere((m) {
        final result = m.traceLevel == -2 &&
            m.message.contains(RegExp(
              r".*rtksever\.state.*stop",
              multiLine: true,
            ));
        return result;
      }, timeLimit: const Duration(seconds: 10));
      final convbinResult =
          Future<int>(() => pkg_ffi.using((pkg_ffi.Arena arena) {
                final args = splitConsoleCmdAgs(strCmd);
                final argVars = args.toNativeArray(allocator: arena);
                final res = rtkrcv.run_rtkrcv_cmd(args.length, argVars);
                return res;
              }));
      String? ouputMsg = (await stream)?.message;

      //* If timeout - test
      if (ouputMsg == null) {
        return -1;
      }
      return await convbinResult;
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

    testing.test("Test Rtkrcv", () async {
      final cmd = "./rtkrcv -t 2 -o $configDir/single.conf";
      final convbinResult = await _execRtkrcvCmd(cmd);
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
