cmake_minimum_required(VERSION 3.19)

project(
  mod_tests
  VERSION 0.3
  LANGUAGES C CXX)

if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  add_compile_options(
    "$<$<COMPILE_LANGUAGE:C>:/wd4100;/wd4115;/wd4232;/wd4456>")
endif()

if(WIN32)
  set(MODULE_SUFFIX ".${Python3_SOABI}.pyd")
elseif(MSYS)
  set(MODULE_SUFFIX ".${Python3_SOABI}.dll")
else()
  set(MODULE_SUFFIX ".${Python3_SOABI}.so")
endif()

if(APPLE)
  add_link_options(
    "-undefined" "dynamic_lookup")
endif()

if(BUILD_MOD_NDTYPES)
  add_subdirectory(ndtypes)
endif()

if(BUILD_MOD_XND)
  add_subdirectory(xnd)
endif()

if(BUILD_MOD_GUMATH)
  add_subdirectory(gumath)
endif()

add_subdirectory(tests)
