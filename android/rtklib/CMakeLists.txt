cmake_minimum_required(VERSION 3.6)
set(PROJECT_NAME "rtklib")
project(${PROJECT_NAME} LANGUAGES C)

set(SRC_DIR "../../third_party/RTKLIB/src")
set(UTILS_DIR "../../third_party/rtklib_wraps")

set(CTARGET -DTRACE -DENAGLO -DENAQZS -DENAGAL -DENACMP -DENAIRN -DNFREQ=5 -DNEXOBS=3 -DFLUTTER_DEBUG -D_USE_32BIT_TIME_T)
#set(CFLAGS -O3 -ansi -pedantic -Wall -Wno-unused-but-set-variable -I${SRC_DIR} -g)
#set(CFLAGS -std=c11 -Wall -Wextra -pedantic -Wmissing-prototypes -Wshadow)
set(CFLAGS -std=c11 -Wall -pedantic -Wmissing-prototypes)

#set(LDLIBS  = -lm -lrt -lpthread)

set(RTKLIB 
 ${SRC_DIR}/rtkcmn.c ${SRC_DIR}/rtksvr.c ${SRC_DIR}/rtkpos.c ${SRC_DIR}/geoid.c ${SRC_DIR}/solution.c ${SRC_DIR}/lambda.c 
 ${SRC_DIR}/sbas.c ${SRC_DIR}/stream.c ${SRC_DIR}/rcvraw.c ${SRC_DIR}/rtcm.c ${SRC_DIR}/preceph.c ${SRC_DIR}/options.c ${SRC_DIR}/pntpos.c ${SRC_DIR}/ppp.c ${SRC_DIR}/ppp_ar.c 
 ${SRC_DIR}/rcv/novatel.c ${SRC_DIR}/rcv/ublox.c ${SRC_DIR}/rcv/crescent.c ${SRC_DIR}/rcv/skytraq.c ${SRC_DIR}/rcv/javad.c ${SRC_DIR}/rcv/nvs.c ${SRC_DIR}/rcv/binex.c 
 ${SRC_DIR}/rcv/rt17.c ${SRC_DIR}/ephemeris.c ${SRC_DIR}/rinex.c ${SRC_DIR}/ionex.c ${SRC_DIR}/rtcm2.c ${SRC_DIR}/rtcm3.c ${SRC_DIR}/rtcm3e.c 
 ${SRC_DIR}/tides.c ${SRC_DIR}/rcv/septentrio.c ${SRC_DIR}/rcv/swiftnav.c ${UTILS_DIR}/utils.c)

add_library(${PROJECT_NAME} SHARED ${RTKLIB})
target_compile_options(${PROJECT_NAME} PRIVATE ${CFLAGS})
target_compile_definitions(${PROJECT_NAME} PRIVATE ${CTARGET})
target_include_directories(${PROJECT_NAME} PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}"
  "${CMAKE_CURRENT_SOURCE_DIR}/${SRC_DIR}"
  "${CMAKE_CURRENT_SOURCE_DIR}/${UTILS_DIR}")