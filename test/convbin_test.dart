import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:flutter/foundation.dart';
import 'package:flutter_rtklib/src/dylib.dart';
import 'package:flutter_rtklib/src/rtklib_bindings.dart';
import 'package:flutter_test/flutter_test.dart' as testing;
import 'package:flutter_rtklib/flutter_rtklib.dart';

void main() {
  testing.TestWidgetsFlutterBinding.ensureInitialized();
  testing.test('Test ublox', () async {
    UbloxImpl ublox = UbloxImpl();
    testing.expect(ublox, testing.isA<UbloxImpl>());
  });

  testing.group("Convert to Rinex (convbin) tests", () {
    late final RtkLib convbin;
    const DATDIR = "../thrid_party/RTKLIB/test/data/rcvraw";
    const OUTPUT_DIR = "./.out";

    testing.setUpAll(() {
      convbin = getDylibRtklib();
    });

    testing.tearDownAll(() {});

    testing.test("Convbin is not null", () {
      testing.expect(convbin, testing.isNotNull);
    });

    testing.test("Convbin is not null", () {
      //const args = "-r nov $DATDIR/oemv_200911218.gps -ti 10 -d . -os";
      List<String> args = [
        "-r nov",
        "$DATDIR/oemv_200911218.gps",
        "-ti 10",
        "-d $OUTPUT_DIR",
        "-os"
      ];

      final arg_vars = pkg_ffi.calloc<ffi.Pointer<ffi.Char>>(args.length);
      for (int i = 0; i < args.length; i++) {
        arg_vars.value = args[i].toNativeUtf8().cast<ffi.Char>();
      }
      final options = pkg_ffi.calloc<rnxopt_t>();
      int res = convbin.convbin_convert_cmd(args.length, arg_vars, options, -1);
      testing.expect(res, testing.isNonNegative);

      pkg_ffi.calloc.free(options);
    });
  });
}
