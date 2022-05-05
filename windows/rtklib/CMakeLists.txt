cmake_minimum_required(VERSION 3.6)
set(PROJECT_NAME "rtklib")
project(${PROJECT_NAME} LANGUAGES C)
set(CM_TARGET_PLATFORM "Windows")
include("${CMAKE_CURRENT_SOURCE_DIR}/../../CMakeLists.txt")

if (NOT DEFINED INFO_TAG)
  set(INFO_TAG "[INF]")
endif()
if (NOT DEFINED INFO_TAG)
  set(WARN_TAG "[WARN]")
endif()
if (NOT DEFINED ERROR_TAG)
  set(ERROR_TAG "[ERROR]")
endif()

message("Start build ${PROJECT_NAME} for ${CM_TARGET_PLATFORM}...")

# init GLOBAL variables
setOptions()
setSrcDirs("../../third_party")
setLibs()

if (NOT DEFINED CTARGET_BASE)
  message("${ERROR_TAG}  CTARGET_BASE (compile definitions) not defined, used default values for CTARGET.")
  set(CTARGET -DWIN32 -DWIN_DLL)
else()
  set(CTARGET ${CTARGET_BASE} -DWIN32 -DWIN_DLL)
endif()
message("${INFO_TAG} CTARGET values (compile definitions) = ${CTARGET}")

set(CFLAGS_Wno 
  -wd4028
  -wd4100 
  -wd4101
  -wd4132
  -wd4133 
  -wd4146
  -wd4189
  -wd4242 
  -wd4244 
  -wd4245 
  -wd4255 
  -wd4267
  -wd4311
  -wd4389
  -wd4459
  -wd4477 
  -wd4548
  -wd4668 
  -wd4701
  -wd4706 
  -wd4710 
  -wd4711 
  -wd4774 
  -wd4820 
  -wd4996 
  -wd5045 
  )

if (NOT DEFINED CFLAGS_BASE)
  message("${WARN_TAG} CFLAGS (compile options) not defined, used default values for CFLAGS.")
  set(CFLAGS -std=c11 -Wall -pedantic ${CFLAGS_Wno})
else()
  set(CFLAGS ${CFLAGS_BASE} ${CFLAGS_Wno})
endif()
message("${INFO_TAG} CFLAGS values (compile options) = ${CFLAGS}")

set(LDLIBS  ws2_32 winmm)
message("${INFO_TAG} LDLIBS (link libraries) values = ${LDLIBS}")

add_library(${PROJECT_NAME} SHARED ${RTKLIB})
target_compile_options(${PROJECT_NAME} PRIVATE ${CFLAGS})
target_compile_definitions(${PROJECT_NAME} PRIVATE ${CTARGET})
target_include_directories(${PROJECT_NAME} PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}"
  "${CMAKE_CURRENT_SOURCE_DIR}/${SRC_DIR}"
  "${CMAKE_CURRENT_SOURCE_DIR}/${UTILS_DIR}"
)
target_link_libraries(${PROJECT_NAME} ${LDLIBS})

message("Build for ${CM_TARGET_PLATFORM} success!.")
