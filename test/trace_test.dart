import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:flutter/foundation.dart';
import 'package:flutter_rtklib/flutter_rtklib.dart';
import 'package:flutter_rtklib/src/bindings/rtklib.dart';
import 'package:flutter_test/flutter_test.dart' as testing;

extension RtklibTraceUtils on RtkLib {
  void tracet_2arg(int level, String format, double val1, double val2,
      {ffi.Allocator allocator = pkg_ffi.calloc}) {
    late final _tracetPtr_2arg = lookup<
        ffi.NativeFunction<
            ffi.Void Function(ffi.Int, ffi.Pointer<ffi.Char>, ffi.Double,
                ffi.Double)>>('tracet');
    late final _tracet_2arg = _tracetPtr_2arg.asFunction<
        void Function(int, ffi.Pointer<ffi.Char>, double, double)>();
    final formatPtr =
        format.toNativeUtf8(allocator: allocator).cast<ffi.Char>();
    return _tracet_2arg(level, formatPtr, val1, val2);
  }
}

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
      const format = "Test tarce format\n";
      int count = pkg_ffi.using((arena) {
        final strPtr = format.toNativeUtf8(allocator: arena).cast<ffi.Char>();
        return rtklib.flutter_printf(strPtr);
      });

      String? ouputMsg = (await rtklib.console.getLastMessage())?.message;

      testing.expect(count, testing.isPositive);
      testing.expect(ouputMsg, testing.isNotNull);
      testing.expect(ouputMsg!, testing.equalsIgnoringCase(format));
    });

    testing.test("* Test matsprint", () {
      const columns = 3;
      const rows = 3;
      final matrix = <double>[
        803.383194,
        713.453294,
        511.618281,
        579.933871,
        843.178396,
        589.885015,
        186.306597,
        548.126743,
        126.973781,
      ];
      pkg_ffi.using((arena) {
        //final matrix = arena<ffi.Double>(columns*rows);
        final matrixPtr = matrix.toNativeArray(allocator: arena);
        CStringArray buffer = arena<ffi.Pointer<ffi.Char>>();
        int len = rtklib.matsprint(matrixPtr, columns, rows, 5, 6, buffer);

        testing.expect(len, testing.isPositive);
        testing.expect(buffer, testing.isNot(ffi.nullptr));
        testing.expect(buffer.value, testing.isNot(ffi.nullptr));

        final stringMatrix =
            buffer.value.cast<pkg_ffi.Utf8>().toDartString(length: len);
        arena.free(buffer.value);

        const snapshot = ""
            "803.383194 579.933871 186.306597\n"
            "713.453294 843.178396 548.126743\n"
            "511.618281 589.885015 126.973781\n"
            "";

        testing.expect(
            stringMatrix, testing.equalsIgnoringWhitespace(snapshot));
      });
    });

    testing.test("* Test tracet", () async {
      const format = "Format string. Test value1 = %.2f, value2 = %3.3f.\n";
      pkg_ffi.using((arena) {
        rtklib.tracet_2arg(3, format, 3.066, 5.566, allocator: arena);
      });

      String? ouputMsg = (await rtklib.console.getLastMessage())?.message;
      print(ouputMsg);
    });
  });
}
