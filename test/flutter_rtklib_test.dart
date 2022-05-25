import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:flutter/foundation.dart';
import 'package:flutter_rtklib/src/bindings/windows_overrides.dart';
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

  testing.group("Bindings tests", () {
    late final ffi.Pointer<struct_sizes_t> sizesPtr;
    late final RtkLib dylib;

    testing.setUpAll(() {
      dylib = getDylibRtklib(/*traceLevel: 3*/);
      sizesPtr = dylib.getStructSizes();
    });

    testing.tearDownAll(() {
      if (sizesPtr.address != 0) {
        if (Platform.isWindows) {
          dylib.native_free(sizesPtr.cast());
        } else {
          pkg_ffi.calloc.free(sizesPtr);
        }
      }
    });

    testing.test("Is RtkLib", () {
      testing.expect(getDylibRtklib(), testing.isA<RtkLib>());
    });
    testing.test("sizesPtr is not null", () {
      testing.expect(sizesPtr.address, testing.isNot(0),
          reason: "sizesPtr is null ptr");
    });

    testing.test("Check sum for gtime_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.gtime_t;
      int size = ffi.sizeOf<gtime_t>();
      testing.expect(nativeSize, testing.equals(size));
    });

    testing.test("Check sum for obsd_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.obsd_t;
      int size = ffi.sizeOf<obsd_t>();
      testing.expect(nativeSize, testing.equals(size));
    });

    testing.test("Check sum for obs_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.obs_t;
      int size = ffi.sizeOf<obs_t>();
      testing.expect(nativeSize, testing.equals(size));
    });

    testing.test("Check sum for erpd_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.erpd_t;
      int size = ffi.sizeOf<erpd_t>();
      testing.expect(nativeSize, testing.equals(size));
    });

    testing.test("Check sum for erp_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.erp_t;
      int size = ffi.sizeOf<erp_t>();
      testing.expect(nativeSize, testing.equals(size));
    });

    testing.test("Check sum for pcv_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.pcv_t;
      int size = ffi.sizeOf<pcv_t>();
      testing.expect(nativeSize, testing.equals(size));
    });

    testing.test("Check sum for pcvs_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.pcvs_t;
      int size = ffi.sizeOf<pcvs_t>();
      testing.expect(nativeSize, testing.equals(size));
    });

    testing.test("Check sum for alm_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.alm_t;
      int size = ffi.sizeOf<alm_t>();
      testing.expect(nativeSize, testing.equals(size));
    });

    testing.test("Check sum for eph_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.eph_t;
      int size = ffi.sizeOf<eph_t>();
      testing.expect(nativeSize, testing.equals(size));
    });

    testing.test("Check sum for geph_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.geph_t;
      int size = ffi.sizeOf<geph_t>();
      testing.expect(nativeSize, testing.equals(size));
    });

    testing.test("Check sum for peph_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.peph_t;
      int size = ffi.sizeOf<peph_t>();
      testing.expect(nativeSize, testing.equals(size));
    });

    testing.test("Check sum for pclk_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.pclk_t;
      int size = ffi.sizeOf<pclk_t>();
      testing.expect(nativeSize, testing.equals(size));
    });

    testing.test("Check sum for seph_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.seph_t;
      int size = ffi.sizeOf<seph_t>();
      testing.expect(nativeSize, testing.equals(size));
    });

    testing.test("Check sum for tled_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.tled_t;
      int size = ffi.sizeOf<tled_t>();
      testing.expect(nativeSize, testing.equals(size));
    });

    testing.test("Check sum for tle_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.tle_t;
      int size = ffi.sizeOf<tle_t>();
      testing.expect(nativeSize, testing.equals(size));
    });

    testing.test("Check sum for tec_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.tec_t;
      int size = ffi.sizeOf<tec_t>();
      testing.expect(nativeSize, testing.equals(size));
    });

    testing.test("Check sum for sbsmsg_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.sbsmsg_t;
      int size = ffi.sizeOf<sbsmsg_t>();
      testing.expect(nativeSize, testing.equals(size));
    });

    testing.test("Check sum for sbs_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.sbs_t;
      int size = ffi.sizeOf<sbs_t>();
      testing.expect(nativeSize, testing.equals(size));
    });

    testing.test("Check sum for sbsfcorr_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.sbsfcorr_t;
      int size = ffi.sizeOf<sbsfcorr_t>();
      testing.expect(nativeSize, testing.equals(size));
    });

    testing.test("Check sum for sbslcorr_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.sbslcorr_t;
      int size = ffi.sizeOf<sbslcorr_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for sbssatp_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.sbssatp_t;
      int size = ffi.sizeOf<sbssatp_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for sbssat_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.sbssat_t;
      int size = ffi.sizeOf<sbssat_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for sbsigp_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.sbsigp_t;
      int size = ffi.sizeOf<sbsigp_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for sbsigpband_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.sbsigpband_t;
      int size = ffi.sizeOf<sbsigpband_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for sbsion_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.sbsion_t;
      int size = ffi.sizeOf<sbsion_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for dgps_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.dgps_t;
      int size = ffi.sizeOf<dgps_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for ssr_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.ssr_t;
      int size = ffi.sizeOf<ssr_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for nav_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.nav_t;
      int size = ffi.sizeOf<nav_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for sta_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.sta_t;
      int size = ffi.sizeOf<sta_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for sol_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.sol_t;
      int size = ffi.sizeOf<sol_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for solbuf_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.solbuf_t;
      int size = ffi.sizeOf<solbuf_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for solstat_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.solstat_t;
      int size = ffi.sizeOf<solstat_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for solstatbuf_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.solstatbuf_t;
      int size = ffi.sizeOf<solstatbuf_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for rtcm_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.rtcm_t;
      int size = ffi.sizeOf<rtcm_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for rnxctr_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.rnxctr_t;
      int size = ffi.sizeOf<rnxctr_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for url_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.url_t;
      int size = ffi.sizeOf<url_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for opt_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.opt_t;
      int size = ffi.sizeOf<opt_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for snrmask_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.snrmask_t;
      int size = ffi.sizeOf<snrmask_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for prcopt_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.prcopt_t;
      int size = ffi.sizeOf<prcopt_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for solopt_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.solopt_t;
      int size = ffi.sizeOf<solopt_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for filopt_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.filopt_t;
      int size = ffi.sizeOf<filopt_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for rnxopt_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.rnxopt_t;
      int size = ffi.sizeOf<rnxopt_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for ssat_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.ssat_t;
      int size = ffi.sizeOf<ssat_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for ambc_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.ambc_t;
      int size = ffi.sizeOf<ambc_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for rtk_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.rtk_t;
      int size = ffi.sizeOf<rtk_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for raw_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.raw_t;
      int size = ffi.sizeOf<raw_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for stream_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.stream_t;
      late final int size;
      if (Platform.isWindows) {
        size = ffi.sizeOf<stream_t_w>();
      } else {
        size = ffi.sizeOf<stream_t>();
      }
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for strconv_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.strconv_t;
      int size = ffi.sizeOf<strconv_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for strsvr_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.strsvr_t;
      late final int size;
      if (Platform.isWindows) {
        size = ffi.sizeOf<strsvr_t_w>();
      } else {
        size = ffi.sizeOf<strsvr_t>();
      }
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for rtksvr_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.rtksvr_t;
      late final int size;
      if (Platform.isWindows) {
        size = ffi.sizeOf<rtksvr_t_w>();
      } else {
        size = ffi.sizeOf<rtksvr_t>();
      }
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for gis_pnt_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.gis_pnt_t;
      int size = ffi.sizeOf<gis_pnt_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for gis_poly_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.gis_poly_t;
      int size = ffi.sizeOf<gis_poly_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for gis_polygon_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.gis_polygon_t;
      int size = ffi.sizeOf<gis_polygon_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for gisd_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.gisd_t;
      int size = ffi.sizeOf<gisd_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
    testing.test("Check sum for gis_t", () {
      final sizeInfo = sizesPtr.ref;
      int nativeSize = sizeInfo.gis_t;
      int size = ffi.sizeOf<gis_t>();
      testing.expect(nativeSize, testing.equals(size));
    });
  });
}
