#cmake_minimum_required(VERSION 3.6)
#set(PROJECT_NAME "serialport")
#project(${PROJECT_NAME} LANGUAGES C)

#set(SOURCE_PATH "../../third_party/libserialport")

#add_library(${PROJECT_NAME} SHARED
#  "${SOURCE_PATH}/linux.c"
#  "${SOURCE_PATH}/linux_termios.c"
#  "${SOURCE_PATH}/serialport.c"
#  "${SOURCE_PATH}/timing.c"
#)

#target_compile_options(${PROJECT_NAME} PRIVATE
#  -std=c99 -Wall -Wextra -pedantic -Wmissing-prototypes -Wshadow)
#target_compile_definitions(${PROJECT_NAME} PRIVATE LIBSERIALPORT_ATBUILD)
#target_include_directories(${PROJECT_NAME} PRIVATE
#  "${CMAKE_CURRENT_SOURCE_DIR}"
#  "${CMAKE_CURRENT_SOURCE_DIR}/${SOURCE_PATH}")



cmake_minimum_required(VERSION 3.6)
set(PROJECT_NAME "rtklib")
#project(${PROJECT_NAME} LANGUAGES C)

set(SRC_DIR "../../third_party/RTKLIB/src")
#set(FFI_DIR ${SRC_DIR}/ffi_api)


set(CTARGET -DTRACE -DENAGLO -DENAQZS -DENAGAL -DENACMP -DENAIRN -DNFREQ=3 -DNEXOBS=3)
set(CFLAGS -O3 -ansi -pedantic -Wall -Wno-unused-but-set-variable -I${SRC_DIR} -DFLUTTER_DEBUG ${CTARGET} -g)
#set(LDLIBS  = -lm -lrt -lpthread)

set(RTKLIB 
 ${SRC_DIR}/rtkcmn.c ${SRC_DIR}/rtksvr.c ${SRC_DIR}/rtkpos.c ${SRC_DIR}/geoid.c ${SRC_DIR}/solution.c ${SRC_DIR}/lambda.c 
 ${SRC_DIR}/sbas.c ${SRC_DIR}/stream.c ${SRC_DIR}/rcvraw.c ${SRC_DIR}/rtcm.c ${SRC_DIR}/preceph.c ${SRC_DIR}/options.c ${SRC_DIR}/pntpos.c ${SRC_DIR}/ppp.c ${SRC_DIR}/ppp_ar.c 
 ${SRC_DIR}/rcv/novatel.c ${SRC_DIR}/rcv/ublox.c ${SRC_DIR}/rcv/crescent.c ${SRC_DIR}/rcv/skytraq.c ${SRC_DIR}/rcv/javad.c ${SRC_DIR}/rcv/nvs.c ${SRC_DIR}/rcv/binex.c 
 ${SRC_DIR}/rcv/rt17.c ${SRC_DIR}/ephemeris.c ${SRC_DIR}/rinex.c ${SRC_DIR}/ionex.c ${SRC_DIR}/rtcm2.c ${SRC_DIR}/rtcm3.c ${SRC_DIR}/rtcm3e.c 
 ${SRC_DIR}/tides.c ${SRC_DIR}/rcv/septentrio.c ${SRC_DIR}/rcv/swiftnav.c)

set_source_files_properties(${RTKLIB}, PROPERTIES ${CFLAGS})
include_directories(${SRC_DIR})
add_library(${PROJECT_NAME} SHARED ${RTKLIB})
#target_include_directories(${PROJECT_NAME} PRIVATE
#  "${CMAKE_CURRENT_SOURCE_DIR}"
#  "${CMAKE_CURRENT_SOURCE_DIR}/${SRC_DIR}")
