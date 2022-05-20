cmake_minimum_required(VERSION 3.6)
set(PROJECT_NAME "rtklib")
project(${PROJECT_NAME} LANGUAGES C)
set(CM_TARGET_PLATFORM "Linux")
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
  set(CTARGET "")
else()
  set(CTARGET ${CTARGET_BASE})
endif()
message("${INFO_TAG} CTARGET values (compile definitions) = ${CTARGET}")

# set(CFLAGS -std=c11 -Wall -pedantic -Wmissing-prototypes)
if (NOT DEFINED CFLAGS_BASE)
  message("${WARN_TAG} CFLAGS (compile options) not defined, used default values for CFLAGS.")
  set(CFLAGS -std=c17 -Wall -pedantic -Wmissing-prototypes)
else()
  set(CFLAGS ${CFLAGS_BASE} -Wmissing-prototypes)
endif()
message("${INFO_TAG} CFLAGS values (compile options) = ${CFLAGS}")

set(LDLIBS m rt pthread)
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

message("CMAKE for ${CM_TARGET_PLATFORM} success!.")