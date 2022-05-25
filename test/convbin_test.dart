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
    final sep = Platform.pathSeparator;
    final rootDir = getRootDirectory();
    final dataDir = "$rootDir${sep}test${sep}data${sep}rcvraw";
    final outDir = "$rootDir${sep}test${sep}.out";

    testing.setUpAll(() {
      convbin = getDylibRtklib();
      //outDir = outDir.replaceAll(RegExp(r'[/]'), "\\");
      print("outDir = $outDir");
    });

    testing.tearDownAll(() {
      print("Convert to Rinex (convbin) tests done.");
    });

    testing.test("Convbin is not null", () {
      testing.expect(convbin, testing.isNotNull);
    });

    testing.test("Test convert from nov", () {
      final cmd =
          "convbin -r nov $dataDir${sep}oemv_200911218.gps -ti 10 -d $outDir -os"
              .split(' ')
              .toList(growable: false);
      final convbinResult = pkg_ffi.using((pkg_ffi.Arena arena) {
        final argVars = cmd.toNativeArray(allocator: arena);
        final options = arena<rnxopt_t>();
        final res =
            convbin.convbin_convert_cmd(cmd.length, argVars, options, 3);
        return res;
      });
      testing.expect(convbinResult, testing.isNonNegative);
    });
  });
}
