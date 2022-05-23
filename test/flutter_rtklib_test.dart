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

  testing.group("Bindings tests", () {
    late final ffi.Pointer<struct_sizes_t> sizesPtr;

    testing.setUpAll(() {
      sizesPtr = getDylibRtklib().getStructSizes();
    });

    testing.tearDownAll(() {
      if (sizesPtr.address != 0) {
        pkg_ffi.calloc.free(sizesPtr);
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
  });
}

/*
size_t ;
size_t sbssatp_t;
size_t sbssat_t;
size_t sbsigp_t;
size_t sbsigpband_t;
size_t sbsion_t;
size_t dgps_t;
size_t ssr_t;
size_t nav_t;
size_t sta_t;
size_t sol_t;
size_t solbuf_t;
size_t solstat_t;
size_t solstatbuf_t;
size_t rtcm_t;
size_t rnxctr_t;
size_t url_t;
size_t opt_t;
size_t snrmask_t;
size_t prcopt_t;
size_t solopt_t;
size_t filopt_t;
size_t rnxopt_t;
size_t ssat_t;
size_t ambc_t;
size_t rtk_t;
size_t raw_t;
size_t stream_t;
size_t strconv_t;
size_t strsvr_t;
size_t rtksvr_t;
size_t gis_pnt_t;
size_t gis_poly_t;
size_t gis_polygon_t;
size_t gisd_t;
size_t gis_t;
*/