import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:flutter_rtklib/ffi_extensions.dart';
import 'package:flutter_rtklib/src/dylib.dart';
import 'package:flutter_rtklib/src/rtklib_bindings.dart';
import 'package:flutter_test/flutter_test.dart' as testing;

void main() {
  testing.TestWidgetsFlutterBinding.ensureInitialized();

  testing.group("Convert to Rinex (convbin) tests", () {
    late final RtkLib convbin;
    final sep = Platform.pathSeparator;
    final rootDir = getRootDirectory();
    final dataDir = "$rootDir${sep}test${sep}data${sep}rcvraw";
    final outDir = "$rootDir${sep}test${sep}.out";

    int _execConvbinCmd(String strCmd) {
      final str = strCmd.replaceAllMapped(
          RegExp(r'[\u0027\u0022]([^\s]+)\s+([^\s]+)[\u0027\u0022]',
              unicode: true),
          (math) => '"${math.group(1)}{space}${math.group(2)}"');
      final cmd = str
          .split(RegExp(r'\s+'))
          .map((e) => e.replaceAll(RegExp(r'\{space\}'), " "))
          .toList(growable: false);
      final convbinResult = pkg_ffi.using((pkg_ffi.Arena arena) {
        final argVars = cmd.toNativeArray(allocator: arena);
        final options = arena<rnxopt_t>();
        final res =
            convbin.convbin_convert_cmd(cmd.length, argVars, options, 3);
        return res;
      });
      return convbinResult;
    }

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

    testing.test("Test convert to Rinex from NovAtel format", () {
      final cmd =
          "./convbin -r nov $dataDir${sep}oemv_200911218.gps -ti 10 -d $outDir -os";
      final convbinResult = _execConvbinCmd(cmd);
      testing.expect(convbinResult, testing.isNonNegative);
    });
    testing.test("Test convert to Rinex from Hemisphere format", () {
      final cmd =
          "./convbin -r hemis $dataDir${sep}cres_20080526.bin -ti 10 -d $outDir -f 1 -od -os";
      final convbinResult = _execConvbinCmd(cmd);
      testing.expect(convbinResult, testing.isNonNegative);
    });
    testing.test(
        "Test convert to Rinex from Ublox format with specific date range", () {
      final cmd =
          "./convbin $dataDir${sep}ubx_20080526.ubx -o ubx_test.obs -d $outDir -f 1 -ts 2008/5/26 6:00 -te 2008/5/26 6:10";
      final convbinResult = _execConvbinCmd(cmd);
      testing.expect(convbinResult, testing.isNonNegative);
    });
    testing.test("Test convert to Rinex from Ublox format", () {
      final cmd =
          "./convbin $dataDir${sep}ubx_20080526.ubx -n ubx_test.nav -d $outDir";
      final convbinResult = _execConvbinCmd(cmd);
      testing.expect(convbinResult, testing.isNonNegative);
    });
    testing.test("Test convert to Rinex from Ublox format with extends options",
        () {
      final cmd =
          "./convbin $dataDir${sep}ubx_20080526.ubx -h ubx_test.hnav -s ubx_test.sbs -d $outDir -x 129";
      final convbinResult = _execConvbinCmd(cmd);
      testing.expect(convbinResult, testing.isNonNegative);
    });
    testing.test(
        "Test convert to Rinex from RTCM2 format (with approximated time)", () {
      final cmd =
          "./convbin $dataDir${sep}testglo.rtcm2 -tr 2009/12/18 23:20 -d $outDir";
      final convbinResult = _execConvbinCmd(cmd);
      testing.expect(convbinResult, testing.isNonNegative);
    });
    testing.test(
        "Test convert to Rinex from RTCM3 format (with approximated time)", () {
      final cmd =
          "./convbin $dataDir${sep}testglo.rtcm3 -os -tr 2009/12/18 23:20 -d $outDir";
      final convbinResult = _execConvbinCmd(cmd);
      testing.expect(convbinResult, testing.isNonNegative);
    });
    testing.test(
        "Test convert to Rinex from NovAtel format (with specific output files)",
        () {
      final cmd =
          "./convbin -v 3 -f 6 -r nov $dataDir${sep}oemv_200911218.gps -od -os -o rnx3_test.obs -n rnx3_test.nav -d $outDir";
      final convbinResult = _execConvbinCmd(cmd);
      testing.expect(convbinResult, testing.isNonNegative);
    });
    testing.test(
        "Test convert to Rinex from Javad format (with specific station id)",
        () {
      final cmd =
          "./convbin $dataDir${sep}javad_20110115.jps -d $outDir -c JAV1";
      final convbinResult = _execConvbinCmd(cmd);
      testing.expect(convbinResult, testing.isNonNegative);
    });
    testing.test(
        "Test convert to Rinex from Javad format (with specific number of frequencies and rinex version)",
        () {
      final cmd =
          "./convbin $dataDir${sep}javad_20110115.jps -d $outDir -v 3.00 -f 3 -od -os";
      final convbinResult = _execConvbinCmd(cmd);
      testing.expect(convbinResult, testing.isNonNegative);
    });
    testing.test(
        "Test convert to Rinex from Javad format (with marker and antenna info)",
        () {
      final cmd =
          "./convbin $dataDir${sep}javad_20110115.jps -d $outDir -o test13.obs -v 3 -hc test1 -hc test2 -hm MARKER -hn MARKERNO -ht MARKKERTYPE -ho OBSERVER/AGENCY -hr 1234/RECEIVER/V.0.1.2 -ha ANTNO/ANTENNA -hp 1234.567/8901.234/5678.901 -hd 0.123/0.234/0.567";
      final convbinResult = _execConvbinCmd(cmd);
      testing.expect(convbinResult, testing.isNonNegative);
    });
    testing.test(
        "Test convert to Rinex from Javad format (with exclude satellites option)",
        () {
      final cmd =
          "./convbin $dataDir${sep}javad_20110115.jps -d $outDir -o test14.obs -v 3 -y S -y J -x 2 -x R19 -x R21";
      final convbinResult = _execConvbinCmd(cmd);
      testing.expect(convbinResult, testing.isNonNegative);
    });
    testing.test(
        "Test convert to Rinex from Javad format (with receiver options)", () {
      final cmd =
          "./convbin $dataDir${sep}javad_20110115.jps -d $outDir -o test15.obs -v 3 -ro \"-GL1P -GL2C\"";
      final convbinResult = _execConvbinCmd(cmd);
      testing.expect(convbinResult, testing.isNonNegative);
    });
    testing.test(
        "Test convert to Rinex from RTCM3 format (with approximated time)", () {
      final cmd =
          "./convbin $dataDir${sep}GMSD7_20121014.rtcm3 -d $outDir -tr 2012/10/14 0:00:00";
      final convbinResult = _execConvbinCmd(cmd);
      testing.expect(convbinResult, testing.isNonNegative);
    });
    testing.test(
        "Test convert to Rinex from RTCM3 format (with approximated time and specific rinex version and obsolute -scan option)",
        () {
      final cmd =
          "./convbin $dataDir${sep}GMSD7_20121014.rtcm3 -d $outDir -scan -v 3.01 -f 6 -od -os -tr 2012/10/14 0:00:00";
      final convbinResult = _execConvbinCmd(cmd);
      testing.expect(convbinResult, testing.isNonNegative);
    });
  });
}
