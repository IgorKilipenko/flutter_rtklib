import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:flutter/foundation.dart';
import 'package:flutter_rtklib/flutter_rtklib.dart';
import 'package:flutter_rtklib/src/bindings/rtklib.dart';
import 'package:flutter_test/flutter_test.dart' as testing;

void main() {
  testing.TestWidgetsFlutterBinding.ensureInitialized();

  testing.group("Trace tests", () {
    late final RtkLib rtklib;

    testing.setUpAll(() {
      rtklib = FlutterRtklib.getRtkLibInstance(traceLevel: 5);
      if (kDebugMode) {
        print("*** Started \"Trace tests\"...");
      }
    });

    testing.setUp(() {
      rtklib.console.reset();
    });

    testing.tearDownAll(() {
      if (kDebugMode) {
        print("*** Done \"Trace tests\".");
      }
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
      int count = pkg_ffi.using((arena) {
        final strPtr = format.toNativeUtf8(allocator: arena).cast<ffi.Char>();
        return rtklib.flutter_printf(strPtr);
      });

      String? ouputMsg = (await rtklib.console.getLastMessage())?.message;

      testing.expect(count, testing.isPositive);
      testing.expect(ouputMsg, testing.isNotNull);
      testing.expect(ouputMsg!.replaceAll(RegExp(r'[\n\r]+'), ""),
          testing.equalsIgnoringCase(format));
    });

    testing.test("* Test flutter_printf", () async {
      const format = "Test tarce format";
      int count = pkg_ffi.using((arena) {
        final strPtr = format.toNativeUtf8(allocator: arena).cast<ffi.Char>();
        return rtklib.flutter_printf(strPtr);
      });

      String? ouputMsg = (await rtklib.console.getLastMessage())?.message;

      testing.expect(count, testing.isPositive);
      testing.expect(ouputMsg, testing.isNotNull);
      testing.expect(ouputMsg!.replaceAll(RegExp(r'[\n\r]+'), ""),
          testing.equalsIgnoringCase(format));
    });
  });
}
