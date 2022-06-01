import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:flutter_rtklib/flutter_rtklib.dart';
import 'package:flutter_rtklib/src/bindings/rtklib.dart';
import 'package:flutter_test/flutter_test.dart' as testing;

void main() {
  testing.TestWidgetsFlutterBinding.ensureInitialized();

  testing.group("Trace tests", () {
    late final RtkLib rtklib;

    testing.setUpAll(() {
      rtklib = FlutterRtklib.getRtkLibInstance(traceLevel: 5);
      print("*** Started \"Trace tests\"...");
    });

    testing.tearDownAll(() {
      print("*** Done \"Trace tests\".");
    });

    testing.test("* RTKLIB is not null", () {
      testing.expect(rtklib, testing.isNotNull);
    });

    testing.test("* Trace level value == 5", () {
      final tracelevel = rtklib.gettracelevel();
      testing.expect(tracelevel, testing.equals(5));
    });

    testing.test("* Test flutter_printf", () async {
      const format = "Test tarce format";
      String? ouputMsg;
      final subscriber = rtklib.console.listen((msg) {
        ouputMsg = msg.message;
      });

      int count = pkg_ffi.using((arena) {
        final strPtr = format.toNativeUtf8(allocator: arena).cast<ffi.Char>();
        return rtklib.flutter_printf(strPtr);
      });

      await Future.doWhile(() async {
        await Future.delayed(
            const Duration(milliseconds: 100) /*, () => ouputMsg == null*/);
        return ouputMsg == null;
      }).timeout(const Duration(milliseconds: 1000));

      subscriber.cancel();

      testing.expect(count, testing.isPositive);
      testing.expect(ouputMsg, testing.isNotNull);
      testing.expect(ouputMsg!.replaceAll(RegExp(r'[\n\r]+'), ""),
          testing.equalsIgnoringCase(format));
    });
  });
}
