cmake_minimum_required(VERSION 3.6)
set(CM_TARGET_PLATFORM "Linux")

#set(ROOT_DIR "../..")
get_filename_component(ROOT_DIR "${CMAKE_SOURCE_DIR}/../../" ABSOLUTE)
message("ROOT_DIR ${ROOT_DIR}")
include("${ROOT_DIR}/CMakeLists.txt")

if (NOT DEFINED INFO_TAG)
  set(INFO_TAG "[INF]")
endif()
if (NOT DEFINED INFO_TAG)
  set(WARN_TAG "[WARN]")
endif()
if (NOT DEFINED ERROR_TAG)
  set(ERROR_TAG "[ERROR]")
endif()

message(STATUS "Start build ${PROJECT_NAME} for ${CM_TARGET_PLATFORM}...")

# init GLOBAL variables
setOptions()
setSrcDirs("${ROOT_DIR}/third_party")
setLibs()

if (NOT DEFINED CTARGET_BASE)
  message(SEND_ERROR "${ERROR_TAG} CTARGET_BASE (compile definitions) not defined, used default values for CTARGET.")
  set(CTARGET "")
else()
  set(CTARGET ${CTARGET_BASE})
endif()
message("${INFO_TAG} CTARGET values (compile definitions) = ${CTARGET}")

# set(CFLAGS -std=c11 -Wall -pedantic -Wmissing-prototypes)
if (NOT DEFINED CFLAGS_BASE)
  message(AUTHOR_WARNING "${WARN_TAG} CFLAGS (compile options) not defined, used default values for CFLAGS.")
  set(CFLAGS -std=c17 -Wall -pedantic -Wmissing-prototypes)
else()
  set(CFLAGS ${CFLAGS_BASE} -Wmissing-prototypes)
endif()
message(STATUS "${INFO_TAG} CFLAGS values (compile options) = ${CFLAGS}")

set(LDLIBS m rt pthread)
message(STATUS "${INFO_TAG} LDLIBS (link libraries) values = ${LDLIBS}")

message(STATUS "${INFO_TAG} INCLUDE_DIRS (include directories) = ${INCLUDE_DIRS}")

add_library(${PROJECT_NAME} SHARED ${RTKLIB})
target_compile_options(${PROJECT_NAME} PRIVATE ${CFLAGS})
target_compile_definitions(${PROJECT_NAME} PRIVATE ${CTARGET})
target_include_directories(${PROJECT_NAME} PRIVATE
  ${INCLUDE_DIRS}
)
target_link_libraries(${PROJECT_NAME} ${LDLIBS})

message(STATUS "CMAKE for ${CM_TARGET_PLATFORM} success!.")