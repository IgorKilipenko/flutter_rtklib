cmake_minimum_required(VERSION 3.6)

if (NOT DEFINED INFO_TAG)
  set(INFO_TAG "[INF]")
endif()
if (NOT DEFINED INFO_TAG)
  set(WARN_TAG "[WARN]")
endif()
if (NOT DEFINED ERROR_TAG)
  set(ERROR_TAG "[ERROR]")
endif()

macro(setSrcDirs thirdPartyDir)
    message("${INFO_TAG} set src directories")
    set(SRC_DIR "${ARGV0}/RTKLIB/src")
    set(UTILS_DIR "${ARGV0}/rtklib_wraps")
endmacro()

macro(setOptions)
    message("${INFO_TAG} set options")
    set(CTARGET_BASE -DEXTERNAL_TRACE -DENAGLO -DENAQZS -DENAGAL -DENACMP -DENAIRN -DNFREQ=5 -DNEXOBS=3 -DFLUTTER_DEBUG)
    set(CFLAGS_BASE -std=c17 -Wall -pedantic)
endmacro()

macro(setLibs)
    if (NOT DEFINED SRC_DIR)
        message("${WARN_TAG} SRC_DIR is not defined")
        return()
    endif()
    if (NOT DEFINED UTILS_DIR)
        message("${WARN_TAG} SRC_DIR is not defined")
        return()
    endif()

    message("${INFO_TAG} set RTKLIB files")
    set(RTKLIB 
        ${SRC_DIR}/rtkcmn.c 
        ${SRC_DIR}/rtksvr.c 
        ${SRC_DIR}/rtkpos.c 
        ${SRC_DIR}/geoid.c 
        ${SRC_DIR}/solution.c 
        ${SRC_DIR}/lambda.c 
        ${SRC_DIR}/sbas.c 
        ${SRC_DIR}/stream.c 
        ${SRC_DIR}/rcvraw.c 
        ${SRC_DIR}/rtcm.c 
        ${SRC_DIR}/preceph.c 
        ${SRC_DIR}/options.c 
        ${SRC_DIR}/pntpos.c 
        ${SRC_DIR}/ppp.c 
        ${SRC_DIR}/ppp_ar.c 
        ${SRC_DIR}/rcv/novatel.c 
        ${SRC_DIR}/rcv/ublox.c 
        ${SRC_DIR}/rcv/crescent.c 
        ${SRC_DIR}/rcv/skytraq.c 
        ${SRC_DIR}/rcv/javad.c 
        ${SRC_DIR}/rcv/nvs.c 
        ${SRC_DIR}/rcv/binex.c 
        ${SRC_DIR}/rcv/rt17.c 
        ${SRC_DIR}/ephemeris.c 
        ${SRC_DIR}/rinex.c 
        ${SRC_DIR}/ionex.c 
        ${SRC_DIR}/rtcm2.c 
        ${SRC_DIR}/rtcm3.c 
        ${SRC_DIR}/rtcm3e.c 
        ${SRC_DIR}/tides.c 
        ${SRC_DIR}/rcv/septentrio.c 
        ${SRC_DIR}/rcv/swiftnav.c
        ${UTILS_DIR}/utils.c
        #${UTILS_DIR}/trace.c
        #${UTILS_DIR}/test_size.c
    )
endmacro()