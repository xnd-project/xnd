cmake_minimum_required(VERSION 3.19)


# ==============================================================================
#                                  User options
# ==============================================================================

# Shared/static library choice:
option(BUILD_SHARED_LIBS "Build shared libraries (default: ON)." ON)
if(NOT BUILD_SHARED_LIBS)
  set(CMAKE_POSITION_INDEPENDENT_CODE ON)
  message(FATAL_ERROR
    " The static build is currently unsupported (duplicate global symbols).\n"
    " Use -DBUILD_SHARED_LIBS=ON (default).")
endif()

# Enable the CUDA build:
option(WITH_CUDA "Enable CUDA support (default: ON)." ON)

# Expert packaging options:
option(LIB_SYSTEM_WITH_MOD_HEADERS "expert option (default: OFF)" OFF)
option(LIB_XNDLIB_WITH_MOD_HEADERS "expert option (default: OFF)." OFF)
option(MOD_NDTYPES_WITH_SYSTEM_LIB "expert option (default: OFF)." OFF)
option(MOD_XND_WITH_SYSTEM_LIB "expert option (default: OFF)." OFF)
option(MOD_GUMATH_WITH_SYSTEM_LIB "expert option (default: OFF)." OFF)
option(MOD_NDTYPES_WITH_XNDLIB "expert option (default: OFF)." OFF)
option(MOD_XND_WITH_XNDLIB "expert option (default: OFF)." OFF)
option(MOD_GUMATH_WITH_XNDLIB "expert option (default: OFF)." OFF)

# Select the libraries to build [NDTYPES, XND, GUMATH].  GUMATH implies
# all libraries, XND implies NDTYPES. If one of the expert packaging options
# is active, LIB_SELECT is set to the corresponding value:
if(NOT LIB_SYSTEM_WITH_MOD_HEADERS AND
   NOT LIB_XNDLIB_WITH_MOD_HEADERS AND
   NOT MOD_NDTYPES_WITH_SYSTEM_LIB AND
   NOT MOD_XND_WITH_SYSTEM_LIB AND
   NOT MOD_GUMATH_WITH_SYSTEM_LIB AND
   NOT MOD_NDTYPES_WITH_XNDLIB AND
   NOT MOD_XND_WITH_XNDLIB AND
   NOT MOD_GUMATH_WITH_XNDLIB)
  set(LIB_SELECT "GUMATH" CACHE STRING "Which libraries to build and install (default: GUMATH).")
  set_property(CACHE LIB_SELECT PROPERTY STRINGS NDTYPES XND GUMATH)
elseif(DEFINED LIB_SELECT)
  message(FATAL_ERROR
   " error: LIB_SELECT cannot be specified together with a packaging option")
else()
  set(LIB_SELECT OFF)
endif()


# ==============================================================================
#                                Validate options
# ==============================================================================

# Mutually exclusive options:
set(MUTUALLY_EXCLUSIVE
    LIB_SELECT;
    LIB_SYSTEM_WITH_MOD_HEADERS;
    LIB_XNDLIB_WITH_MOD_HEADERS;
    MOD_NDTYPES_WITH_SYSTEM_LIB;
    MOD_XND_WITH_SYSTEM_LIB;
    MOD_GUMATH_WITH_SYSTEM_LIB;
    MOD_NDTYPES_WITH_XNDLIB;
    MOD_XND_WITH_XNDLIB;
    MOD_GUMATH_WITH_XNDLIB)

math(EXPR COUNT "0")
foreach(v IN ITEMS ${MUTUALLY_EXCLUSIVE})
  if(${v})
    math(EXPR COUNT "${COUNT} + 1")
  endif()
endforeach()

if(${COUNT} GREATER 1)
  message(FATAL_ERROR
    " error: the following options are mutually exclusive:\n"
    " [LIB_SELECT,\n"
    "  LIB_SYSTEM_WITH_MOD_HEADERS,\n"
    "  LIB_XNDLIB_WITH_MOD_HEADERS,\n"
    "  MOD_NDTYPES_WITH_SYSTEM_LIB\n"
    "  MOD_XND_WITH_SYSTEM_LIB,\n"
    "  MOD_GUMATH_WITH_SYSTEM_LIB,\n"
    "  MOD_NDTYPES_WITH_XNDLIB,\n"
    "  MOD_XND_WITH_XNDLIB,\n"
    "  MOD_GUMATH_WITH_XNDLIB]")
endif()

# Default: build all libraries:
set(BUILD_NDTYPES 1)
set(BUILD_XND 1)
set(BUILD_GUMATH 1)

# Default: install all built libraries:
set(LIB_INSTALL 1)

# Default: do not install module headers:
set(LIB_INSTALL_MOD_HEADERS 0)

# Default: build all modules for testing:
set(BUILD_MOD_NDTYPES 1)
set(BUILD_MOD_XND 1)
set(BUILD_MOD_GUMATH 1)

# Default: do not install any modules:
set(INSTALL_MOD_NDTYPES 0)
set(INSTALL_MOD_XND 0)
set(INSTALL_MOD_GUMATH 0)

# Any module uses the system lib:
set(MOD_WITH_SYSTEM_LIB 0)

# Any module uses the xndlib path convention:
set(MOD_WITH_XNDLIB 0)

# Any module is installed:
set(MOD_INSTALL 0)

if(LIB_SELECT)
  if(LIB_SELECT STREQUAL "NDTYPES")
    set(BUILD_XND 0)
    set(BUILD_GUMATH 0)
  elseif(LIB_SELECT STREQUAL "XND")
    set(BUILD_GUMATH 0)
  elseif(LIB_SELECT STREQUAL "GUMATH")
  else()
    message(FATAL_ERROR "LIB_SELECT: valid values are [OFF, NDTYPES, XND, GUMATH]")
  endif()

elseif(LIB_SYSTEM_WITH_MOD_HEADERS)
  set(LIB_INSTALL_MOD_HEADERS 1)

elseif(LIB_XNDLIB_WITH_MOD_HEADERS)
  set(LIB_INSTALL_MOD_HEADERS 1)

elseif(MOD_NDTYPES_WITH_SYSTEM_LIB)
  set(BUILD_NDTYPES 0)
  set(BUILD_XND 0)
  set(BUILD_GUMATH 0)
  set(LIB_INSTALL 0)

  set(BUILD_MOD_XND 0)
  set(BUILD_MOD_GUMATH 0)
  set(INSTALL_MOD_NDTYPES 1)

  set(MOD_WITH_SYSTEM_LIB 1)
  set(MOD_INSTALL 1)

elseif(MOD_XND_WITH_SYSTEM_LIB)
  set(BUILD_NDTYPES 0)
  set(BUILD_XND 0)
  set(BUILD_GUMATH 0)
  set(LIB_INSTALL 0)

  set(BUILD_MOD_NDTYPES 0)
  set(BUILD_MOD_GUMATH 0)
  set(INSTALL_MOD_XND 1)

  set(MOD_WITH_SYSTEM_LIB 1)
  set(MOD_INSTALL 1)

elseif(MOD_GUMATH_WITH_SYSTEM_LIB)
  set(BUILD_NDTYPES 0)
  set(BUILD_XND 0)
  set(BUILD_GUMATH 0)
  set(LIB_INSTALL 0)

  set(BUILD_MOD_NDTYPES 0)
  set(BUILD_MOD_XND 0)
  set(INSTALL_MOD_GUMATH 1)

  set(MOD_WITH_SYSTEM_LIB 1)
  set(MOD_INSTALL 1)

elseif(MOD_NDTYPES_WITH_XNDLIB)
  set(BUILD_XND 0)
  set(BUILD_GUMATH 0)
  set(LIB_INSTALL 0)

  set(BUILD_MOD_XND 0)
  set(BUILD_MOD_GUMATH 0)
  set(INSTALL_MOD_NDTYPES 1)

  set(MOD_WITH_XNDLIB 1)
  set(MOD_INSTALL 1)

elseif(MOD_XND_WITH_XNDLIB)
  set(BUILD_GUMATH 0)
  set(LIB_INSTALL 0)

  set(BUILD_MOD_GUMATH 0)
  set(INSTALL_MOD_XND 1)

  set(MOD_WITH_XNDLIB 1)
  set(MOD_INSTALL 1)

elseif(MOD_GUMATH_WITH_XNDLIB)
  set(LIB_INSTALL 0)

  set(INSTALL_MOD_GUMATH 1)

  set(MOD_WITH_XNDLIB 1)
  set(MOD_INSTALL 1)
else()
  message(FATAL_ERROR
    " error: exactly one of the following options must be enabled:\n"
    " [LIB_SELECT,\n"
    "  LIB_SYSTEM_WITH_MOD_HEADERS,\n"
    "  LIB_XNDLIB_WITH_MOD_HEADERS,\n"
    "  MOD_NDTYPES_WITH_SYSTEM_LIB,\n"
    "  MOD_XND_WITH_SYSTEM_LIB,\n"
    "  MOD_GUMATH_WITH_SYSTEM_LIB,\n"
    "  MOD_NDTYPES_WITH_XNDLIB,\n"
    "  MOD_XND_WITH_XNDLIB,\n"
    "  MOD_GUMATH_WITH_XNDLIB)")
endif()


# ==============================================================================
#                           Generators and build types
# ==============================================================================

get_property(MULTI_CONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(MULTI_CONFIG)
  set(MCP 1)
  if(CMAKE_GENERATOR MATCHES "Ninja Multi-Config")
    set(CMAKE_DEFAULT_BUILD_TYPE "Release" CACHE STRING
          "Ninja Multi-Config: choose the default build type.")
  endif()
else()
  set(MCP 0)
  set (CMAKE_BUILD_TYPE "Release" CACHE STRING
        "Single-Config: choose the build type.")
endif()


# ==============================================================================
#                                    Project 
# ==============================================================================

project(
  xndlib
  VERSION 0.3
  LANGUAGES C CXX)


# ==============================================================================
#                                      Cuda
# ==============================================================================

if(WITH_CUDA)
  include(CheckLanguage)
  check_language(CUDA)

  if(CMAKE_CUDA_COMPILER)
    enable_language(CUDA)
    set(HAVE_CUDA 1)
  else()
    set(HAVE_CUDA 0)
  endif()
else()
  set(HAVE_CUDA 0)
endif()


# ==============================================================================
#                           Compiler flags and functions
# ==============================================================================

include(Configure.cmake)


# ==============================================================================
#                               Headers and libraries
# ==============================================================================

find_package(Threads QUIET)
set(THREADS_PREFER_PTHREAD_FLAG TRUE)
check_include_file(pthread.h HAVE_PTHREAD_H)

check_include_file(unistd.h HAVE_UNISTD_H)


# ==============================================================================
#                                     Python
# ==============================================================================

# For tests and module builds:
message(STATUS "Looking for Python3 (optional, for the long library tests)")
find_package(Python3 3.8 OPTIONAL_COMPONENTS Interpreter Development.Module)

if(Python3_Interpreter_FOUND AND Python3_Development.Module_FOUND)
  set(HAVE_PYTHON 1)
else()
  set(HAVE_PYTHON 0)
endif()

if(MOD_SELECT AND NOT HAVE_PYTHON)
  message(FATAL_ERROR
    " MOD_SELECT=${MOD_SELECT} but Python3 could not be found.")
endif()


# ==============================================================================
#                                    Paths
# ==============================================================================

# Output paths:
set(INCLUDE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/$<IF:${MCP},$<CONFIG>,usr>/include")
include_directories (${INCLUDE_OUTPUT_DIRECTORY})

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/$<IF:${MCP},$<CONFIG>,usr>/bin")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/$<IF:${MCP},$<CONFIG>,usr>/lib")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/$<IF:${MCP},$<CONFIG>,usr>/lib")

set(MODULE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/$<IF:${MCP},$<CONFIG>,usr>/mod")

# Install paths:
if(LIB_XNDLIB_WITH_MOD_HEADERS)
  set(XND_INSTALL_BINDIR "${CMAKE_INSTALL_PREFIX}/xndlib/bin")
  set(XND_INSTALL_INCLUDEDIR "${CMAKE_INSTALL_PREFIX}/xndlib/include")
  set(XND_INSTALL_LIBDIR "${CMAKE_INSTALL_PREFIX}/xndlib/lib")
else()
  include(GNUInstallDirs)
  set(XND_INSTALL_BINDIR ${CMAKE_INSTALL_BINDIR})
  set(XND_INSTALL_INCLUDEDIR ${CMAKE_INSTALL_INCLUDEDIR})
  set(XND_INSTALL_LIBDIR ${CMAKE_INSTALL_LIBDIR})
endif()

if(MOD_WITH_XNDLIB)
  if(APPLE)
    set(MODULE_INSTALL_RPATH "@loader_path/../xndlib/lib")
  elseif(UNIX)
    set(MODULE_INSTALL_RPATH "$ORIGIN/../xndlib/lib")
  endif()
endif()

if(APPLE)
  set(CMAKE_INSTALL_RPATH "@loader_path")
elseif(UNIX)
  set(CMAKE_INSTALL_RPATH "$ORIGIN")
endif()


# ==============================================================================
#                                    Tests
# ==============================================================================

if(BUILD_NDTYPES)
  add_custom_target(ntest
    DEPENDS test_ndtypes
    COMMAND "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_ndtypes")

  if(HAVE_PYTHON)
    add_custom_target(nptest
      DEPENDS mod_ndtypes
      COMMAND "${Python3_EXECUTABLE}" "${MODULE_OUTPUT_DIRECTORY}/test_ndtypes.py")
  endif()
endif()

if(BUILD_XND)
  add_custom_target(xtest
    DEPENDS test_xnd
    COMMAND "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_xnd")

  if(HAVE_PYTHON)
    add_custom_target(xptest
      DEPENDS mod_ndtypes mod_xnd
      COMMAND "${Python3_EXECUTABLE}" "${MODULE_OUTPUT_DIRECTORY}/test_xnd.py")
  endif()
endif()

if(BUILD_GUMATH)
  if(HAVE_PYTHON)
    add_custom_target(gptest
      DEPENDS mod_ndtypes mod_xnd mod_gumath
      COMMAND "${Python3_EXECUTABLE}" "${MODULE_OUTPUT_DIRECTORY}/test_gumath.py")
  endif()
endif()


# ==============================================================================
#                                    config.h
# ==============================================================================

xnd_configure_file(config.h.in ${INCLUDE_OUTPUT_DIRECTORY}/config.h)


# ==============================================================================
#                                 Subdirectories
# ==============================================================================

if(MOD_WITH_SYSTEM_LIB)
  # Libraries are provided by the system.
  set(ROOT_PATH "")

  xnd_find_library(IMPORTED_NDTYPES "${ROOT_PATH}" "ndtypes")
  xnd_find_library(IMPORTED_XND "${ROOT_PATH}" "xnd")
  xnd_find_library(IMPORTED_GUMATH "${ROOT_PATH}" "gumath")
  xnd_find_library(IMPORTED_GUMATH_EXT "${ROOT_PATH}" "gumath_ext")

  add_library(ndtypes SHARED IMPORTED GLOBAL)
  set_target_properties(ndtypes PROPERTIES IMPORTED_LOCATION ${IMPORTED_NDTYPES})

  add_library(xnd SHARED IMPORTED GLOBAL)
  set_target_properties(xnd PROPERTIES IMPORTED_LOCATION ${IMPORTED_XND})

  add_library(gumath SHARED IMPORTED GLOBAL)
  set_target_properties(gumath PROPERTIES IMPORTED_LOCATION ${IMPORTED_GUMATH})

  add_library(gumath_ext SHARED IMPORTED GLOBAL)
  set_target_properties(gumath_ext PROPERTIES IMPORTED_LOCATION ${IMPORTED_GUMATH_EXT})
else()
  # Libraries are built from source.
  if(BUILD_NDTYPES)
    add_subdirectory(ndtypes)
  endif()

  if(BUILD_XND)
    add_subdirectory(xnd)
  endif()

  if(BUILD_GUMATH)
    add_subdirectory(gumath)
  endif()

  if(LIB_INSTALL_MOD_HEADERS)
    install(FILES
      ${CMAKE_SOURCE_DIR}/mod/ndtypes/pyndtypes.h
      ${CMAKE_SOURCE_DIR}/mod/xnd/pyxnd.h
      ${CMAKE_SOURCE_DIR}/mod/gumath/pygumath.h
      DESTINATION ${XND_INSTALL_INCLUDEDIR})
  endif()
endif()

if(HAVE_PYTHON)
  if(MOD_INSTALL)
    add_subdirectory(mod)
  else()
    add_subdirectory(mod EXCLUDE_FROM_ALL)
  endif()
endif()
