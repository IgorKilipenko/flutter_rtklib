import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:flutter/foundation.dart';
import 'package:flutter_rtklib/ffi_extensions.dart';
import 'package:flutter_rtklib/src/dylib.dart';
import 'package:flutter_rtklib/src/rtklib_bindings.dart';
import 'package:flutter_test/flutter_test.dart' as testing;
import 'package:flutter_rtklib/flutter_rtklib.dart';

void main() {
  testing.TestWidgetsFlutterBinding.ensureInitialized();


  testing.group("Convert to Rinex (convbin) tests", () {
    late final RtkLib convbin;
    final rootDir = getRootDirectory();
    var dataDir = "$rootDir/test/data/rcvraw";
    final outDir = "$rootDir/test/.out";

    testing.setUpAll(() {
      convbin = getDylibRtklib();
    });

    testing.tearDownAll(() {
      print("Convert to Rinex (convbin) tests done.");
    });

    testing.test("Convbin is not null", () {
      testing.expect(convbin, testing.isNotNull);
    });

    testing.test("Test convert from nov", () {

      final cmd =
          "convbin -r nov $dataDir/oemv_200911218.gps -ti 10 -d $outDir -os"
              .split(' ')
              .toList(growable: false);

      final argVars = cmd.toNativeArray();
      final options = pkg_ffi.calloc<rnxopt_t>();
      int res = convbin.convbin_convert_cmd(cmd.length, argVars, options, 3);
      testing.expect(res, testing.isNonNegative);

      pkg_ffi.calloc.free(options);
    });
  });
}
