cmake_minimum_required(VERSION 3.10)
#set(CMAKE_MESSAGE_LOG_LEVEL "STATUS")
set(CMAKE_VERBOSE_MAKEFILE ON)

set(PROJECT_NAME "rtklib")
project(${PROJECT_NAME} C CXX)
if (NOT ${CMAKE_SYSTEM_NAME} STREQUAL "Android")
  set(CMAKE_C_STANDARD 17)
  set(CMAKE_CXX_STANDARD 20)
  set(CMAKE_CXX_STANDARD_REQUIRED True)
endif()

if (NOT DEFINED INFO_TAG)
  set(INFO_TAG "[INF]")
endif()
if (NOT DEFINED INFO_TAG)
  set(WARN_TAG "[WARN]")
endif()
if (NOT DEFINED ERROR_TAG)
  set(ERROR_TAG "[ERROR]")
endif()

#set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
if(CMAKE_CXX_COMPILER_LOADED)
  message("${INFO_TAG} Compiler platform: ${CMAKE_SYSTEM_NAME}")
  message("${INFO_TAG} Compiler language: ${COMPILE_LANGUAGE_VALUE}")
  message("${INFO_TAG} Compiler path: ${CMAKE_CXX_COMPILER}")
  message("${INFO_TAG} Compiler ID: ${CMAKE_CXX_COMPILER_ID}")
  message("${INFO_TAG} Compiler version:    
          ${CMAKE_CXX_COMPILER_VERSION}")
endif()

if (NOT DEFINED ROOT_DIR)
  message(AUTHOR_WARNING "[${WARN_TAG}] ROOT_DIR is not defined/ Set by default.")
  get_filename_component(ROOT_DIR "${CMAKE_SOURCE_DIR}/../../" ABSOLUTE)
endif()

macro(setSrcDirs thirdPartyDir)
    message(STATUS "${INFO_TAG} set src directories")
    set(SRC_DIR "${ARGV0}/RTKLIB/src")
    set(UTILS_DIR "${ROOT_DIR}/lib/c_api")
    set(FFI_DIR "${ROOT_DIR}/lib/c_api/apps")

    if (${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
      set(DART_SDK_DIR "C:/src/flutter/bin/cache/dart-sdk/include")
    else()
      set(DART_SDK_DIR "~/development/flutter/bin/cache/dart-sdk/include")
    endif()
endmacro()

macro(setOptions)
    message(STATUS "${INFO_TAG} set options")
    set(CTARGET_BASE -DEXTERNAL_TRACE -DENAGLO -DENAQZS -DENAGAL -DENACMP -DENAIRN -DNFREQ=5 -DNEXOBS=3 -DFLUTTER_DEBUG)
    set(CFLAGS_BASE -Wall -pedantic)
endmacro()

macro(setLibs)
    if (NOT DEFINED SRC_DIR)
        message(FATAL_ERROR "${ERROR_TAG} SRC_DIR is not defined")
        return()
    endif()
    if (NOT DEFINED UTILS_DIR)
        message(FATAL_ERROR "${ERROR_TAG} SRC_DIR is not defined")
        return()
    endif()
    if (NOT DEFINED FFI_DIR)
        message(FATAL_ERROR "${ERROR_TAG} FFI_DIR is not defined")
        return()
    endif()

    message(STATUS "${INFO_TAG} set RTKLIB files")
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
        ${SRC_DIR}/convrnx.c
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
        ${UTILS_DIR}/rtklib_api.cpp
        ${UTILS_DIR}/trace.cpp
        ${UTILS_DIR}/test_size.cpp
        ${UTILS_DIR}/io.cpp
        ${FFI_DIR}/ffi_convbin.cpp
        ${FFI_DIR}/ffi_rtkrcv.cpp
        ${DART_SDK_DIR}/dart_api_dl.c
    )

    set(INCLUDE_DIRS 
      "${CMAKE_SOURCE_DIR}"
      "${SRC_DIR}"
      "${UTILS_DIR}"
      "${FFI_DIR}"
      "${DART_SDK_DIR}"
      "${DART_SDK_DIR}/internal"
    )
endmacro()
